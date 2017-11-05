//
//  PSClassViewController.swift
//  Planetary
//
//  Created by Matthew Turk on 7/26/17.
//  Copyright © 2017 MonitorMOJO, Inc. All rights reserved.
//

import UIKit

class PSClassViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet var vidDescTextView: UITextView!
    @IBOutlet var vidWebView: UIWebView!
    let classReachability = Reachability()!
    var vidUrl = ""
    var vidDesc = ""
    var classNumber = 1
    let preferredLanguage = Locale.preferredLanguages[0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Class " + String(classNumber + 1)
        let vidId = print(vidUrl.characters.split(separator: "/").map(String.init)[3].replacingOccurrences(of: "?rel=", with: ""))
        vidWebView.scrollView.contentInset = .zero
        vidWebView.scrollView.isScrollEnabled = false
        vidWebView.scrollView.bounces = false
        vidWebView.delegate = self
        vidDescTextView.text = vidDesc
        NotificationCenter.default.addObserver(self, selector: #selector(internetChanged(note:)), name: ReachabilityChangedNotification, object: classReachability)
        do {
            try classReachability.startNotifier()
        } catch {
            print("failed to start notifier")
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
        vidWebView.loadHTMLString("<iframe style=\"margin-left: -15px; margin-top: -15px\" width=\"\(vidWebView.frame.width + 15)\" height=\"\(vidWebView.frame.height + 15)\" src=\"\(vidUrl)\" frameborder=\"0\" allowfullscreen></iframe>", baseURL: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        vidWebView.loadHTMLString("<iframe style=\"margin-left: -15px; margin-top: -15px\" width=\"\(size.width + 15)\" height=\"\(vidWebView.frame.height + 15)\" src=\"\(vidUrl)\" frameborder=\"0\" allowfullscreen></iframe>", baseURL: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print(error.localizedDescription)
        vidDescTextView.text = vidDescTextView.text + "\n\nERROR: " + error.localizedDescription
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        vidDescTextView.text = vidDesc
    }
    
    func internetChanged(note: NSNotification) {
        let reachability = note.object as! Reachability
        if reachability.isReachable {
            print("established network connection")
            vidWebView.loadHTMLString("<iframe style=\"margin-left: -15px; margin-top: -15px\" width=\"\(vidWebView.frame.width + 15)\" height=\"\(vidWebView.frame.height + 15)\" src=\"\(vidUrl)\" frameborder=\"0\" allowfullscreen></iframe>", baseURL: nil)
        } else {
            print("lost network connection")
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
