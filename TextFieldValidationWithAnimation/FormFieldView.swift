//
//  FormFieldView.swift
//  TextFieldValidationWithAnimation
//
//  Created by Saleh Masum on 11/9/2022.
//

import UIKit

class FormFieldView: UIView {

    let label = UILabel()
    let invalidLabel = UILabel()
    let textField = UITextField()
    let cancelButton = makeSymbolButton(systemName: "clear.fill", target: self, selector: #selector(cancelTapped(_:)))
     
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 60)
    }
}

extension FormFieldView {
    
    func setup() {
        textField.delegate = self
    }
    
    func style() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemGray5
        layer.cornerRadius = 60 / 4
        
        //label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray
        label.text = "Email"
        
        //invalid label
        invalidLabel.translatesAutoresizingMaskIntoConstraints = false
        invalidLabel.textColor = .systemRed
        invalidLabel.text = "Email is invalid"
        invalidLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        invalidLabel.isHidden = true
        
        //textField
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tintColor = .systemGreen
        textField.isHidden = true
        
        //Symbol button
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.imageView?.tintColor = .systemGray3
        cancelButton.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        addGestureRecognizer(tap)
    }
    
    func layout() {
        addSubview(label)
        addSubview(invalidLabel)
        addSubview(textField)
        addSubview(cancelButton)
        NSLayoutConstraint.activate([
            //label
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            //invalid label
            invalidLabel.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            invalidLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            //TextField
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            //Symbol button
            cancelButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -16)
            
        ])
    }
    
    @objc func tapped(_ recognizer: UITapGestureRecognizer) {
        if(recognizer.state == UITapGestureRecognizer.State.ended) {
            print("Tapped")
            enterEmailAnimation()
        }
    }
    
}


// MARK: - Animations
extension FormFieldView {
    func enterEmailAnimation() {
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.1,
            delay: 0,
            options: []) {
                
                //style
                self.backgroundColor = .white
                self.textField.tintColor = .systemGreen
                self.label.textColor = .systemGreen
                self.layer.borderWidth = 1
                self.layer.borderColor = self.label.textColor.cgColor
                
                //move
                let transpose = CGAffineTransform(translationX: -8, y: -24)
                let scale     = CGAffineTransform(scaleX: 0.7, y: 0.7)
                self.label.transform = transpose.concatenating(scale)
                
            } completion: { position in
                self.textField.isHidden = false
                self.textField.becomeFirstResponder()
                self.cancelButton.isHidden = false
            }

    }
    
}

//MARK: -  Actions
extension FormFieldView {
    
    func undo() {
        let size = UIViewPropertyAnimator(duration: 0.1, curve: .linear) {
            //Style
            self.backgroundColor = .systemGray5
            self.label.textColor = .systemGray
            self.layer.borderWidth = 0
            self.layer.borderColor = UIColor.clear.cgColor
            
            //Visibility
            self.label.isHidden = false
            self.invalidLabel.isHidden = true
            self.textField.isHidden = true
            self.textField.text = ""
            self.cancelButton.isHidden = true
            
            //move
            self.label.transform = .identity
        }
        size.startAnimation()
    }
    
    @objc func cancelTapped(_ sender: UIButton) {
        textField.resignFirstResponder()
        undo()
    }
}

// MARK: - Textfield delegate methods
extension FormFieldView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        }
        return false
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let emailText = textField.text else { return }
            
        if isValidEmail(emailText) {
            undo()
        } else {
            showInvalidEmailMessage()
            textField.becomeFirstResponder()
        }
        
        textField.text = ""
    }
    
    func showInvalidEmailMessage() {
        label.isHidden = true
        invalidLabel.isHidden = false
        layer.borderColor = UIColor.systemRed.cgColor
        textField.tintColor = .systemRed
    }
}

// MARK: - Factories
func makeSymbolButton(systemName: String, target: Any, selector: Selector) -> UIButton {
    let configuration = UIImage.SymbolConfiguration(scale: UIImage.SymbolScale.large)
    let image = UIImage(systemName: systemName, withConfiguration: configuration)
    
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(target, action: selector, for: .primaryActionTriggered)
    button.setImage(image, for: .normal)
    button.imageView?.contentMode = .scaleAspectFit
    return button
}

// MARK: Utils
func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
}
