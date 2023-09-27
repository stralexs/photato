//
//  SettingsViewController.swift
//  Photato
//
//  Created by Alexander Sivko on 27.09.23.
//

import UIKit
import Photos
import PhotosUI
import OSLog

protocol SettingsDisplayLogic: AnyObject {
    func displayUserData(viewModel: Settings.GetUserData.ViewModel)
    func displayNameTextFieldValidation(viewModel: Settings.ValidateNameTextField.ViewModel)
    func displayApplyChangesResult(viewModel: Settings.ApplyChanges.ViewModel)
    func leaveAccount(viewModel: Settings.LeaveAccount.ViewModel)
}

class SettingsViewController: UIViewController, SettingsDisplayLogic {
    // MARK: - Properties
    private var interactor: SettingsBusinessLogic?
    private var router: (NSObjectProtocol & SettingsRoutingLogic)?
    private let logger = Logger()
    
    private lazy var rightBarButtomItem: UIBarButtonItem = {
        let rightBarButtomItem = UIBarButtonItem(title: "Sign out",
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(exitAccount))
        return rightBarButtomItem
    }()
    
    private let profilPictureImageViewContainerView: UIView = {
        let profilPictureImageViewContainerView = UIView()
        profilPictureImageViewContainerView.backgroundColor = .clear
        return profilPictureImageViewContainerView
    }()
    
    private let profilPictureImageView: UIImageView = {
        let profileImageView = UIImageView()
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.darkOliveGreen.cgColor
        profileImageView.clipsToBounds = true
        profileImageView.image = UIImage(named: "PhotatoAppIcon")
        profileImageView.contentMode = .scaleAspectFill
        return profileImageView
    }()
    
    private lazy var editProfilePictureButton: UIButton = {
        let editProfilePictureButton = UIButton()
        editProfilePictureButton.setImage(UIImage(systemName: "pencil.circle"), for: .normal)
        editProfilePictureButton.tintColor = .white
        editProfilePictureButton.imageView?.contentMode = .scaleAspectFit
        editProfilePictureButton.contentHorizontalAlignment = .fill
        editProfilePictureButton.contentVerticalAlignment = .fill
        editProfilePictureButton.backgroundColor = .tortilla
        editProfilePictureButton.addTarget(self, action: #selector(editProfilePicture), for: .touchUpInside)
        return editProfilePictureButton
    }()
    
    private let photoPicker: PHPickerViewController = {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 1
        config.filter = .images
        let photoPicker = PHPickerViewController(configuration: config)
        return photoPicker
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private let nameTextField: UITextField = {
        let nameTextField = UITextField()
        nameTextField.placeholder = "Name"
        nameTextField.clearButtonMode = .whileEditing
        nameTextField.setIcon(UIImage(systemName: "person"))
        nameTextField.autocorrectionType = .no
        nameTextField.tintColor = .darkOliveGreen
        return nameTextField
    }()
    
    private let nameTextFieldErrorLabel: UILabel = {
        let errorLabel = UILabel()
        errorLabel.textColor = .red
        errorLabel.textAlignment = .left
        errorLabel.font = .systemFont(ofSize: 14, weight: .light)
        return errorLabel
    }()
    
    private let activityIndicator = UIActivityIndicatorView()
    
    private lazy var applyButton: UIButton = {
        let signUpButton = UIButton()
        signUpButton.setTitle("Apply changes", for: .normal)
        signUpButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .regular)
        signUpButton.backgroundColor = .darkOliveGreen
        signUpButton.addTarget(self, action: #selector(applyChanges), for: .touchUpInside)
        return signUpButton
    }()
    
    // MARK: - View Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserData()
        tuneUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tuneBottomLinesOfTextField()
    }
    
    // MARK: - Initialization
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    // MARK: - Methods
    
    // MARK: GetUserData Use case
    private func getUserData() {
        let request = Settings.GetUserData.Request()
        interactor?.getUserData(request: request)
    }
    
    func displayUserData(viewModel: Settings.GetUserData.ViewModel) {
        nameTextField.text = viewModel.userData.name
        profilPictureImageView.image = UIImage(data: viewModel.userData.profilePicture)
    }
    
    // MARK: ValidateNameTextField Use case
    private func validateNameTextField(_ text: String?) {
        let request = Settings.ValidateNameTextField.Request(nameTextFieldText: text)
        interactor?.validateNameTextField(request: request)
    }
    
    func displayNameTextFieldValidation(viewModel: Settings.ValidateNameTextField.ViewModel) {
        nameTextFieldErrorLabel.text = viewModel.nameTextFieldValidationDescription
    }
    
    // MARK: ApplyChanges Use case
    @objc private func applyChanges() {
        guard nameTextFieldErrorLabel.text == nil,
              let name = nameTextField.text,
              let image = profilPictureImageView.image else { return }
        
        activityIndicator.startAnimating()
        
        let request = Settings.ApplyChanges.Request(name: name, profilePicture: image)
        interactor?.applyChanges(request: request)
    }
    
    func displayApplyChangesResult(viewModel: Settings.ApplyChanges.ViewModel) {
        if viewModel.applyChangesErrorDescription == nil {
            let alert = UIAlertController(title: "Changes successfully applied!", message: nil, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
                self?.router?.routeToProfile(navigationController: self?.navigationController)
            }
            
            alert.addAction(cancelAction)
            present(alert, animated: true)
        } else {
            activityIndicator.stopAnimating()
            
            guard let errorDescription = viewModel.applyChangesErrorDescription else { return }
            let alert = UIAlertController(title: "\(errorDescription)", message: nil, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ok", style: .default)
            
            alert.addAction(cancelAction)
            present(alert, animated: true)
        }
    }
    
    // MARK: LeaveAccount Use case
    private func leaveAccount() {
        let request = Settings.LeaveAccount.Request()
        interactor?.leaveAccount(request: request)
    }
    
    func leaveAccount(viewModel: Settings.LeaveAccount.ViewModel) {
        router?.routeToUserValidation()
    }
    
    // MARK: Other methods
    @objc private func exitAccount() {
        let alert = UIAlertController(title: "Are you sure want to leave your account?", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let okAction = UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
            self?.leaveAccount()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    @objc private func editProfilePicture() {
        present(photoPicker, animated: true)
    }
    
    private func tuneUI() {
        title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .tortilla
        navigationItem.rightBarButtonItem = rightBarButtomItem
        view.backgroundColor = .lightTortilla
        
        view.addSubview(profilPictureImageViewContainerView)
        profilPictureImageViewContainerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().inset(30)
            make.height.equalTo(120)
        }
        profilPictureImageViewContainerView.addSubview(profilPictureImageView)
        
        profilPictureImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.width.equalTo(120)
        }
        profilPictureImageView.layer.cornerRadius = 60
        
        profilPictureImageViewContainerView.addSubview(editProfilePictureButton)
        editProfilePictureButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview().offset(40)
            make.height.width.equalTo(30)
        }
        editProfilePictureButton.layer.cornerRadius = 15
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(profilPictureImageViewContainerView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().inset(30)
        }
        stackView.spacing = 10
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(nameTextFieldErrorLabel)
        
        nameTextField.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(40)
        }
        nameTextField.delegate = self
        
        nameTextFieldErrorLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(15)
        }
        
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalTo(stackView.snp.width)
            make.height.equalTo(20)
        }
        
        view.addSubview(applyButton)
        applyButton.snp.makeConstraints { make in
            make.top.equalTo(activityIndicator.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(stackView.snp.width)
            make.height.equalTo(40)
        }
        applyButton.layer.cornerRadius = 5
        
        photoPicker.delegate = self
    }
    
    private func tuneBottomLinesOfTextField() {
        nameTextField.layoutIfNeeded()
        nameTextField.addBottomLineToTextField()
    }
    
    private func configure() {
        let viewController = self
        let interactor = SettingsInteractor(firbaseManager: FirebaseManager())
        let presenter = SettingsPresenter()
        let router = SettingsRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
    }
}

// MARK: - PHPickerViewControllerDelegate
extension SettingsViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
    
        guard let result = results.first else { return }
        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] reading, error in
            guard let image = reading as? UIImage else { return }
            if let error {
                self?.logger.error("\(error.localizedDescription)")
                return
            }
            DispatchQueue.main.async {
                self?.profilPictureImageView.image = image
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        validateNameTextField(textField.text)
        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        nameTextFieldErrorLabel.text = nil
        return true
    }
}
