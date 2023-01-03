//
//  UIViewController+Preview.swift
//  Today
//
//  Created by Bijan Nazem on 2023-01-01.
//

import UIKit

#if DEBUG

import SwiftUI

extension UIViewController {
    
    private struct Preview: UIViewControllerRepresentable {
        
        let viewController: UIViewController
        
        
        public func makeUIViewController(context: Context) -> UIViewController {
            return viewController
        }
        
        public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
        
    }
    
    func toPreview() -> some View { Preview(viewController: self) }
    
}

#endif
