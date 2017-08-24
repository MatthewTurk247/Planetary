//
//  ClassesTableViewController.swift
//  Planetary
//
//  Created by Matthew Turk on 7/26/17.
//  Copyright © 2017 MonitorMOJO, Inc. All rights reserved.
//

import UIKit
import WebKit
import SwiftSoup
import Firebase
import Foundation

class ClassesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GADNativeExpressAdViewDelegate {

    @IBOutlet var ClassesTableView: UITableView!
    var PSClassPosts = [PlanetaryPost]()
    let classSegueIdentifier = "PSClassSegue"
    private let CAdUnitId = "ca-app-pub-2723394137854237/2325403689"
    var CNativeAdView = GADNativeExpressAdView()
    let CReachability = Reachability()!
    let preferredLanguage = Locale.preferredLanguages[0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if CReachability.isReachable {
            self.loadData()
        }
        
        CReachability.whenUnreachable = { _ in
            print("network unreachable")
            //alert user/update UI
            self.setBackgroundDefault()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(internetChanged(note:)), name: ReachabilityChangedNotification, object: CReachability)
        do {
            try CReachability.startNotifier()
        } catch {
            print("failed to start notifier")
        }
        
        loadData()
    }

    func loadData() {
        
        CNativeAdView.adUnitID = CAdUnitId
        self.CNativeAdView.adSize = GADAdSizeFromCGSize(CGSize(width: UIScreen.main.bounds.width, height: 150))
        self.CNativeAdView.frame = CGRect(x: 0, y:0, width: UIScreen.main.bounds.width, height: 150)
        
        CNativeAdView.rootViewController = self
        CNativeAdView.delegate = self
        let rq = GADRequest()
        rq.testDevices = [kGADSimulatorID, "b0564293d014496576bd95f02237d4dd"]
        CNativeAdView.load(rq)
        
        CNativeAdView.isHidden = true
        self.ClassesTableView.tableHeaderView?.isHidden = true
        
        let myURLString = "http://www.planetary.org/multimedia/video/bettsclass/"
        guard let myURL = URL(string: myURLString) else {
            print("Error: \(myURLString) doesn't seem to be a valid URL")
            return
        }
        
        do {
            let myHTMLString = try String(contentsOf: myURL, encoding: .utf8)
            PSClassPosts = try! ClassesResponse(myHTMLString).posts
            
            
        } catch let error {
            print("Error parsing blogs: \(error)")
        }
        ClassesTableView.isScrollEnabled = true
        ClassesTableView.separatorStyle = .singleLine
        ClassesTableView.backgroundColor = UIColor.white
        ClassesTableView.reloadData()
    }
    
    func internetChanged(note: NSNotification) {
        let reachability = note.object as! Reachability
        if reachability.isReachable {
            print("established network connection")
            self.loadData()
        } else {
            print("lost network connection")
        }
    }
    
    func setBackgroundDefault() {
        
        //check screen size and determine device.
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        //disable scroll
        self.ClassesTableView.isScrollEnabled = false
        self.ClassesTableView.separatorStyle = .none
        
        //iphone 5
        if (screenHeight == 568 && screenWidth == 320){
            ClassesTableView.backgroundColor = UIColor(patternImage: UIImage(named: "noPosts_iphone5.pdf")!)
        }
            //iphone 6
        else if (screenHeight == 667 && screenWidth == 375){
            ClassesTableView.backgroundColor = UIColor(patternImage: UIImage(named: "noPosts_iphone6.pdf")!)
        }
            //iphone 6+
        else if (screenHeight == 736 && screenWidth == 414){
            ClassesTableView.backgroundColor = UIColor(patternImage: UIImage(named: "noPosts_iphonePlus.pdf")!)
            
        } else {
            ClassesTableView.backgroundColor = UIColor(patternImage: UIImage(named: "noPosts_ipad.pdf")!)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return PSClassPosts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "classReuseIdentifier", for: indexPath) as! PSClassTableViewCell
        cell.PSClassTitleLabel.text = PSClassPosts[indexPath.row].title.replacingOccurrences(of: "Intro Astronomy 2017. ", with: "")
        cell.PSClassDescriptionLabel.text = PSClassPosts[indexPath.row].desc
        cell.PSClassImageView.loadUsingCache(PSClassPosts[indexPath.row].imgUrl)

        // Configure the cell...

        return cell
    }
    
    func nativeExpressAdView(_ nativeExpressAdView: GADNativeExpressAdView, didFailToReceiveAdWithError error: GADRequestError) {
        print(error)
        self.CNativeAdView.frame = CGRect(x: 0, y:0, width: UIScreen.main.bounds.width, height: 0)
        self.ClassesTableView.tableHeaderView = nil
        self.ClassesTableView.sectionHeaderHeight = 0
        
    }
    
    func nativeExpressAdViewDidReceiveAd(_ nativeExpressAdView: GADNativeExpressAdView) {
        self.ClassesTableView.sectionHeaderHeight = 150
        nativeExpressAdView.isHidden = false
        self.ClassesTableView.tableHeaderView?.isHidden = false
        self.ClassesTableView.tableHeaderView = nativeExpressAdView
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == classSegueIdentifier {
            let destination = segue.destination as? PSClassViewController
            let classIndex = self.ClassesTableView.indexPathForSelectedRow?.row
            destination?.vidUrl = PSClassPosts[classIndex!].url
            destination?.vidDesc = PSClassPosts[classIndex!].desc
            destination?.classNumber = classIndex!
            self.ClassesTableView.deselectRow(at: self.ClassesTableView.indexPathForSelectedRow!, animated: true)
            Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
                AnalyticsParameterSource: PSClassPosts[classIndex!].url as NSObject,
                AnalyticsParameterItemName: PSClassPosts[classIndex!].title as NSObject,
                AnalyticsParameterContentType: "class" as NSObject
                ])
        }
    }

}
