//
//  PSBlogViewController.swift
//  Hackin the Web
//
//  Created by Matthew Turk on 7/21/17.
//  Copyright © 2017 MonitorMOJO, Inc. All rights reserved.
//

import UIKit
import SafariServices

class PSBlogViewController: UIViewController {
    
    let preferredLanguage = Locale.preferredLanguages[0]
    var go = true
    var btn = UIButton()
    var timer = Timer()
    var blogUrl = String()
    var blogTitle = String()
    var rc = Reachability()!
    func updateCounting() {
      //print("counting...")
    }
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Loading..."
        print(blogTitle, blogUrl)
        scheduledTimerWithTimeInterval()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.title = "Loading..."
        if !blogUrl.isEmpty {
            guard let postURL = URL(string: blogUrl) else {
                print("Error: \(blogUrl) doesn't seem to be a valid URL")
                let alertController = UIAlertController(title: "Error", message: "Something went wrong. Try again.", preferredStyle: .alert)
                self.present(alertController, animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
                return
            }
            let safariViewController = PSSafariViewController(url: postURL, entersReaderIfAvailable: true)
            //safariViewController.view.isUserInteractionEnabled
            //safariViewController.view.subviews
            UIApplication.shared.isStatusBarHidden = true
            if animated {
                present(safariViewController, animated: false) {
                    var frame = safariViewController.view.frame
                    let OffsetY: CGFloat  = 44
                    frame.origin = CGPoint(x: frame.origin.x, y: frame.origin.y - OffsetY)
                    frame.size = CGSize(width: frame.width, height: frame.height + OffsetY)
                    safariViewController.view.frame = frame
                    self.btn = UIButton(frame: CGRect(x: 5, y: 50, width: 50, height: 50))
                    self.btn.layer.cornerRadius = 25
                    self.btn.backgroundColor = UIColor(red: 0, green: 170/255, blue: 240/255, alpha: 0.5)
                    self.btn.setTitle("←", for: .normal)
                    self.btn.addTarget(self, action: #selector(safariViewController.buttonAction(sender:)), for: .touchUpInside)
                    self.btn.tag = 1 // change tag property
                    self.btn.isOpaque = true
                    safariViewController.view.addSubview(self.btn)
                    safariViewController.view.bringSubview(toFront: self.btn)
                    self.btn.layer.zPosition = safariViewController.view.layer.zPosition + 1
                    for subview in safariViewController.view.subviews {
                        subview.isUserInteractionEnabled = false
                    }
                    self.btn.isEnabled = true
                    self.btn.isUserInteractionEnabled = true
                    //print(self.btn.description)
                }
            } else {
                UIApplication.shared.isStatusBarHidden = false
                UIApplication.shared.statusBarStyle = .lightContent
                self.title = ""
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}
