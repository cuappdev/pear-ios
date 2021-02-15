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
    
    private init() {}
    
    /// getFormBody returns the form data generated from key value pairs
    private func getFormBody(_ parameters: [[String : String]], _ boundary: String) -> Data {
        
        var body = ""
        for parameter in parameters {
            let parameterName = parameter["name"]!
            body += "--\(boundary)\r\n"
            body += "Content-Disposition:form-data; name=\"\(parameterName)\""
            if let filename = parameter["fileName"] {
                let contentType = parameter["content-type"]!
                var fileContent: String = ""
                do { fileContent = try String(contentsOfFile: filename, encoding: .utf8) }
                catch {
                    print(error)
                }
                body += "; filename=\"\(filename)\"\r\n"
                body += "Content-Type: \(contentType)\r\n\r\n"
                body += fileContent
            } else if let paramValue = parameter["value"] {
                body += "\r\n\r\n\(paramValue)"
            }
        }
        
        return body.data(using: .utf8)!
        
    }
    
    /// getTokenFromCallbackURL retrieves the authorization token from callback URL
    private func getTokenFromCallbackURL(request: URLRequest) -> String? {
        
        let requestURLString = (request.url?.absoluteString)! as String
        if requestURLString.starts(with: "\(redirectURI)?code=") {
            if let range = requestURLString.range(of: "\(redirectURI)?code=") {
                return String(requestURLString[range.upperBound...].dropLast(2))
            }
        }
        return nil
        
    }
    
    func authorizeApplication(completion: @escaping (_ url: URL?) -> Void ) {
        
        let baseURL = "https://api.instagram.com/"
        let oauthMethod = "oauth/authorize"
        let scope = ["user_profile", "user_media"].joined(separator: ",")
        
        let urlString = "\(baseURL)\(oauthMethod)?app_id=\(instagramAppID)&redirect_uri=\(redirectURIURLEncoded)&scope=\(scope)&response_type=code"
        
        guard let url = URL(string: urlString) else { return }
        let requestURL = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: requestURL, completionHandler: { data, response, error in
            if let response = response {
                completion(response.url)
            }
        })
        task.resume()
        
    }
    
    func getInstagramAuthentication(request: URLRequest, completion: @escaping (InstagramAuthentication) -> Void) {
        
        guard let authToken = getTokenFromCallbackURL(request: request) else { return }
        let baseURL = "https://api.instagram.com/"
        let oauthMethod = "oauth/access_token"
        guard let url = URL(string: "\(baseURL)\(oauthMethod)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = ["content-type": "multipart/form-data; boundary=\(boundary)"]
        let parameters = [
            ["name": "app_id", "value": instagramAppID],
            ["name": "app_secret", "value": appSecret],
            ["name": "grant_type", "value": "authorization_code"],
            ["name": "redirect_uri", "value": redirectURI],
            ["name": "code", "value": authToken]
        ]
        let postData = getFormBody(parameters, boundary)
        request.httpBody = postData
        
        let dataTask = URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
            guard let data = data else { return }
            if let jsonData = try? JSONDecoder().decode(InstagramAuthentication.self, from: data) {
                completion(jsonData)
            }
        })
        dataTask.resume()
    }

    
    func getInstagramUser(testUserData: InstagramAuthentication, completion: @escaping (InstagramUser) -> Void) {
        
        let baseURL = "https://graph.instagram.com/"
        let fields = ["id", "username", "media_count"].joined(separator: ",")
        
        let urlString = "\(baseURL)\(testUserData.user_id)?fields=\(fields)&access_token=\(testUserData.access_token)"
        guard let url = URL(string: urlString) else { return }
        
        let request = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
            guard let data = data else { return }
            if let jsonData = try? JSONDecoder().decode(InstagramUser.self, from: data) {
                completion(jsonData)
            }
        })
        dataTask.resume()
        
    }
    
}
