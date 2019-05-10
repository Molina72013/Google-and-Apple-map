//
//  WebView.swift
//  TurnToTechMap
//
//  Created by Cristian Molina on 9/17/18.
//  Copyright © 2018 Cristian Molina. All rights reserved.
//

import UIKit
import WebKit

class WebView: UIViewController {

    weak var webView: WKWebView!
    var url: String = "https://www.google.com"
    
    


    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self as? WKUIDelegate
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let myURL = URL(string: url)
        {
        print(myURL)

        let myRequest = URLRequest(url: myURL)
        self.webView.load(myRequest)
        }
    }
    

    
}
