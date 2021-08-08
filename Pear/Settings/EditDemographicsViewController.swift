//
//  EditDemographicsViewController.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 4/12/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import Kingfisher
import UIKit

class EditDemographicsViewController: UIViewController {

    // MARK: - Private Data Vars
    private var classSearchFields: [String] = []
    private var fieldsEntered: [Bool] = [true, true, true, true, true] // Keep track of fields that have been entered
    private var majorSearchFields: [String] = []
    private let pronounSearchFields = Constants.Options.pronounSearchFields
    private var user: UserV2
    private var demographics = Demographics(name: nil, graduationYear: nil, major: nil, hometown: nil, pronouns: nil)

    // MARK: - Private View Vars
    private var activeDropdownView: UIView? // Keep track of currently active field
    private var backBarButtonItem: UIBarButtonItem!
    private let backButton = UIButton()
    private var classDropdownView: OnboardingSelectDropdownView!
    private let editScrollView = UIScrollView()
    private var hometownDropdownView: OnboardingSearchDropdownView!
    private let imagePickerController = UIImagePickerController()
    private var majorDropdownView: OnboardingSearchDropdownView!
    private let nameTextField = UITextField()
    private let profileImageView = UIImageView()
    private var pronounsDropdownView: OnboardingSelectDropdownView!
    private let saveBarButtonItem = UIBarButtonItem()
    private let uploadPhotoButton = UIButton()

    // MARK: - Private Data Variables
    private let textFieldHeight: CGFloat = 49
    // Keep track of if view scrolled to fit content
    private var isPageScrolled: Bool = false
    private var didUpdatePhoto = false

    init(user: UserV2) {
        self.user = user
        demographics.name = "\(user.firstName) \(user.lastName)"
        demographics.graduationYear = user.graduationYear
//        demographics.major = user.major
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

        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = .backgroundLightGreen
        navigationController?.navigationBar.shadowImage = UIImage() // Hide navigation bar bottom shadow
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.getFont(.medium, size: 24)
        ]
        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)

        saveBarButtonItem.title = "Save"
        saveBarButtonItem.tintColor = .darkGreen
        saveBarButtonItem.setTitleTextAttributes([
            .font: UIFont.getFont(.medium, size: 20)
        ], for: .normal)
        saveBarButtonItem.target = self
        saveBarButtonItem.action = #selector(savePressed)
        navigationItem.rightBarButtonItem = saveBarButtonItem

        editScrollView.isScrollEnabled = false
        editScrollView.showsVerticalScrollIndicator = false
        editScrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        view.addSubview(editScrollView)

        profileImageView.layer.backgroundColor = UIColor.inactiveGreen.cgColor
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.masksToBounds = true
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 62.5
        
        editScrollView.addSubview(profileImageView)

        uploadPhotoButton.setTitle("Upload New Picture", for: .normal)
        uploadPhotoButton.setTitleColor(.backgroundOrange, for: .normal)
        uploadPhotoButton.titleLabel?.font = ._12CircularStdMedium
        uploadPhotoButton.addTarget(self, action: #selector(uploadPhotoPressed), for: .touchUpInside)
        uploadPhotoButton.backgroundColor = .white
        uploadPhotoButton.layer.cornerRadius = 16
        uploadPhotoButton.layer.shadowColor = UIColor.black.cgColor
        uploadPhotoButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        uploadPhotoButton.layer.shadowOpacity = 0.15
        uploadPhotoButton.layer.shadowRadius = 2
        editScrollView.addSubview(uploadPhotoButton)

        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true

        nameTextField.delegate = self
        nameTextField.tag = 0
        nameTextField.backgroundColor = .backgroundWhite
        nameTextField.textColor = .black
        nameTextField.font = ._20CircularStdBook
        nameTextField.text = "\(user.firstName) \(user.lastName)"
        nameTextField.clearButtonMode = .never
        nameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 49))
        nameTextField.leftViewMode = .always
        nameTextField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 49))
        nameTextField.rightViewMode = .always
        nameTextField.layer.cornerRadius = 8
        nameTextField.layer.shadowColor = UIColor.black.cgColor
        nameTextField.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        nameTextField.layer.shadowOpacity = 0.15
        nameTextField.layer.shadowRadius = 2
        editScrollView.addSubview(nameTextField)

        // Renders the valid graduation years based on current year.
        let currentYear = Calendar.current.component(.year, from: Date())
        let gradYear = currentYear + 4 // Allow only current undergrads and fifth years
        classSearchFields = (currentYear...gradYear).map { "\($0)" }

        classDropdownView = OnboardingSelectDropdownView(delegate: self,
                                                         placeholder: "Class of...",
                                                         tableData: classSearchFields,
                                                         textTemplate: "Class of")
        classDropdownView.tag = 1 // Set tag to keep track of field selection status.
        classDropdownView.setSelectValue(value: user.graduationYear ?? "")
        editScrollView.addSubview(classDropdownView)

        majorDropdownView = OnboardingSearchDropdownView(
            delegate: self,
            placeholder: "Major",
            tableData: majorSearchFields,
            searchType: .local
        )
        majorDropdownView.tag = 2 // Set tag to keep track of field selection status.
//        majorDropdownView.setSelectValue(value: user.major)
        editScrollView.addSubview(majorDropdownView)

        hometownDropdownView = OnboardingSearchDropdownView(
            delegate: self,
            placeholder: "City, State, Country",
            tableData: [],
            searchType: .places
        )
        hometownDropdownView.tag = 3 // Set tag to keep track of field selection status.
        hometownDropdownView.setSelectValue(value: user.hometown ?? "")
        editScrollView.addSubview(hometownDropdownView)

        pronounsDropdownView = OnboardingSelectDropdownView(delegate: self,
                                                            placeholder: "Pronouns",
                                                            tableData: pronounSearchFields, textTemplate: "")
        pronounsDropdownView.tag = 4 // Set tag to keep track of field selection status.
        pronounsDropdownView.setSelectValue(value: user.pronouns ?? "")
        editScrollView.addSubview(pronounsDropdownView)

        setupConstraints()
        getMajors()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    private func setupConstraints() {
        let textFieldHeight: CGFloat = 49
        let textFieldSidePadding: CGFloat = 40
        let textFieldTopPadding: CGFloat = 20
        let textFieldTotalPadding: CGFloat = textFieldHeight + textFieldTopPadding

        backButton.snp.makeConstraints { make in
            make.size.equalTo(Constants.Onboarding.backButtonSize)
        }

        editScrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        profileImageView.snp.makeConstraints { make in
            make.centerX.equalTo(editScrollView)
            make.height.width.equalTo(120)
            make.top.equalTo(editScrollView).offset(50)
        }

        uploadPhotoButton.snp.makeConstraints { make in
            make.centerX.equalTo(profileImageView)
            make.top.equalTo(profileImageView.snp.bottom).inset(20)
            make.width.equalTo(130)
            make.height.equalTo(31)
        }

        nameTextField.snp.makeConstraints { make in
            make.centerX.equalTo(editScrollView)
            make.top.equalTo(profileImageView.snp.bottom).offset(63)
            make.leading.equalTo(editScrollView).offset(textFieldSidePadding)
            make.height.equalTo(textFieldHeight)
        }

        classDropdownView.snp.makeConstraints { make in
            make.centerX.equalTo(editScrollView)
            make.top.equalTo(nameTextField.snp.top).offset(textFieldTotalPadding)
            make.leading.equalTo(editScrollView).offset(textFieldSidePadding)
            make.height.equalTo(textFieldHeight)
        }

        majorDropdownView.snp.makeConstraints { make in
            make.centerX.equalTo(editScrollView)
            make.top.equalTo(classDropdownView.snp.top).offset(textFieldTotalPadding)
            make.leading.equalTo(editScrollView).offset(textFieldSidePadding)
            make.height.equalTo(textFieldHeight)
        }

        hometownDropdownView.snp.makeConstraints { make in
            make.centerX.equalTo(editScrollView)
            make.top.equalTo(majorDropdownView.snp.top).offset(textFieldTotalPadding)
            make.leading.equalTo(editScrollView).offset(textFieldSidePadding)
            make.height.equalTo(textFieldHeight)
        }

        pronounsDropdownView.snp.makeConstraints { make in
            make.centerX.equalTo(editScrollView)
            make.top.equalTo(hometownDropdownView.snp.top).offset(textFieldTotalPadding)
            make.leading.equalTo(editScrollView).offset(textFieldSidePadding)
            make.height.equalTo(textFieldHeight)
        }
    }

    private func getMajors() {
        Networking2.getAllMajors { [weak self] majors in
            guard let self = self else { return }
            DispatchQueue.main.async {
                let majorsData = majors.map { $0.name }
                self.majorDropdownView.setTableData(tableData: majorsData)
            }
        }
    }

    @objc private func backPressed() {
        navigationController?.popViewController(animated: true)
    }

    private func saveProfile(profilePictureURL: String) {
        if let graduationYear = demographics.graduationYear,
           let major = demographics.major,
           let hometown = demographics.hometown,
           let pronouns = demographics.pronouns {
            Networking2.updateProfile(
                graduationYear: graduationYear,
                major: major,
                hometown: hometown,
                pronouns: pronouns,
                profilePicUrl: profilePictureURL) { [weak self] success in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        if success {
                            self.navigationController?.popViewController(animated: true)
                        } else {
                            self.present(UIAlertController.getStandardErrortAlert(), animated: true)
                        }
                    }
            }
        }
    }

    @objc private func savePressed() {
        print("save pressed")
        if didUpdatePhoto {
            if let profileImageBase64 = profileImageView.image?.pngData()?.base64EncodedString() {
                NetworkManager.shared.uploadPhoto(base64: profileImageBase64).observe { [weak self] result in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        switch result {
                        case .value(let response):
                            if response.success {
                                self.saveProfile(profilePictureURL: response.data)
                            } else {
                                self.present(UIAlertController.getStandardErrortAlert(), animated: true)
                            }
                        case .error:
                            self.present(UIAlertController.getStandardErrortAlert(), animated: true)
                        }
                    }
                }
            }
        } else {
            saveProfile(profilePictureURL: user.profilePicUrl)
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
            }
            if tag == 2 {
                demographics.major = valueSelected
            }
            if tag == 3 {
                demographics.hometown = valueSelected
            }
            if tag == 4 {
                demographics.pronouns = valueSelected
            }
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
        if let activeDropdownView = activeDropdownView as? OnboardingSearchDropdownView,
            activeDropdownView != dropdownView {
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
            editScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            isPageScrolled = false
        }
    }
}

extension EditDemographicsViewController: UIImagePickerControllerDelegate,
                                          UINavigationControllerDelegate,
                                          UITextFieldDelegate {

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
        dismiss(animated: true, completion: nil)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeDropdownView = textField
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
