//
//  ViewControllerUtilities.swift
//  news
//
//  Created by Benjamin Fantini on 9/2/17.
//  Copyright © 2017 Benjamin Fantini. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showErrorAlert(message: String) {
        
        let alertController = UIAlertController(title: "Oh oh",
                                                message: message,
                                                preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Ok", style: .default) { _ in
            self.presentedViewController?.dismiss(animated: true,
                                                  completion: nil)
        }
        alertController.addAction(defaultAction)
        
        self.present(alertController,
                     animated: true,
                     completion: nil)
        
    }
    
}
