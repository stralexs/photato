//
//  LoginViewController.swift
//  Photato
//
//  Created by Alexander Sivko on 18.09.23.
//

import UIKit

protocol LoginDisplayLogic: AnyObject {
    func displayEmailTextFieldValidation(viewModel: Login.ValidateEmailTextField.ViewModel)
    func displayPasswordTextFieldValidation(viewModel: Login.ValidatePasswordTextField.ViewModel)
    func displaySignInResult(viewModel: Login.SignIn.ViewModel)
    func displayLocationsDownloadResult(viewModel: Login.DownloadLocations.ViewModel)
}

final class LoginViewController: UIViewController, LoginDisplayLogic {
    // MARK: - Properties    
    private var interactor: LoginBusinessLogic?
    private var router: (NSObjectProtocol & LoginRoutingLogic)?
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private let appIconImageView: UIImageView = {
        let appIconImageView = UIImageView()
        appIconImageView.contentMode = .scaleAspectFit
        appIconImageView.image = UIImage(named: "PhotatoLogo")
        return appIconImageView
    }()
    
    private let emailTextField: UITextField = {
        let emailTextField = UITextField()
        emailTextField.placeholder = "Email"
        emailTextField.clearButtonMode = .whileEditing
        emailTextField.autocorrectionType = .no
        emailTextField.autocapitalizationType = .none
        emailTextField.setIcon(UIImage(systemName: "envelope"))
        emailTextField.tintColor = .darkOliveGreen
        emailTextField.tag = 0
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
        passwordTextField.tag = 1
        return passwordTextField
    }()
    
    private let passwordTextFieldErrorLabel: UILabel = {
        let errorLabel = UILabel()
        errorLabel.textColor = .red
        errorLabel.textAlignment = .left
        errorLabel.font = .systemFont(ofSize: 14, weight: .light)
        return errorLabel
    }()
    
    private lazy var loginButton: UIButton = {
        let loginButton = UIButton()
        loginButton.setTitle("Login", for: .normal)
        loginButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .regular)
        loginButton.backgroundColor = .darkOliveGreen
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        return loginButton
    }()
    
    private let activityIndicator = UIActivityIndicatorView()
    
    // MARK: - View Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tuneConstraints()
        tuneUI()
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
    private func tuneConstraints() {
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().inset(30)
        }
        stackView.spacing = 10
        stackView.addArrangedSubview(appIconImageView)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(emailTextFieldErrorLabel)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(passwordTextFieldErrorLabel)
        stackView.addArrangedSubview(loginButton)
        stackView.addArrangedSubview(activityIndicator)
        
        appIconImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(180)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(40)
        }
        
        emailTextFieldErrorLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(15)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(40)
        }
        
        passwordTextFieldErrorLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(15)
        }
        
        loginButton.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(40)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
    private func tuneUI() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        loginButton.layer.cornerRadius = 5
        
        emailTextField.layoutIfNeeded()
        emailTextField.addBottomLineToTextField()
        passwordTextField.layoutIfNeeded()
        passwordTextField.addBottomLineToTextField()
    }
    
    private func configure() {
        let viewController = self
        let interactor = LoginInteractor(firebaseManager: FirebaseManager(), keychainManager: KeychainManager())
        let presenter = LoginPresenter()
        let router = LoginRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
    }
}

    // MARK: - Login Use case
extension LoginViewController {
    @objc private func login() {
        guard emailTextFieldErrorLabel.text == nil,
              passwordTextFieldErrorLabel.text == nil,
              let email = emailTextField.text,
              let password = passwordTextField.text else { return }
        
        activityIndicator.startAnimating()
        let request = Login.SignIn.Request(email: email, password: password)
        interactor?.signIn(request: request)
    }
    
    func displaySignInResult(viewModel: Login.SignIn.ViewModel) {
        if viewModel.signInErrorDescription == nil {
            downloadLocations()
        } else {
            guard let errorDescription = viewModel.signInErrorDescription else { return }
            let alert = UIAlertController(title: "\(errorDescription)", message: nil, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ok", style: .default)
            
            alert.addAction(cancelAction)
            present(alert, animated: true)
        }
    }
}

    // MARK: - ValidateEmailTextField Use case
extension LoginViewController {
    func validateEmailTextField(_ text: String?) {
        let request = Login.ValidateEmailTextField.Request(emailTextFieldText: text)
        interactor?.validateEmailTextField(request: request)
    }
    
    func displayEmailTextFieldValidation(viewModel: Login.ValidateEmailTextField.ViewModel) {
        emailTextFieldErrorLabel.text = viewModel.emailTextFieldValidationDescription
    }
}


    // MARK: - DownloadLocations Use case
extension LoginViewController {
    private func downloadLocations() {
        let request = Login.DownloadLocations.Request()
        interactor?.downloadLocations(request: request)
    }
    
    func displayLocationsDownloadResult(viewModel: Login.DownloadLocations.ViewModel) {
        if viewModel.downloadErrorDescription == nil {
            router?.routeToTabBarController()
        } else {
            guard let errorDescription = viewModel.downloadErrorDescription else { return }
            let alert = UIAlertController(title: "\(errorDescription)", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default)
            
            alert.addAction(okAction)
            present(alert, animated: true)
            
            activityIndicator.stopAnimating()
        }
    }
}

    // MARK: - ValidatePasswordTextField Use case
extension LoginViewController {
    func validatePasswordTextField(_ text: String?) {
        let request = Login.ValidatePasswordTextField.Request(passwordTextFieldText: text)
        interactor?.validatePasswordTextField(request: request)
    }
    
    func displayPasswordTextFieldValidation(viewModel: Login.ValidatePasswordTextField.ViewModel) {
        passwordTextFieldErrorLabel.text = viewModel.passwordTextFieldValidationDescription
    }
}

    // MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            validateEmailTextField(textField.text)
        case 1:
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
    
    private func clearErrorMessage(_ textFieldTag: Int) {
        switch textFieldTag {
        case 0:
            emailTextFieldErrorLabel.text = nil
        case 1:
            passwordTextFieldErrorLabel.text = nil
        default:
            break
        }
    }
}
