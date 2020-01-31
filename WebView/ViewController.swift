//
//  ViewController.swift
//  WebView
//
//  Created by Hady on 1/29/20.
//  Copyright © 2020 gadou. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController , WKNavigationDelegate {
    
    var webView : WKWebView!
    var progressView :UIProgressView!
    
    override func loadView() {
         webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //second part refresh , progressive
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace
            , target: nil, action: nil)
        let refresher = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        toolbarItems = [progressButton,spacer , refresher]
        navigationController?.isToolbarHidden = false
        
        
       // first part
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        let url = URL(string: "https://www.Apple.com/")
        webView.load(URLRequest(url: url!))
        webView.allowsBackForwardNavigationGestures = true
        
    }
    
    @objc func openTapped(){
        let alert = UIAlertController(title: "Open...", message: nil, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "filgoal.com", style: .default, handler: openPage)
        let action2 =  UIAlertAction(title: "google.com", style: .default, handler: openPage)
        alert.addAction(action)
        alert.addAction(action2)
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        alert.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(alert, animated: true, completion: nil)
    }
    func openPage(myAction: UIAlertAction){
        guard let actionTitle = myAction.title else {return}
        guard let url = URL(string: "https://www." + actionTitle) else {return}
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }

}

