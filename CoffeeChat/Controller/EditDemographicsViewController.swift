//
//  EditDemographicsViewController.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 4/12/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

class EditDemographicsViewController: UIViewController {

    // MARK: - Private Data Vars
    // TODO: Get values from backend? Or store in UserDefaults?
    private let userName = "Lucy Xu"
    private let year = "Class of 2021"
    private let major = "Information Science"
    private let hometown = "Boston, MA"
    private let pronouns = "She/Her/Hers"
    // TODO: Update with networking values from backend
    private var classSearchFields: [String] = []
    private let hometownSearchFields = ["Boston, MA", "New York, NY", "Washington, DC", "Sacramento, CA", "Ithaca, NY"]
    private let majorSearchFields = ["Computer Science", "Economics", "Psychology", "English", "Government"]
    private let pronounSearchFields = ["She/Her/Hers", "He/Him/His", "They/Them/Theirs"]

    // MARK: - Private View Vars
    private let backButton = UIButton()
    private var backButtonItem: UIBarButtonItem!
    private let titleLabel = UILabel()
    private let saveButton = UIBarButtonItem()
    private let profileImageView = UIImageView()
    private let uploadPhotoButton = UIButton()
    private let nameTextField = UITextField()
    private var classDropdownView: OnboardingSelectDropdownView!
    private var hometownDropdownView: OnboardingSearchDropdownView!
    private var majorDropdownView: OnboardingSearchDropdownView!
    private var pronounsDropdownView: OnboardingSelectDropdownView!
    private let imagePickerController = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundLightGreen
        self.title = "Edit info"
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .black
        navigationController?.view.backgroundColor = .clear
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont._24CircularStdMedium,
//            NSAttributedString.Key.backgroundColor: UIColor.yellow
        ]

        backButton.setImage(UIImage(named: "back_arrow"), for: .normal)
        backButton.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
        backButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backButtonItem

        saveButton.title = "Save"
        saveButton.tintColor = .backgroundOrange
        saveButton.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont._20CircularStdMedium
        ], for: .normal)
        navigationItem.rightBarButtonItem = saveButton

        titleLabel.text = "Edit info"
        titleLabel.font = ._24CircularStdMedium
        view.addSubview(titleLabel)

        profileImageView.layer.backgroundColor = UIColor.inactiveGreen.cgColor
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = 62.5
        view.addSubview(profileImageView)

        uploadPhotoButton.setTitle("Upload New Picture", for: .normal)
        uploadPhotoButton.setTitleColor(.backgroundOrange, for: .normal)
        uploadPhotoButton.titleLabel?.font = ._12CircularStdMedium
        uploadPhotoButton.addTarget(self, action: #selector(uploadPhotoPressed), for: .touchUpInside)
        uploadPhotoButton.backgroundColor = .white
        uploadPhotoButton.layer.cornerRadius = 16
        uploadPhotoButton.layer.shadowColor = UIColor.black.cgColor
        uploadPhotoButton.layer.shadowOffset = CGSize(width: 0.0 , height: 2.0)
        uploadPhotoButton.layer.shadowOpacity = 0.15
        uploadPhotoButton.layer.shadowRadius = 2
        view.addSubview(uploadPhotoButton)

        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary

        nameTextField.backgroundColor = .backgroundWhite
        nameTextField.textColor = .textBlack
        nameTextField.font = ._20CircularStdBook
        nameTextField.text = userName
        nameTextField.clearButtonMode = .never
        nameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 49))
        nameTextField.leftViewMode = .always
        nameTextField.layer.cornerRadius = 8
        nameTextField.layer.shadowColor = UIColor.black.cgColor
        nameTextField.layer.shadowOffset = CGSize(width: 0.0 , height: 2.0)
        nameTextField.layer.shadowOpacity = 0.15
        nameTextField.layer.shadowRadius = 2
        view.addSubview(nameTextField)

        // Renders the valid graduation years based on current year.
        let currentYear = Calendar.current.component(.year, from: Date())
        let gradYear = currentYear + 4 // Allow only current undergrads and fifth years
        classSearchFields = (currentYear...gradYear).map { "\($0)" }

        classDropdownView = OnboardingSelectDropdownView(delegate: self, placeholder: "Class of...", tableData: classSearchFields, textTemplate: "Class of")
        classDropdownView.tag = 0 // Set tag to keep track of field selection status.
        classDropdownView.setSelectValue(value: year)
        view.addSubview(classDropdownView)

        majorDropdownView = OnboardingSearchDropdownView(delegate: self, placeholder: "Major", tableData: majorSearchFields)
        majorDropdownView.tag = 1 // Set tag to keep track of field selection status.
        majorDropdownView.setSelectValue(value: major)
        view.addSubview(majorDropdownView)

        hometownDropdownView = OnboardingSearchDropdownView(delegate: self, placeholder: "Hometown", tableData: hometownSearchFields)
        hometownDropdownView.tag = 2 // Set tag to keep track of field selection status.
        hometownDropdownView.setSelectValue(value: hometown)
        view.addSubview(hometownDropdownView)

        pronounsDropdownView = OnboardingSelectDropdownView(delegate: self, placeholder: "Pronouns", tableData: pronounSearchFields, textTemplate: "")
        pronounsDropdownView.tag = 3 // Set tag to keep track of field selection status.
        pronounsDropdownView.setSelectValue(value: pronouns)
        view.addSubview(pronounsDropdownView)

        setupConstraints()

    }

    func setupConstraints() {
        backButton.snp.makeConstraints { make in
            make.width.equalTo(14)
            make.height.equalTo(24)
        }

        profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.width.equalTo(125)
            make.top.equalToSuperview().offset(121)
        }

        uploadPhotoButton.snp.makeConstraints { make in
            make.centerX.equalTo(profileImageView)
            make.top.equalTo(profileImageView.snp.bottom).inset(20)
            make.width.equalTo(125)
            make.height.equalTo(31)
        }

        nameTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(profileImageView.snp.bottom).offset(63)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(49)
        }

        classDropdownView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameTextField.snp.top).offset(20+49)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(49)
        }

        majorDropdownView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(classDropdownView.snp.top).offset(20+49)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(49)
        }

        hometownDropdownView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(majorDropdownView.snp.top).offset(20+49)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(49)
        }

        pronounsDropdownView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(hometownDropdownView.snp.top).offset(20+49)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(49)
        }
    }

    @objc private func backPressed() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func savePressed() {
        print("save pressed")

    }

    @objc private func uploadPhotoPressed() {
        print("upload photo pressed")
        self.present(imagePickerController, animated: true, completion: nil)
    }

}

extension EditDemographicsViewController: OnboardingDropdownViewDelegate {

    func updateSelectedFields(tag: Int, isSelected: Bool) {
//        fieldsEntered[tag] = isSelected
//        let allFieldsEntered = !fieldsEntered.contains(false)
//        nextButton.isEnabled = allFieldsEntered
//        if nextButton.isEnabled {
//            nextButton.backgroundColor = .backgroundOrange
//            nextButton.layer.shadowColor = UIColor.black.cgColor
//            nextButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
//            nextButton.layer.shadowOpacity = 0.15
//            nextButton.layer.shadowRadius = 2
//        } else {
//            nextButton.backgroundColor = .inactiveGreen
//            nextButton.layer.shadowColor = .none
//            nextButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
//            nextButton.layer.shadowOpacity = 0
//            nextButton.layer.shadowRadius = 0
//        }
    }

    /// Resizes search view based on input to search field
    func updateDropdownViewHeight(dropdownView: UIView, height: CGFloat) {
        view.bringSubviewToFront(dropdownView)
//        updateFieldConstraints(fieldView: dropdownView, height: textFieldHeight + height)
    }

    func bringDropdownViewToFront(dropdownView: UIView, height: CGFloat, isSelect: Bool) {
        view.bringSubviewToFront(dropdownView)
//        if let activeDropdownView = activeDropdownView as? OnboardingSearchDropdownView {
//             view.sendSubviewToBack(activeDropdownView)
//             updateFieldConstraints(fieldView: activeDropdownView, height: textFieldHeight)
//            activeDropdownView.hideTableView()
//        } else if let activeDropdownView = activeDropdownView as? OnboardingSearchDropdownView {
//            view.sendSubviewToBack(activeDropdownView)
//             updateFieldConstraints(fieldView: activeDropdownView, height: textFieldHeight)
//            activeDropdownView.hideTableView()
//        }
//        if isSelect {
//            view.endEditing(true)
//        }
//        activeDropdownView = dropdownView
//        updateFieldConstraints(fieldView: dropdownView, height: textFieldHeight + height)
    }

    func sendDropdownViewToBack(dropdownView: UIView) {
//        view.sendSubviewToBack(dropdownView)
//        updateFieldConstraints(fieldView: dropdownView, height: textFieldHeight)
//        view.endEditing(true)
    }
}

extension EditDemographicsViewController:  UIImagePickerControllerDelegate {

//    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        self.imagePickerController(picker, didSelect: nil)
//    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        profileImageView.image = image
        dismiss(animated: true, completion: nil)
    }
}

extension EditDemographicsViewController: UINavigationControllerDelegate {

}
