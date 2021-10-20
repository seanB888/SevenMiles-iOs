//
//  AuthButton.swift
//  AuthButton
//
//  Created by SEAN BLAKE on 10/19/21.
//

import UIKit

class AuthButton: UIButton {
    
    enum ButtonType {
        case SignIn
        case SignUp
        case Plain
    }
    
    let type = ButtonType
    
    init(type: ButtonType) {
        self.type = type
        super.init(frame: .zero)
    }
}
