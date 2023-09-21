//
//  UserValidationViewController.swift
//  Photato
//
//  Created by Alexander Sivko on 19.09.23.
//

import UIKit

final class UserValidationViewController: UIViewController {
    // MARK: - Properties
    var router: (NSObjectProtocol & UserValidationRoutingLogic)?
    
    private let gradient = CAGradientLayer()
    private var gradientSet = [[CGColor]]()
    private var currentGradient: Int = 0
    private let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
    private let gradientOne = UIColor.tortilla.cgColor
    private let gradientTwo = UIColor.lightTortilla.cgColor
    private let gradientThree = UIColor.white.cgColor
    
    private let containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .clear
        return containerView
    }()
    
    private let appIconImageView: UIImageView = {
        let appIconImageView = UIImageView()
        appIconImageView.contentMode = .scaleAspectFit
        appIconImageView.image = UIImage(named: "PhotatoLogo")
        return appIconImageView
    }()
    
    private let buttonsStackView: UIStackView = {
        let buttonsStackView = UIStackView()
        buttonsStackView.axis = .vertical
        return buttonsStackView
    }()
    
    private lazy var loginButton: UIButton = {
        let loginButton = UIButton()
        loginButton.setTitle("Login", for: .normal)
        loginButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .regular)
        loginButton.backgroundColor = .darkOliveGreen
        loginButton.addTarget(self, action: #selector(loginUser), for: .touchUpInside)
        return loginButton
    }()
    
    private lazy var signUpButton: UIButton = {
        let signUpButton = UIButton()
        signUpButton.setTitle("Sign up", for: .normal)
        signUpButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .regular)
        signUpButton.backgroundColor = .darkOliveGreen
        signUpButton.addTarget(self, action: #selector(signUpUser), for: .touchUpInside)
        return signUpButton
    }()
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        tuneUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupGradient()
    }
    
    // MARK: - Routing
    @objc private func loginUser() {
        router?.routeToLogin()
    }
    
    @objc private func signUpUser() {
        router?.routeToSignUp()
    }
    
    // MARK: - Methods
    private func setupGradient() {
        gradientChangeAnimation.delegate = self
        
        gradientSet.append([gradientOne, gradientTwo])
        gradientSet.append([gradientTwo, gradientThree])
        gradientSet.append([gradientThree, gradientOne])
                
        gradient.frame = self.view.bounds
        gradient.colors = gradientSet[currentGradient]
        gradient.startPoint = CGPoint(x:0, y:0)
        gradient.endPoint = CGPoint(x:1, y:1)
        gradient.drawsAsynchronously = true
        self.view.layer.insertSublayer(gradient, below: containerView.layer)
                
        animateGradient()
    }
    
    private func animateGradient() {
        if currentGradient < gradientSet.count - 1 {
            currentGradient += 1
        } else {
            currentGradient = 0
        }
        
        gradientChangeAnimation.duration = 2.0
        gradientChangeAnimation.toValue = gradientSet[currentGradient]
        gradientChangeAnimation.fillMode = .forwards
        gradientChangeAnimation.isRemovedOnCompletion = false
        gradient.add(gradientChangeAnimation, forKey: "colorChange")
    }
    
    private func tuneUI() {
        gradientChangeAnimation.delegate = self
        
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.addSubview(appIconImageView)
        appIconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-100)
            make.width.height.equalTo(300)
            make.centerX.equalToSuperview()
        }
        
        containerView.addSubview(buttonsStackView)
        buttonsStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(100)
        }
        buttonsStackView.addArrangedSubview(loginButton)
        buttonsStackView.addArrangedSubview(signUpButton)
        buttonsStackView.spacing = 20
        
        loginButton.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(50)
        }
        loginButton.layer.cornerRadius = 5
        
        signUpButton.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(50)
        }
        signUpButton.layer.cornerRadius = 5
    }
    
    private func configure() {
        let viewController = self
        let router = UserValidationRouter()
        viewController.router = router
        router.viewController = viewController
    }
}

    // MARK: - CAAnimationDelegate
extension UserValidationViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            gradient.colors = gradientSet[currentGradient]
            animateGradient()
        }
    }
}
