//
//  DefaultViewController.swift
//  news
//
//  Created by Benjamin Fantini on 9/2/17.
//  Copyright © 2017 Benjamin Fantini. All rights reserved.
//

import NVActivityIndicatorView
import UIKit

class DefaultViewController: UIViewController, NVActivityIndicatorViewable {

    // MARK: Initialization
    
    convenience init(defaultNib: Bool = false) {
        // Initialize the view controller using the xib file with the same
        // filename
        if defaultNib {
            let nibName = String(describing: type(of: self))
            let bundle = Bundle(for: type(of: self))
            self.init(nibName: nibName, bundle: bundle)
        } else {
            self.init()
        }
    }

}
