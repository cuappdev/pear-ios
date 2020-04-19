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
    private let name = "Lucy Xu"
    private let year = "2021"
    private let major = "Computer Science"
    private let hometown = "Boston, MA"
    private let pronouns = "She/Her/Hers"
    // TODO: Update with networking values from backend
    private var classSearchFields: [String] = []
    private var fieldsEntered: [Bool] = [true, true, true, true, true]
    private let hometownSearchFields = ["Boston, MA", "New York, NY", "Washington, DC", "Sacramento, CA", "Ithaca, NY"]
    private let majorSearchFields = ["Computer Science", "Economics", "Psychology", "English", "Government"]
    private let pronounSearchFields = ["She/Her/Hers", "He/Him/His", "They/Them/Theirs"]

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

    // MARK: - Private Constants
    private let textFieldHeight: CGFloat = 49
    private var isPageScrolled: Bool = false
    private var scrollContentOffset: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundLightGreen
        self.title = "Edit info"
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = .backgroundLightGreen
        navigationController?.navigationBar.shadowImage = UIImage() // Hide navigation bar bottom shadow
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.getFont(.medium, size: 24),
        ]
        
        backButton.setImage(UIImage(named: "back_arrow"), for: .normal)
        backButton.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
        backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem

        saveBarButtonItem.title = "Save"
        saveBarButtonItem.tintColor = .darkGreen
        saveBarButtonItem.setTitleTextAttributes([
            .font: UIFont.getFont(.medium, size: 20)
        ], for: .normal)
        navigationItem.rightBarButtonItem = saveBarButtonItem

        editScrollView.isScrollEnabled = false
        editScrollView.showsVerticalScrollIndicator = false
        editScrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        editScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        view.addSubview(editScrollView)

        profileImageView.layer.backgroundColor = UIColor.inactiveGreen.cgColor
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = 62.5
        editScrollView.addSubview(profileImageView)

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
        editScrollView.addSubview(uploadPhotoButton)

        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary

        nameTextField.delegate = self
        nameTextField.tag = 0
        nameTextField.backgroundColor = .backgroundWhite
        nameTextField.textColor = .textBlack
        nameTextField.font = ._20CircularStdBook
        nameTextField.text = name
        nameTextField.clearButtonMode = .never
        nameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 49))
        nameTextField.leftViewMode = .always
        nameTextField.layer.cornerRadius = 8
        nameTextField.layer.shadowColor = UIColor.black.cgColor
        nameTextField.layer.shadowOffset = CGSize(width: 0.0 , height: 2.0)
        nameTextField.layer.shadowOpacity = 0.15
        nameTextField.layer.shadowRadius = 2
        editScrollView.addSubview(nameTextField)

        // Renders the valid graduation years based on current year.
        let currentYear = Calendar.current.component(.year, from: Date())
        let gradYear = currentYear + 4 // Allow only current undergrads and fifth years
        classSearchFields = (currentYear...gradYear).map { "\($0)" }

        classDropdownView = OnboardingSelectDropdownView(delegate: self, placeholder: "Class of...", tableData: classSearchFields, textTemplate: "Class of")
        classDropdownView.tag = 1 // Set tag to keep track of field selection status.
        classDropdownView.setSelectValue(value: year)
        editScrollView.addSubview(classDropdownView)

        majorDropdownView = OnboardingSearchDropdownView(delegate: self, placeholder: "Major", tableData: majorSearchFields)
        majorDropdownView.tag = 2 // Set tag to keep track of field selection status.
        majorDropdownView.setSelectValue(value: major)
        editScrollView.addSubview(majorDropdownView)

        hometownDropdownView = OnboardingSearchDropdownView(delegate: self, placeholder: "Hometown", tableData: hometownSearchFields)
        hometownDropdownView.tag = 3 // Set tag to keep track of field selection status.
        hometownDropdownView.setSelectValue(value: hometown)
        editScrollView.addSubview(hometownDropdownView)

        pronounsDropdownView = OnboardingSelectDropdownView(delegate: self, placeholder: "Pronouns", tableData: pronounSearchFields, textTemplate: "")
        pronounsDropdownView.tag = 4 // Set tag to keep track of field selection status.
        pronounsDropdownView.setSelectValue(value: pronouns)
        editScrollView.addSubview(pronounsDropdownView)

        setupConstraints()
    }

    func setupConstraints() {
        let textFieldHeight: CGFloat = 49
        let textFieldSidePadding: CGFloat = 40
        let textFieldTopPadding: CGFloat = 20
        let textFieldTotalPadding: CGFloat = textFieldHeight + textFieldTopPadding

        backButton.snp.makeConstraints { make in
            make.width.equalTo(12)
            make.height.equalTo(22)
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

    private func updateFieldConstraints(fieldView: UIView, height: CGFloat) {
        fieldView.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
    }

}

extension EditDemographicsViewController: OnboardingDropdownViewDelegate {

    func updateSelectedFields(tag: Int, isSelected: Bool) {
        fieldsEntered[tag] = isSelected
    }

    /// Resizes search view based on input to search field
    func updateDropdownViewHeight(dropdownView: UIView, height: CGFloat) {
        editScrollView.bringSubviewToFront(dropdownView)
        updateFieldConstraints(fieldView: dropdownView, height: textFieldHeight + height)
    }

    func bringDropdownViewToFront(dropdownView: UIView, height: CGFloat, isSelect: Bool) {
        if let activeDropdownView = activeDropdownView as? OnboardingSearchDropdownView {
            editScrollView.sendSubviewToBack(activeDropdownView)
            updateFieldConstraints(fieldView: activeDropdownView, height: textFieldHeight)
            activeDropdownView.hideTableView()
            activeDropdownView.endEditing(true)
        } else if let activeDropdownView = activeDropdownView as? OnboardingSelectDropdownView {
            if activeDropdownView != dropdownView {
                editScrollView.sendSubviewToBack(activeDropdownView)
                updateFieldConstraints(fieldView: activeDropdownView, height: textFieldHeight)
                activeDropdownView.hideTableView()
            }
        } else if let activeDropdownView = activeDropdownView as? UITextField {
            activeDropdownView.endEditing(true)
        }
        editScrollView.bringSubviewToFront(dropdownView)
        activeDropdownView = dropdownView
        let newFieldHeight = textFieldHeight + height
        updateFieldConstraints(fieldView: dropdownView, height: newFieldHeight)
        if dropdownView.frame.origin.y + newFieldHeight > view.bounds.height - 50 {
            scrollContentOffset = editScrollView.contentOffset.y
            isPageScrolled = true
            editScrollView.setContentOffset(CGPoint(x: 0, y: height), animated: true)
        }
    }

    func sendDropdownViewToBack(dropdownView: UIView, isSearch: Bool) {
        if isSearch { view.endEditing(true) }
        editScrollView.sendSubviewToBack(dropdownView)
        updateFieldConstraints(fieldView: dropdownView, height: textFieldHeight)
        if isPageScrolled {
            editScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            isPageScrolled = false
        }
    }
}

extension EditDemographicsViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        profileImageView.image = image
        dismiss(animated: true, completion: nil)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeDropdownView = textField
    }
}
