//
//  SwitchCellViewModel.swift
//  SevenMiles
//
//  Created by SEAN BLAKE on 12/8/21.
//

import Foundation

struct SwitchCellViewModel {
    let title: String
    var isOn: Bool
    
    mutating func setOn(_ on: Bool) {
        self.isOn = on
    }
}
