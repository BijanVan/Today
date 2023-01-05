//
//  ReminderViewController+Row.swift
//  Today
//
//  Created by Bijan Nazem on 2023-01-02.
//

import UIKit

extension ReminderViewController {
    enum Row: Hashable {
        case header(String)
        case viewDate
        case viewNotes
        case viewTime
        case viewTitle
        case editDate(Date)
        case editText(String?)
        
        var imageName: String? {
            switch self {
            case .viewDate:
                return "calendar.circle"
            case .viewNotes:
                return "square.and.pencil"
            case .viewTime:
                return "clock"
            default:
                return nil
            }
        }
        
        var image: UIImage? {
            guard let imageName else { return nil }
            let config = UIImage.SymbolConfiguration(textStyle: .headline)
            return UIImage(systemName: imageName, withConfiguration: config)
        }
        
        var textStyle: UIFont.TextStyle {
            switch self {
            case .viewTitle:
                return .headline
            default:
                return .subheadline
            }
        }
    }
}
