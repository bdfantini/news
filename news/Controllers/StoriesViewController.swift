//
//  StoriesViewController.swift
//  news
//
//  Created by Benjamin Fantini on 8/30/17.
//  Copyright © 2017 Benjamin Fantini. All rights reserved.
//

import UIKit

class StoriesViewController: UIViewController {

    // MARK: Initialization
    
    convenience init(defaultNib: Bool = false) {
        // Initialize the view controller using the xib file with the same
        // filename
        if defaultNib {
            let nibName = String(describing: type(of: self))
            
            self.init(nibName: nibName,
                      bundle: Bundle.main)
        } else {
            self.init()
        }
    }
    
    // MARK: Controller Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Hide the navigation bar for this view controller
        self.navigationController?.isNavigationBarHidden = true
        
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        // Show againt the navigation bar for others controller on the
        // navigation stack
        self.navigationController?.isNavigationBarHidden = false
        
        super.viewWillDisappear(animated)
    }
}
