//

//  EditDemographicsViewController.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 4/12/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import FirebaseAnalytics
import Kingfisher
import UIKit

protocol EditDemographicsViewControllerDelegate {
    func didUpdateProfilePicture(image: UIImage?, url: String)
}

protocol didEditDemographicsDelegate {
    func updateDemographics(updatedUser: UserV2)
}

class EditDemographicsViewController: UIViewController {

    // MARK: - Private Data Vars
    private var classSearchFields: [String] = []
    private var fieldsEntered = Array(repeating: true, count: 5) // Keep track of fields that have been entered
    private var majorSearchFields: [MajorV2] = []
    private let pronounSearchFields = Constants.Options.pronounSearchFields
    private var user: UserV2
    private var demographics = Demographics()

    // MARK: - Private View Vars
    private var activeDropdownView: UIView? // Keep track of currently active field
    private var classDropdownView: OnboardingSelectDropdownView!
    private let editScrollView = UIScrollView()
    private var hometownDropdownView: OnboardingSearchDropdownView!
    private let imagePickerController = UIImagePickerController()
    private var majorDropdownView: OnboardingSearchDropdownView!
    private let nameTextField = UITextField()
    private let profileImageView = UIImageView()
    private var pronounsDropdownView: OnboardingSearchDropdownView!
    private let uploadPhotoButton = UIButton()

    // MARK: - Private Data Variables
    private let textFieldHeight: CGFloat = 49
    // Keep track of if view scrolled to fit content
    private var isPageScrolled = false
    private var didUpdatePhoto = false
    private let profileImageSize = CGSize(width: 120, height: 120)
    private let uploadPhotoButtonHeight: CGFloat = 31
    
    var delegate: EditDemographicsViewControllerDelegate?
    var settingsDelegate: didEditDemographicsDelegate?
    weak var profileDelegate: ProfileMenuDelegate?

    init(user: UserV2, delegate: didEditDemographicsDelegate) {
        self.user = user
        self.settingsDelegate = delegate
        demographics.name = "\(user.firstName) \(user.lastName)"
        demographics.graduationYear = user.graduationYear
        demographics.major = user.majors.first?.name
        demographics.hometown = user.hometown
        demographics.pronouns = user.pronouns
        if let profilePictureURL = URL(string: user.profilePicUrl) {
            profileImageView.kf.setImage(with: profilePictureURL)
        }
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundLightGreen
        self.title = "Edit info"

        editScrollView.isScrollEnabled = false
        editScrollView.showsVerticalScrollIndicator = false
        editScrollView.contentSize = view.frame.size
        view.addSubview(editScrollView)

        profileImageView.layer.backgroundColor = UIColor.inactiveGreen.cgColor
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.masksToBounds = true
        profileImageView.clipsToBounds = true
        editScrollView.addSubview(profileImageView)

        uploadPhotoButton.setTitle("Upload New Picture", for: .normal)
        uploadPhotoButton.setTitleColor(.backgroundOrange, for: .normal)
        uploadPhotoButton.titleLabel?.font = ._12CircularStdMedium
        uploadPhotoButton.addTarget(self, action: #selector(uploadPhotoPressed), for: .touchUpInside)
        uploadPhotoButton.backgroundColor = .white
        uploadPhotoButton.layer.shadowColor = UIColor.black.cgColor
        uploadPhotoButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        uploadPhotoButton.layer.shadowOpacity = 0.15
        uploadPhotoButton.layer.shadowRadius = 2
        editScrollView.addSubview(uploadPhotoButton)

        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true

        setupDemographicsTextField(textField: nameTextField, text: "\(user.firstName) \(user.lastName)")
        nameTextField.isEnabled = true
        nameTextField.tag = 0
        editScrollView.addSubview(nameTextField)

        // Renders the valid graduation years based on current year.
        let currentYear = Calendar.current.component(.year, from: Date())
        let gradYear = currentYear + 4 // Allow only current undergrads and fifth years
        classSearchFields = (currentYear...gradYear).map { "\($0)" }

        classDropdownView = OnboardingSelectDropdownView(
            delegate: self,
            placeholder: "Class of...",
            tableData: classSearchFields,
            textTemplate: "Class of"
        )
        classDropdownView.tag = 1 // Set tag to keep track of field selection status.
        classDropdownView.setSelectValue(value: user.graduationYear ?? "")
        editScrollView.addSubview(classDropdownView)

        majorDropdownView = OnboardingSearchDropdownView(
            delegate: self,
            placeholder: "Major",
            tableData: majorSearchFields.map(\.name),
            searchType: .local
        )
        majorDropdownView.tag = 2 // Set tag to keep track of field selection status.
        majorDropdownView.setSelectValue(value: user.majors.first?.name ?? "")
        editScrollView.addSubview(majorDropdownView)

        hometownDropdownView = OnboardingSearchDropdownView(
            delegate: self,
            placeholder: "Hometown",
            tableData: [],
            searchType: .places
        )
        hometownDropdownView.tag = 3 // Set tag to keep track of field selection status.
        hometownDropdownView.setSelectValue(value: user.hometown ?? "")
        editScrollView.addSubview(hometownDropdownView)

        pronounsDropdownView = OnboardingSearchDropdownView(
            delegate: self,
            placeholder: "Pronouns",
            tableData: [],
            searchType: .pronouns
        )
        pronounsDropdownView.tag = 4 // Set tag to keep track of field selection status.
        pronounsDropdownView.setSelectValue(value: user.pronouns ?? "")
        editScrollView.addSubview(pronounsDropdownView)

        setupConstraints()
        getMajors()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        Analytics.logEvent(Constants.Analytics.openedViewController, parameters: ["name" : Constants.Analytics.TrackedVCs.editProfile])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        uploadPhotoButton.layer.cornerRadius = uploadPhotoButton.frame.height / 2
    }
    private func setupDemographicsTextField(textField: UITextField, text: String) {
        textField.delegate = self
        textField.backgroundColor = .backgroundWhite
        textField.textColor = .black
        textField.font = ._20CircularStdBook
        textField.text = text
        textField.clearButtonMode = .never
        let textFieldRect = CGRect(x: 0, y: 0, width: 12, height: 49)
        textField.leftView = UIView(frame: textFieldRect)
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: textFieldRect)
        textField.rightViewMode = .always
        textField.layer.cornerRadius = 8
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        textField.layer.shadowOpacity = 0.15
        textField.layer.shadowRadius = 2
    }

    private func setupConstraints() {
        let textFieldSidePadding: CGFloat = 40
        let textFieldTopPadding: CGFloat = 20
        let textFieldTotalPadding = textFieldHeight + textFieldTopPadding

        editScrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalTo(editScrollView)
            make.size.equalTo(profileImageSize)
            make.top.equalTo(editScrollView).offset(50)
        }
        
        uploadPhotoButton.snp.makeConstraints { make in
            make.centerX.equalTo(profileImageView)
            make.top.equalTo(profileImageView.snp.bottom).inset(20)
            make.width.equalTo(130)
            make.height.equalTo(uploadPhotoButtonHeight)
        }

        [nameTextField, classDropdownView, majorDropdownView, hometownDropdownView, pronounsDropdownView].forEach { subView in
            subView.snp.makeConstraints { make in
               make.centerX.equalTo(editScrollView)
               make.height.equalTo(textFieldHeight)
            }
         }
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(63)
            make.leading.equalTo(editScrollView).offset(textFieldSidePadding)
        }
        classDropdownView.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.top).offset(textFieldTotalPadding)
            make.leading.equalTo(editScrollView).offset(textFieldSidePadding)
        }
        majorDropdownView.snp.makeConstraints { make in
            make.top.equalTo(classDropdownView.snp.top).offset(textFieldTotalPadding)
            make.leading.equalTo(editScrollView).offset(textFieldSidePadding)
        }
        hometownDropdownView.snp.makeConstraints { make in
            make.top.equalTo(majorDropdownView.snp.top).offset(textFieldTotalPadding)
            make.leading.equalTo(editScrollView).offset(textFieldSidePadding)
        }
        pronounsDropdownView.snp.makeConstraints { make in
            make.top.equalTo(hometownDropdownView.snp.top).offset(textFieldTotalPadding)
            make.leading.equalTo(editScrollView).offset(textFieldSidePadding)
        }
    }

    private func getMajors() {
        NetworkManager.getAllMajors { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let majors):
                DispatchQueue.main.async {
                    let majorsData = majors.map(\.name)
                    self.majorSearchFields = majors
                    self.majorDropdownView.setTableData(tableData: majorsData)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    private func saveProfile(profilePictureURL: String) {
        if let graduationYear = demographics.graduationYear,
           let major = demographics.major,
           let hometown = demographics.hometown,
           let pronouns = demographics.pronouns,
           let matchingMajor = majorSearchFields.first(where: { $0.name == major }) {
            NetworkManager.updateProfile(
                graduationYear: graduationYear,
                majors: [matchingMajor.id],
                hometown: hometown,
                pronouns: pronouns,
                profilePicUrl: profilePictureURL) { [weak self] success in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        if success {
                            self.delegate?.didUpdateProfilePicture(image: self.profileImageView.image, url: profilePictureURL)
                            self.profileDelegate?.didUpdateProfileDemographics()
                            self.navigationController?.popViewController(animated: true)
                        } else {
                            self.present(UIAlertController.getStandardErrortAlert(), animated: true)
                        }
                    }
            }
        }
    }
    
    @objc private func savePressed() {
        guard didUpdatePhoto else {
            saveProfile(profilePictureURL: user.profilePicUrl)
            return
        }
        
        if let profileImageBase64 = profileImageView.image?.pngData()?.base64EncodedString() {
            NetworkManager.uploadPhoto(base64: profileImageBase64) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let base64Img):
                    DispatchQueue.main.async {
                        self.saveProfile(profilePictureURL: base64Img)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }

    }

    @objc private func uploadPhotoPressed() {
        // TODO: Save image to backend.
        self.present(imagePickerController, animated: true, completion: nil)
    }

    /// Update height constraint of field inputs to show dropdown menus.
    private func updateFieldConstraints(fieldView: UIView, height: CGFloat) {
        fieldView.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
    }

}

extension EditDemographicsViewController: OnboardingDropdownViewDelegate {

    func updateSelectedFields(tag: Int, isSelected: Bool, valueSelected: String) {
        fieldsEntered[tag] = isSelected
        if isSelected {
            if tag == 1 {
                demographics.graduationYear = valueSelected
                user.graduationYear = valueSelected
            } else if tag == 2 {
                demographics.major = valueSelected
                // Update the user's majors to be passed back via delegation later
                if let major = majorSearchFields.first(where: { $0.name == demographics.major }) {
                    user.majors = [major]
                }
            } else if tag == 3 {
                demographics.hometown = valueSelected
                user.hometown = valueSelected
            } else if tag == 4 {
                demographics.pronouns = valueSelected
                user.pronouns = valueSelected
            }
            // Update the user's information on the previous profile screen (previous VC is also where networking happens)
            settingsDelegate?.updateDemographics(updatedUser: user)
        }
    }

    /// Resizes search view based on input to search field.
    func updateDropdownViewHeight(dropdownView: UIView, height: CGFloat) {
        editScrollView.bringSubviewToFront(dropdownView)
        updateFieldConstraints(fieldView: dropdownView, height: textFieldHeight + height)
    }

    /// Brings field view to the front of the screen and handles keyboard interactions
    /// when switching from select dropdowns to search.
    func bringDropdownViewToFront(dropdownView: UIView, height: CGFloat, isSelect: Bool) {
        if let activeDropdownView = activeDropdownView as? OnboardingSearchDropdownView, activeDropdownView != dropdownView {
                editScrollView.sendSubviewToBack(activeDropdownView)
                updateFieldConstraints(fieldView: activeDropdownView, height: textFieldHeight)
                activeDropdownView.hideTableView()
                activeDropdownView.endEditing(true)
        } else if let activeDropdownView = activeDropdownView as? OnboardingSelectDropdownView,
            activeDropdownView != dropdownView {
                editScrollView.sendSubviewToBack(activeDropdownView)
                updateFieldConstraints(fieldView: activeDropdownView, height: textFieldHeight)
                activeDropdownView.hideTableView()
        } else if let activeDropdownView = activeDropdownView as? UITextField {
            activeDropdownView.endEditing(true)
        }
        editScrollView.bringSubviewToFront(dropdownView)
        activeDropdownView = dropdownView
        let newFieldHeight = textFieldHeight + height
        updateFieldConstraints(fieldView: dropdownView, height: newFieldHeight)
        // Scroll screen up if dropdown field extends past bottom of screen
        if dropdownView.frame.origin.y + newFieldHeight > view.bounds.height - 50 {
            isPageScrolled = true
            editScrollView.setContentOffset(CGPoint(x: 0, y: height), animated: true)
        }
    }

    /// Send field view to the back of the screen to allow interactions with other field views.
    func sendDropdownViewToBack(dropdownView: UIView) {
        view.endEditing(true)
        editScrollView.sendSubviewToBack(dropdownView)
        updateFieldConstraints(fieldView: dropdownView, height: textFieldHeight)
        if isPageScrolled {
            editScrollView.setContentOffset(CGPoint.zero, animated: true)
            isPageScrolled = false
        }
    }
    
}

extension EditDemographicsViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeDropdownView = textField
    }
    
    // Update the user's name field via the delegate once the user hits "return" on their keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            // Split up the name text field into first + last name, separated by a space
            if let fullName = nameTextField.text {
                let nameArray = fullName.components(separatedBy: " ")
                self.user.firstName = nameArray[0]
                self.user.lastName = nameArray[1]
                settingsDelegate?.updateDemographics(updatedUser: self.user)
            }
        }
        textField.resignFirstResponder()
        return false
    }
}

extension EditDemographicsViewController: UIImagePickerControllerDelegate,
                                          UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        var image: UIImage!

        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            image = img
        } else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = img
        }

        profileImageView.image = image.resize(toSize: CGSize(width: 100, height: 100))
        didUpdatePhoto = true
        // Specifically for updating a user's images on the frontend and the backend
        if let profileImageBase64 = profileImageView.image?.pngData()?.base64EncodedString() {
            NetworkManager.uploadPhoto(base64: profileImageBase64) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let base64Img):
                    DispatchQueue.main.async {
                        self.user.profilePicUrl = base64Img
                        self.settingsDelegate?.updateDemographics(updatedUser: self.user)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
}


extension EditDemographicsViewController: UIGestureRecognizerDelegate {

      func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
         if gestureRecognizer == navigationController?.interactivePopGestureRecognizer {
             navigationController?.popViewController(animated: true)
         }
         return false
     }

  }
