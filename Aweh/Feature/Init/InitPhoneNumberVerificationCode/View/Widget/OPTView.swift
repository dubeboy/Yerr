//
//  OPTView.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/10/31.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit


class OTPTextField: UITextField {
    var previousTextField: UITextField?
    var nextTextField: UITextField?
    
    override func deleteBackward() {
        placeholder = "-"
        text = ""
        previousTextField?.becomeFirstResponder()
    }
}


class OTPView: UIStackView {
    var textFieldArray = [OTPTextField]()
    var numberOfOTPDigits = 6
    
    init() {
        super.init(frame: .zero)
        configureStackView()
        setTextFields()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension OTPView {
    func configureStackView() {
        backgroundColor = .clear
        isUserInteractionEnabled = true
        autoresizingOff()
        contentMode = .center
        distribution = .fillEqually
        axis = .horizontal
        spacing = 5
    }
    
    func setTextFields() {
        for i in 0..<numberOfOTPDigits {
            let field = OTPTextField()
            
            textFieldArray.append(field)
            addArrangedSubview(field)
            field.delegate = self
            field.heightAnchor --> 30
            field.widthAnchor --> 30
            field.textAlignment = .center
            field.placeholder = "-"
            field.textContentType = .oneTimeCode
//            field.backgroundColor = .red
            // no need to set the background color
            i != 0 ? (field.previousTextField = textFieldArray[i-1]) : ()
            i != 0 ? (textFieldArray[i-1].nextTextField = textFieldArray[i]) : ()
        }
    }
}

extension OTPView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let field = textField as? OTPTextField else {
            return true
        }
        
        if !string.isEmpty {
            field.text = string
            field.resignFirstResponder()
            field.nextTextField?.becomeFirstResponder()
            return true
        }
        return true
    }
}
