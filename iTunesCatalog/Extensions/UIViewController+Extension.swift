//
//  UIViewController+Extension.swift
//  iTunesCatalog
//
//  Created by Dmitry on 05.10.2020.
//

import Foundation
import UIKit

var pView: UIView?

extension UIViewController {
    func showPlaceholder(with text: String) {
        DispatchQueue.main.async {
            if let pView = pView {
                pView.removeFromSuperview()
            }
            let placeholderView = UIView(frame: self.view.bounds)
            placeholderView.backgroundColor = .white
            let label = UILabel(frame: placeholderView.bounds)
            label.center = placeholderView.center
            label.text = text
            label.textColor = .lightGray
            label.numberOfLines = 0
            label.textAlignment = .center
            placeholderView.addSubview(label)
            self.view.addSubview(placeholderView)
            
            pView = placeholderView
        }
    }
    
    func showSpinner() {
        DispatchQueue.main.async {
            if let pView = pView {
                pView.removeFromSuperview()
            }
            let placeholderView = UIView(frame: self.view.bounds)
            placeholderView.backgroundColor = .white
            let activityIndicator = UIActivityIndicatorView(style: .medium)
            activityIndicator.startAnimating()
            activityIndicator.center = placeholderView.center
            placeholderView.addSubview(activityIndicator)
            self.view.addSubview(placeholderView)
            
            pView = placeholderView
        }
    }
    
    func removePlaceholder() {
        DispatchQueue.main.async {
            pView?.removeFromSuperview()
            pView = nil
        }
    }
}
