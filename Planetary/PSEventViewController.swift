//
//  PSEventViewController.swift
//  Planetary
//
//  Created by Matthew Turk on 8/5/17.
//  Copyright © 2017 MonitorMOJO, Inc. All rights reserved.
//

import UIKit
import SwiftSoup
import SafariServices
import Firebase

class PSEventViewController: UIViewController {
    
    var eventTitle = String()
    var eventImgUrl = String()
    var eventUrl = String()
    var eventDescription = String()
    var visitEventUrl = String()
    @IBOutlet var PSEventImageView: UIImageView!
    @IBOutlet var PSEventTitleLabel: UILabel!
    @IBOutlet var PSEventDescriptionLabel: UITextView! //it's actually a textview
    @IBAction func visitEventSite(_ sender: Any) {
        print("Going to \(visitEventUrl)")
        let safariViewController = SFSafariViewController(url: URL(string: visitEventUrl)!, entersReaderIfAvailable: false)
        present(safariViewController, animated: true)
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [AnalyticsParameterContent: visitEventUrl as NSObject, AnalyticsParameterContentType: "external_site" as NSObject])
    }
    @IBOutlet var visitEventBarButtonItem: UIBarButtonItem!
    let preferredLanguage = Locale.preferredLanguages[0]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.title = "Event"
        //Second level
        do {
            let secondHTMLString = try String(contentsOf: URL(string: eventUrl)!, encoding: .utf8)
            let secondDoc = try SwiftSoup.parse(secondHTMLString)
            if let eventButton = try secondDoc.select("a.button-blue").first()?.attr("href") {
                print("EventUrl:", eventButton)
                visitEventUrl = eventButton
            } else {
                //remove barbutton item
                self.navigationItem.setRightBarButton(nil, animated: true)
            }
            if let bigImage = try secondDoc.select("img.img840").first()?.attr("src") {
                print("ImgUrl:", bigImage)
                PSEventImageView.contentMode = .scaleAspectFill
                PSEventImageView.loadUsingCache(bigImage)
            }
            
            self.navigationItem.prompt = try secondDoc.select("time").first()!.text()
        
            PSEventTitleLabel.text = try secondDoc.select("h1").first()!.text()
            PSEventDescriptionLabel.text = eventDescription // it's actually a textview
            self.title = try secondDoc.select("h1").first()!.text()
            
        } catch let error {
            print("Error parsing events: \(error)")
            PSEventTitleLabel.text = "Error Loading Data"
            PSEventDescriptionLabel.text = error.localizedDescription
            self.navigationItem.setRightBarButton(nil, animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        PSEventDescriptionLabel.scrollRangeToVisible(NSRange(location:0, length:0))
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
