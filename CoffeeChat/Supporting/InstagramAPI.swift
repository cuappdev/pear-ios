//
//  InstagramAPI.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 2/14/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

import Foundation

class InstagramAPI {
    
    static let shared: InstagramAPI = InstagramAPI()
    
    private let instagramAppID = Keys.instagramAppID
    private let redirectURIURLEncoded = "https%3A%2F%2Fwww.cornellappdev.com%2F"
    private let redirectURI = "https://www.cornellappdev.com/"
    private let appSecret = Keys.instagramAppSecret
    private let boundary = "boundary=\(NSUUID().uuidString)"
    
    private enum InstagramAPIBaseURL: String {
        case displayApi = "https://api.instagram.com/"
        case graphApi = "https://graph.instagram.com/"
    }
    
    private enum InstagramAPIMethod: String {
        case authorize = "oauth/authorize"
        case access_token = "oauth/access_token"
    }
    
    private init() {}
    
    private func getFormBody(_ parameters: [[String : String]], _ boundary: String) -> Data {
        var body = ""
        for param in parameters {
            let paramName = param["name"]!
            body += "--\(boundary)\r\n"
            body += "Content-Disposition:form-data; name=\"\(paramName)\""
            if let filename = param["fileName"] {
                let contentType = param["content-type"]!
                var fileContent: String = ""
                do { fileContent = try String(contentsOfFile: filename, encoding: .utf8)}
                catch {
                    print(error)
                }
                body += "; filename=\"\(filename)\"\r\n"
                body += "Content-Type: \(contentType)\r\n\r\n"
                body += fileContent
            } else if let paramValue = param["value"] {
                body += "\r\n\r\n\(paramValue)"
            }
        }
        return body.data(using: .utf8)!
    }
    
    private func getTokenFromCallbackURL(request: URLRequest) -> String? {
        let requestURLString = (request.url?.absoluteString)! as String
        print("here is request urk string", requestURLString)
        if requestURLString.starts(with: "\(redirectURI)?code=") {
            print("Response uri:",requestURLString)
            if let range = requestURLString.range(of: "\(redirectURI)?code=") {
                return String(requestURLString[range.upperBound...].dropLast(2))
            }
        }
        return nil
    }
    
    func authorizeApp(completion: @escaping (_ url: URL?) -> Void ) {
        
        let urlString = "\(InstagramAPIBaseURL.displayApi.rawValue)\(InstagramAPIMethod.authorize.rawValue)?app_id=\(instagramAppID)&redirect_uri=\(redirectURIURLEncoded)&scope=user_profile,user_media&response_type=code"
        
        let request = URLRequest(url: URL(string: urlString)!)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            if let response = response {
                print(response)
                completion(response.url)
            }
        })
        task.resume()
        
    }
    
    func getTestUserIDAndToken(request: URLRequest, completion: @escaping (InstagramTestUser) -> Void) {
        
        guard let authToken = getTokenFromCallbackURL(request: request) else { return }
        let headers = ["content-type": "multipart/form-data; boundary=\(boundary)"]
        let parameters = [
            ["name": "app_id", "value": instagramAppID],
            ["name": "app_secret", "value": appSecret],
            ["name": "grant_type", "value": "authorization_code"],
            ["name": "redirect_uri", "value": redirectURI],
            ["name": "code", "value": authToken]
        ]
        
        var request = URLRequest(url: URL(string: "\(InstagramAPIBaseURL.displayApi.rawValue)\(InstagramAPIMethod.access_token.rawValue)")!)
        
        let postData = getFormBody(parameters, boundary)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request, completionHandler: {(data, response, error) in
            if (error != nil) {
                print(error!)
            } else {
                do { let jsonData = try JSONDecoder().decode(InstagramTestUser.self, from: data!)
                    print(jsonData)
                    completion(jsonData)
                }
                catch let error as NSError {
                    print(error)
                }
                
            }
        })
        dataTask.resume()
    }

    
    func getInstagramUser(testUserData: InstagramTestUser, completion: @escaping (InstagramUser) -> Void) {
        
        let urlString = "\(InstagramAPIBaseURL.graphApi.rawValue)\(testUserData.user_id)?fields=id,username,media_count&access_token=\(testUserData.access_token)"
        let request = URLRequest(url: URL(string: urlString)!)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request, completionHandler: {(data, response, error) in
            if (error != nil) {
                print(error!)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse!)
            }
            do { let jsonData = try JSONDecoder().decode(InstagramUser.self, from: data!)
                completion(jsonData)
            }
            catch let error as NSError {
                print(error)
            }
        })
        dataTask.resume()
        
    }
    
}
