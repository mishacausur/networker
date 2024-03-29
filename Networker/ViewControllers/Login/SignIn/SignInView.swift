//
//  SignInView.swift
//  Networker
//
//  Created by Misha Causur on 31.10.2021.
//

import UIKit

class SignInView: UIView {
    
    var backButtonTappedCompletion: (()->())?
    
    var confirmNumberCompletion: ((String)->())?
    
    private let backButton = UIButton().configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.configuration = .plain()
        $0.configuration?.buttonSize = .large
        $0.configuration?.buttonSize = .large
        $0.configuration?.image = UIImage(systemName: "arrow.backward")
        $0.configuration?.baseForegroundColor = Color.setColor(.darkViolet)
        $0.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private let signInLabel = UILabel().configure {
        $0.text = "Зарегистрироваться"
        $0.font = Font.setFont(.semibold, 28)
        $0.textColor = Color.setColor(.darkViolet)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let phoneLabel = UILabel().configure {
        $0.text = "Введите номер"
        $0.font = Font.setFont(.regular, 18)
        $0.textColor = Color.setColor(.darkViolet)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let infoLabel = UILabel().configure {
        $0.text = "Ваш номер будет использоваться для входа в аккаунт"
        $0.font = Font.setFont(.light, 14)
        $0.textColor = Color.setColor(.darkViolet)
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let phoneFieldView = UIView().configure {
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = Color.setColor(.darkViolet).cgColor
        $0.layer.borderWidth = 1
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let firstNumberLabel = UILabel().configure {
        $0.text = "+ 7 "
        $0.font = Font.setFont(.light, 24)
        $0.textColor = Color.setColor(.darkViolet)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let phoneField = UITextField().configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = Font.setFont(.regular, 24)
        $0.keyboardType = .numberPad
        $0.textAlignment = .center
        $0.addTarget(self, action: #selector(checkNumber), for: .allEvents)
        $0.layer.masksToBounds = true
        $0.attributedPlaceholder = NSAttributedString(string: "Номер телефона", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "placeHolderColor") as Any])
        $0.textColor = UIColor(named: "DarkViolet")
    }
    
    private let nextButton = UIButton().configure {
        $0.addTarget(self, action: #selector(confirmation), for: .touchUpInside)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.configuration = .bordered()
        var attributedString = AttributedString.init(stringLiteral: "Далее")
        attributedString.font = Font.setFont(.regular, 24)
        $0.configuration?.attributedTitle = attributedString
        $0.configuration?.buttonSize = .medium
        $0.configuration?.baseBackgroundColor = Color.setColor(.darkViolet)
        $0.configuration?.baseForegroundColor = .white
    }
    
    private let agreedLabel = UILabel().configure {
        $0.text = "Нажимая кнопку “Далее”, Вы принимаете пользовательское Соглашение и политику конфиденциальности"
        $0.font = Font.setFont(.light, 14)
        $0.textColor = Color.setColor(.darkViolet)
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let errorLabel = UILabel().configure {
        $0.text = "Пожалуйста, введите корректный номер телефона"
        $0.font = Font.setFont(.light, 18)
        $0.textColor = Color.setColor(.error)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.alpha = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let backgroundImage = UIImageView().configure {
        $0.image = UIImage(named: "bg2")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
        nextButton.isEnabled = false
        phoneField.delegate = self
        nextButton.alpha = 0
        agreedLabel.alpha = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func backButtonTapped() {
        backButtonTappedCompletion?()
    }
    
    @objc private func checkNumber() {
        guard let text = phoneField.text else { return }
        phoneField.text = text.applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")
        if text.count == 14 {
           checkNineCharacter(text: text)
    } else {
        nextButton.isEnabled = false
        nextButton.alpha = 0
    }
}
    
    private func checkNineCharacter(text: String) {
        let nine = text[text.index(text.startIndex, offsetBy: 1)]
        if nine != "9" {
            phoneFieldView.layer.borderColor = Color.setColor(.error).cgColor
            errorLabel.alpha = 1
        } else {
            phoneFieldView.layer.borderColor = Color.setColor(.darkViolet).cgColor
            errorLabel.alpha = 0
            nextButton.isEnabled = true
            nextButton.alpha = 1
            agreedLabel.alpha = 1
        }
    }
    
    @objc private func confirmation() {
        guard let text = phoneField.text else { return }
        confirmNumberCompletion?(text)
    }
    
    private func configureViews() {
        self.addSubviews(backgroundImage, backButton, signInLabel, phoneLabel, infoLabel, phoneFieldView, nextButton, agreedLabel, errorLabel)
        phoneFieldView.addSubviews(firstNumberLabel, phoneField)
        
        let constraints = [
            
            backgroundImage.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            backButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 12),
            backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 6),
            
            errorLabel.bottomAnchor.constraint(equalTo: signInLabel.topAnchor, constant: -12),
            errorLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 22),
            errorLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -22),
            
            signInLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 164),
            signInLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        
            phoneLabel.topAnchor.constraint(equalTo: signInLabel.bottomAnchor, constant: 12),
            phoneLabel.centerXAnchor.constraint(equalTo: signInLabel.centerXAnchor),
        
            infoLabel.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 4),
            infoLabel.centerXAnchor.constraint(equalTo: phoneLabel.centerXAnchor),
        
            phoneFieldView.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 8),
            phoneFieldView.centerXAnchor.constraint(equalTo: infoLabel.centerXAnchor),
            phoneFieldView.widthAnchor.constraint(equalToConstant: 268),
            phoneFieldView.heightAnchor.constraint(equalTo: nextButton.heightAnchor),
            
            firstNumberLabel.topAnchor.constraint(equalTo: phoneFieldView.topAnchor),
            firstNumberLabel.bottomAnchor.constraint(equalTo: phoneFieldView.bottomAnchor),
            firstNumberLabel.leadingAnchor.constraint(equalTo: phoneFieldView.leadingAnchor, constant: 16),
            
            phoneField.topAnchor.constraint(equalTo: phoneFieldView.topAnchor),
            phoneField.bottomAnchor.constraint(equalTo: phoneFieldView.bottomAnchor),
            phoneField.widthAnchor.constraint(equalToConstant: 248),
            phoneField.trailingAnchor.constraint(equalTo: phoneFieldView.trailingAnchor),
        
            nextButton.topAnchor.constraint(equalTo: phoneField.bottomAnchor, constant: 12),
            nextButton.centerXAnchor.constraint(equalTo: phoneFieldView.centerXAnchor),
        
            agreedLabel.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 12),
            agreedLabel.centerXAnchor.constraint(equalTo: nextButton.centerXAnchor),
            agreedLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            agreedLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24)]
        
        NSLayoutConstraint.activate(constraints)
    }
}

extension SignInView: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return range.location < 14
    }
}
