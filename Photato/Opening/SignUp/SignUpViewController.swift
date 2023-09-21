//
//  SignUpViewController.swift
//  Photato
//
//  Created by Alexander Sivko on 18.09.23.
//

import UIKit
import Photos
import PhotosUI
import OSLog

protocol SignUpDisplayLogic: AnyObject {
    func displayNameTextFieldValidation(viewModel: SignUp.ValidateNameTextField.ViewModel)
    func displayEmailTextFieldValidation(viewModel: SignUp.ValidateEmailTextField.ViewModel)
    func displayPasswordTextFieldValidation(viewModel: SignUp.ValidatePasswordTextField.ViewModel)
}

final class SignUpViewController: UIViewController, SignUpDisplayLogic {
    // MARK: - Properties
    private var interactor: SignUpBusinessLogic?
    private var router: (NSObjectProtocol & SignUpRoutingLogic & SignUpDataPassing)?
    private let logger = Logger()
    
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
    
    private lazy var addProfilePictureButton: UIButton = {
        let addProfilePictureButton = UIButton()
        addProfilePictureButton.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        addProfilePictureButton.tintColor = .white
        addProfilePictureButton.imageView?.contentMode = .scaleAspectFit
        addProfilePictureButton.contentHorizontalAlignment = .fill
        addProfilePictureButton.contentVerticalAlignment = .fill
        addProfilePictureButton.backgroundColor = .tortilla
        addProfilePictureButton.addTarget(self, action: #selector(addProfilePicture), for: .touchUpInside)
        return addProfilePictureButton
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
        nameTextField.tag = 0
        return nameTextField
    }()
    
    private let nameTextFieldErrorLabel: UILabel = {
        let errorLabel = UILabel()
        errorLabel.textColor = .red
        errorLabel.textAlignment = .left
        errorLabel.font = .systemFont(ofSize: 14, weight: .light)
        return errorLabel
    }()
    
    private let emailTextField: UITextField = {
        let emailTextField = UITextField()
        emailTextField.placeholder = "Email"
        emailTextField.clearButtonMode = .whileEditing
        emailTextField.autocorrectionType = .no
        emailTextField.autocapitalizationType = .none
        emailTextField.setIcon(UIImage(systemName: "envelope"))
        emailTextField.tintColor = .darkOliveGreen
        emailTextField.tag = 1
        return emailTextField
    }()
    
    private let emailTextFieldErrorLabel: UILabel = {
        let errorLabel = UILabel()
        errorLabel.textColor = .red
        errorLabel.textAlignment = .left
        errorLabel.font = .systemFont(ofSize: 14, weight: .light)
        return errorLabel
    }()
    
    private let passwordTextField: UITextField = {
        let passwordTextField = UITextField()
        passwordTextField.placeholder = "Password"
        passwordTextField.clearButtonMode = .whileEditing
        passwordTextField.autocorrectionType = .no
        passwordTextField.autocapitalizationType = .none
        passwordTextField.setIcon(UIImage(systemName: "lock"))
        passwordTextField.tintColor = .darkOliveGreen
        passwordTextField.tag = 2
        return passwordTextField
    }()
    
    private let passwordTextFieldErrorLabel: UILabel = {
        let errorLabel = UILabel()
        errorLabel.textColor = .red
        errorLabel.textAlignment = .left
        errorLabel.font = .systemFont(ofSize: 14, weight: .light)
        return errorLabel
    }()
    
    private lazy var signUpButton: UIButton = {
        let signUpButton = UIButton()
        signUpButton.setTitle("Sign up", for: .normal)
        signUpButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .regular)
        signUpButton.backgroundColor = .darkOliveGreen
        signUpButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        return signUpButton
    }()
    
    private lazy var signUpClarificationPresentButton: UIButton = {
        let signUpClarificationButton = UIButton()
        signUpClarificationButton.addTarget(self, action: #selector(presentRegistrationClarification), for: .touchUpInside)
        let buttonAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.blue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let attributeString = NSMutableAttributedString(string: "Why do I need an account?", attributes: buttonAttributes)
        signUpClarificationButton.setAttributedTitle(attributeString, for: .normal)
        return signUpClarificationButton
    }()
    
    private let signUpClarificationContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .darkOliveGreen
        return containerView
    }()
    
    private let signUpClarificationTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .white
        textView.textAlignment = .center
        textView.font = .systemFont(ofSize: 17, weight: .light)
        textView.text = "A registered user can add locations to Favorites. Rating and commenting functions will be added in the future"
        textView.isSelectable = false
        textView.isEditable = false
        textView.backgroundColor = .darkOliveGreen
        return textView
    }()
    
    private lazy var signUpClarificationDismissButton: UIButton = {
        let dismissButton = UIButton()
        dismissButton.setImage(UIImage(systemName: "x.circle.fill"), for: .normal)
        dismissButton.tintColor = .white
        dismissButton.imageView?.contentMode = .scaleAspectFit
        dismissButton.contentHorizontalAlignment = .fill
        dismissButton.contentVerticalAlignment = .fill
        dismissButton.backgroundColor = .clear
        dismissButton.addTarget(self, action: #selector(dismissRegistrationClarification), for: .touchUpInside)
        return dismissButton
    }()
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tuneUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tuneBottomLinesOfTextFields()
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
    
    // MARK: ValidateNameTextField Use case
    private func validateNameTextField(_ text: String?) {
        let request = SignUp.ValidateNameTextField.Request(nameTextFieldText: text)
        interactor?.validateNameTextField(request: request)
    }
    
    func displayNameTextFieldValidation(viewModel: SignUp.ValidateNameTextField.ViewModel) {
        let isNameValid = viewModel.isNameTextFieldValid
        if isNameValid {
            nameTextFieldErrorLabel.text = nil
        } else {
            nameTextFieldErrorLabel.text = "Please fill name field"
        }
    }
    
    // MARK: ValidateEmailTextField Use case
    func validateEmailTextField(_ text: String?) {
        let request = SignUp.ValidateEmailTextField.Request(emailTextFieldText: text)
        interactor?.validateEmailTextField(request: request)
    }
    
    func displayEmailTextFieldValidation(viewModel: SignUp.ValidateEmailTextField.ViewModel) {
        let isEmailValid = viewModel.isEmailTextFieldValid
        if isEmailValid {
            emailTextFieldErrorLabel.text = nil
        } else {
            emailTextFieldErrorLabel.text = "Invalid Email. Example: photo123@gmail.com"
        }
    }
    
    // MARK: ValidatePasswordTextField Use case
    func validatePasswordTextField(_ text: String?) {
        let request = SignUp.ValidatePasswordTextField.Request(passwordTextFieldText: text)
        interactor?.validatePasswordTextField(request: request)
    }
    
    func displayPasswordTextFieldValidation(viewModel: SignUp.ValidatePasswordTextField.ViewModel) {
        let isPasswordValid = viewModel.isPasswordTextFieldValid
        if isPasswordValid {
            passwordTextFieldErrorLabel.text = nil
        } else {
            passwordTextFieldErrorLabel.text = "Password must contain at least 5 characters"
        }
    }
    
    // MARK: SignUp Use case
    @objc private func signUp() {
        
    }
    
    // MARK: Other methods
    @objc private func addProfilePicture() {
        present(photoPicker, animated: true)
    }
    
    @objc private func presentRegistrationClarification() {
        UIView.animate(withDuration: 0.7) {
            self.signUpClarificationContainerView.center.y -= self.signUpClarificationContainerView.frame.height
        }
    }
    
    @objc private func dismissRegistrationClarification() {
        UIView.animate(withDuration: 0.7) {
            self.signUpClarificationContainerView.center.y += self.signUpClarificationContainerView.frame.height
        }
    }
    
    private func clearErrorMessage(_ textFieldTag: Int) {
        switch textFieldTag {
        case 0:
            nameTextFieldErrorLabel.text = nil
        case 1:
            emailTextFieldErrorLabel.text = nil
        case 2:
            passwordTextFieldErrorLabel.text = nil
        default:
            break
        }
    }
    
    private func tuneUI() {
        view.addSubview(profilPictureImageViewContainerView)
        profilPictureImageViewContainerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
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
        
        profilPictureImageViewContainerView.addSubview(addProfilePictureButton)
        addProfilePictureButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview().offset(40)
            make.height.width.equalTo(30)
        }
        addProfilePictureButton.layer.cornerRadius = 15
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(profilPictureImageViewContainerView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().inset(30)
        }
        stackView.spacing = 7
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(nameTextFieldErrorLabel)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(emailTextFieldErrorLabel)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(passwordTextFieldErrorLabel)
        
        nameTextField.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(40)
        }
        nameTextField.delegate = self
        
        nameTextFieldErrorLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(15)
        }

        emailTextField.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(40)
        }
        emailTextField.delegate = self
        
        emailTextFieldErrorLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(15)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(40)
        }
        passwordTextField.delegate = self
        
        passwordTextFieldErrorLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(15)
        }
        
        view.addSubview(signUpButton)
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalTo(stackView.snp.width)
            make.height.equalTo(40)
        }
        signUpButton.layer.cornerRadius = 5
        
        view.addSubview(signUpClarificationPresentButton)
        signUpClarificationPresentButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(signUpButton.snp.bottom).offset(70)
            make.width.equalTo(200)
            make.height.equalTo(30)
        }
        
        view.addSubview(signUpClarificationContainerView)
        signUpClarificationContainerView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(200)
        }
        
        signUpClarificationContainerView.addSubview(signUpClarificationTextView)
        signUpClarificationTextView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(100)
            make.width.equalTo(300)
        }
        
        signUpClarificationContainerView.addSubview(signUpClarificationDismissButton)
        signUpClarificationDismissButton.snp.makeConstraints { make in
            make.height.width.equalTo(30)
            make.top.equalToSuperview().offset(15)
            make.right.equalToSuperview().inset(15)
        }
        
        photoPicker.delegate = self
    }
    
    private func tuneBottomLinesOfTextFields() {
        nameTextField.layoutIfNeeded()
        nameTextField.addBottomLineToTextField()
        emailTextField.layoutIfNeeded()
        emailTextField.addBottomLineToTextField()
        passwordTextField.layoutIfNeeded()
        passwordTextField.addBottomLineToTextField()
    }
    
    private func configure() {
        let viewController = self
        let interactor = SignUpInteractor()
        let presenter = SignUpPresenter()
        let router = SignUpRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}

    // MARK: - PHPickerViewControllerDelegate
extension SignUpViewController: PHPickerViewControllerDelegate {
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
extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            validateNameTextField(textField.text)
        case 1:
            validateEmailTextField(textField.text)
        case 2:
            validatePasswordTextField(textField.text)
        default:
            break
        }
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        clearErrorMessage(textField.tag)
        return true
    }
}
