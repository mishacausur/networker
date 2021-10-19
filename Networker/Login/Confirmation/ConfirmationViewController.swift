//
//  ConfirmationViewController.swift
//  Networker
//
//  Created by Misha Causur on 17.10.2021.
//

import UIKit

class ConfirmationViewController: UIViewController {
    
    var coordinator: AppCoordinator?
    
    var viewModel: ConfirmationViewOutput
    
    var phoneNumber: String
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = .plain()
        button.configuration?.buttonSize = .large
        button.configuration?.image = UIImage(systemName: "arrow.backward")
        button.configuration?.baseForegroundColor = UIColor(named: "DarkViolet")
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let confirmationLabel: UILabel = {
        let label = UILabel()
        label.text = "Подтверждение регистрации"
        label.font = UIFont(name: "VenrynSans-SemiBold", size: 22)
        label.textColor = UIColor(named: "DarkViolet")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Мы отправили SMS с кодом на номер"
        label.font = UIFont(name: "VenrynSans-Light", size: 14)
        label.textColor = UIColor(named: "DarkViolet")
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "VenrynSans-SemiBold", size: 18)
        label.textColor = UIColor(named: "DarkViolet")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let codeLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите код из SMS"
        label.font = UIFont(name: "VenrynSans-Light", size: 14)
        label.textColor = UIColor(named: "DarkViolet")
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let codeField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = UIFont(name: "VenrynSans-Light", size: 24)
        field.keyboardType = .numberPad
        field.textAlignment = .center
        field.layer.cornerRadius = 10
        field.addTarget(self, action: #selector(checkCode), for: .allEvents)
        field.layer.masksToBounds = true
        field.layer.borderColor = UIColor(named: "DarkViolet")?.cgColor
        field.layer.borderWidth = 1
        field.attributedPlaceholder = NSAttributedString(string: "_ _ _ _ _ _", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        field.textColor = UIColor(named: "DarkViolet")
        return field
    }()
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(confirmation), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = .bordered()
        var attributedString = AttributedString.init(stringLiteral: "Подтвердить")
        attributedString.font = UIFont(name: "VenrynSans-Regular", size: 24)
        button.configuration?.attributedTitle = attributedString
        button.configuration?.buttonSize = .medium
        button.configuration?.baseBackgroundColor = UIColor(named: "DarkViolet")
        button.configuration?.baseForegroundColor = .white
        return button
    }()
    
    private let heartLogo: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "heart")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let backgroundImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "bg3")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BackgroundViolet")
        signInButton.alpha = 0
        codeField.delegate = self
        configureViews()
    }
    
    init(phoneNumber: String, viewModel: ConfirmationViewOutput) {
        self.phoneNumber = phoneNumber
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func checkCode() {
        guard let text = codeField.text else { return }
        codeField.text = text.applyPatternOnNumbers(pattern: "######", replacementCharacter: "#")
        
        if text.count == 6 {
            signInButton.isEnabled = true
            signInButton.alpha = 1
        } else {
            signInButton.isEnabled = false
            signInButton.alpha = 0
        }
    }
    
    @objc private func confirmation() {
        guard let text = codeField.text else { return }
        viewModel.verify(code: text) { value in
            guard value else {
                self.invalidCode()
                return
            }
            self.coordinator?.startWithSuccess()
        }
    }
    
    private func invalidCode() {
        let alarmController = UIAlertController(title: "Неверный код", message: "Проверьте введеный код из СМС", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Отмена", style: .cancel)
        alarmController.addAction(cancel)
        
        present(alarmController, animated: true)
    }
 
    @objc private func backButtonTapped() {
        coordinator?.dismiss()
    }
    
    private func configureViews() {
        view.addSubviews(backgroundImage, backButton, confirmationLabel, infoLabel, phoneNumberLabel, codeLabel, codeField, signInButton, heartLogo)
        phoneNumberLabel.text = "+7 " + phoneNumber
        
        let constraints = [
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
           
            confirmationLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 164),
            confirmationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        
            infoLabel.topAnchor.constraint(equalTo: confirmationLabel.bottomAnchor, constant: 4),
            infoLabel.centerXAnchor.constraint(equalTo: confirmationLabel.centerXAnchor),
        
            phoneNumberLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 8),
            phoneNumberLabel.centerXAnchor.constraint(equalTo: infoLabel.centerXAnchor),
        
            codeField.topAnchor.constraint(equalTo: phoneNumberLabel.bottomAnchor, constant: 46),
            codeField.centerXAnchor.constraint(equalTo: phoneNumberLabel.centerXAnchor),
            codeField.widthAnchor.constraint(equalToConstant: 148),
        
            codeLabel.bottomAnchor.constraint(equalTo: codeField.topAnchor, constant: -6),
            codeLabel.centerXAnchor.constraint(equalTo: codeField.centerXAnchor),
        
            signInButton.topAnchor.constraint(equalTo: codeField.bottomAnchor, constant: 44),
            signInButton.centerXAnchor.constraint(equalTo: codeField.centerXAnchor),
        
            heartLogo.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 44),
            heartLogo.widthAnchor.constraint(equalToConstant: 74),
            heartLogo.heightAnchor.constraint(equalTo: heartLogo.widthAnchor),
            heartLogo.centerXAnchor.constraint(equalTo: signInButton.centerXAnchor)]
        
        NSLayoutConstraint.activate(constraints)
    }
    
 

}

extension ConfirmationViewController: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return range.location < 6
    }
    
}

extension ConfirmationViewController: ConfirmationViewInput {
    
}
