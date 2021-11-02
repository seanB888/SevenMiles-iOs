//
//  AuthField.swift
//  AuthField
//
//  Created by SEAN BLAKE on 10/19/21.
//

import UIKit

class AuthField: UITextField {
    
    enum FieldType {
        case email
        case password
        // For signing up
        case username
        case firstName
        case lastName
        case phoneNumber
        
        var title: String {
            switch self {
            case .email: return "Email Address"
            case .password: return "Password"
            case .username: return "Username"
            case .firstName: return "First Name"
            case .lastName: return "Last Name"
            case .phoneNumber: return "Phone Number"
            }
        }
    }
    
    private let type: FieldType
    
    init(type: FieldType) {
        self.type = type
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureUI() {
        autocapitalizationType = .none
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 8
        layer.masksToBounds = true
        placeholder = type.title
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: height))
        leftViewMode = .always
        returnKeyType = .done
        autocorrectionType = .no
        
        if type == .password {
            textContentType = .oneTimeCode
            isSecureTextEntry = true
        }
        else if type == .email {
            textContentType = .emailAddress
            keyboardType = .emailAddress
        }
    }
}
