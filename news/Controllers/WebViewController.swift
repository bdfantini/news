//
//  WebViewController.swift
//  news
//
//  Created by Benjamin Fantini on 9/2/17.
//  Copyright © 2017 Benjamin Fantini. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    // MARK: UI
    
    var webView = WKWebView()
    
    // MARK: Properties
    
    var urlString: String?
    
    // MARK: Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = self.webView
        
        if let urlString = urlString,
            let url = URL(string: urlString) {
            
            let request = URLRequest(url: url)
            self.webView.load(request)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
