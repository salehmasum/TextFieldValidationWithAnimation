//
//  ViewController.swift
//  TextFieldValidationWithAnimation
//
//  Created by Saleh Masum on 11/9/2022.
//

import UIKit

class ViewController: UIViewController {

    let stackView = UIStackView()
    let formFieldView = FormFieldView()
    let undoButton = makeButton(withText: "Undo")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }

}

extension ViewController {
    
    func style() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        
        formFieldView.translatesAutoresizingMaskIntoConstraints = false
        undoButton.translatesAutoresizingMaskIntoConstraints = false
        
        undoButton.addTarget(self, action: #selector(updoTapped), for: .primaryActionTriggered)
    }
    
    func layout() {
        
        stackView.addArrangedSubview(formFieldView)
        stackView.addArrangedSubview(undoButton)
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            formFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            formFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            undoButton.heightAnchor.constraint(equalTo: formFieldView.heightAnchor),
            undoButton.widthAnchor.constraint(equalTo: formFieldView.widthAnchor)
        ])
    }
    
}

extension ViewController {
    @objc func updoTapped() {
        print("undo tapped")
        formFieldView.undo()
    }
}

// MARK: - Factories
func makeButton(withText text: String) -> UIButton {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle(text, for: .normal)
    button.titleLabel?.adjustsFontSizeToFitWidth = true
    button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    button.backgroundColor = .systemBlue
    button.layer.cornerRadius = 60 / 4
    return button
}

