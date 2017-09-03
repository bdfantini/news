//
//  WebViewController.swift
//  news
//
//  Created by Benjamin Fantini on 9/2/17.
//  Copyright © 2017 Benjamin Fantini. All rights reserved.
//

import NVActivityIndicatorView
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
        
        // Set the WebView as the whole view
        self.view = self.webView
        self.webView.navigationDelegate = self
        
        // Load the url on the WebView
        if let urlString = urlString,
            let url = URL(string: urlString) {
            
            let request = URLRequest(url: url,
                                     cachePolicy: .useProtocolCachePolicy,
                                     timeoutInterval: 5)
            self.webView.load(request)
        }
    }

}

// MARK: - WKNavigationDelegate

extension WebViewController: WKNavigationDelegate, NVActivityIndicatorViewable {
    
    func webView(_ webView: WKWebView,
                 didFinish navigation: WKNavigation!) {
        
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
    
    func webView(_ webView: WKWebView,
                 didStartProvisionalNavigation navigation: WKNavigation!) {
        
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    }
    
    func webView(_ webView: WKWebView,
                 didFail navigation: WKNavigation!,
                 withError error: Error) {
        
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        self.showErrorAlert(message: error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView,
                 didFailProvisionalNavigation navigation: WKNavigation!,
                 withError error: Error) {
        
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        self.showErrorAlert(message: error.localizedDescription)
    }
}
