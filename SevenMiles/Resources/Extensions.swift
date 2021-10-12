//
//  Extension.swift
//  Extension
//
//  Created by SEAN BLAKE on 10/9/21.
//

import Foundation
import UIKit

extension UIView {
    var width: CGFloat {
        return frame.size.width
    }
    var height: CGFloat {
        return frame.size.height
    }
    var left: CGFloat {
        return frame.origin.x
    }
    var right: CGFloat {
        return left + width
    }
    var top: CGFloat {
        return frame.origin.y
    }
    var bottom: CGFloat {
        return top + height
    }
}

// the Date formater
extension DateFormatter {
    static let defaultFormater: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}

// Used to convert the Date() to a String
extension String {
    static func date(with date: Date) -> String {
        return DateFormatter.defaultFormater.string(from: date)
    }
}
