//
//  ViewController.swift
//  Planetary
//
//  Created by Matthew Turk on 6/18/17.
//  Copyright © 2017 MonitorMOJO, Inc. All rights reserved.
//

import UIKit
import WebKit
import SwiftSoup
import Firebase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GADNativeExpressAdViewDelegate {
    
    let VCReachability = Reachability()!
    var VCNativeAdView = GADNativeExpressAdView()
    let webView = WKWebView()
    let refreshControl = UIRefreshControl()
    let cellReuseIdentifier = "cell"
    var pageCount = 1
    @IBOutlet var PSHomeTableView: UITableView!
    var PSPosts = [PlanetaryPost]()
    let blogSegueIdentifier = "PSShowBlogSegue"
    private let VCAdUnitId = "ca-app-pub-2723394137854237/2325403689"
    let myURLString = "http://www.planetary.org/blogs/"
    let preferredLanguage = Locale.preferredLanguages[0]
    var footerSpinner = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if VCReachability.isReachable {
            self.loadData()
        }
        
        VCReachability.whenUnreachable = { _ in
            print("network unreachable")
            //alert user/update UI
            self.setBackgroundDefault()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(internetChanged(note:)), name: ReachabilityChangedNotification, object: VCReachability)
        do {
            try VCReachability.startNotifier()
        } catch {
            print("failed to start notifier")
        }
    }
    
    func loadData() {
        
        VCNativeAdView.adUnitID = VCAdUnitId
        self.VCNativeAdView.adSize = GADAdSizeFromCGSize(CGSize(width: UIScreen.main.bounds.width, height: 150))
        self.VCNativeAdView.frame = CGRect(x: 0, y:0, width: UIScreen.main.bounds.width, height: 150)
        
        VCNativeAdView.rootViewController = self
        VCNativeAdView.delegate = self
        let rq = GADRequest()
        rq.testDevices = [kGADSimulatorID, "b0564293d014496576bd95f02237d4dd"]
        VCNativeAdView.load(rq)
        VCNativeAdView.isHidden = true
        self.PSHomeTableView.tableHeaderView?.isHidden = true
        
        refreshControl.addTarget(self, action: #selector(ViewController.refreshData), for: .valueChanged)
        
        if #available(iOS 10.0, *) {
            PSHomeTableView.refreshControl = refreshControl
        } else {
            PSHomeTableView.addSubview(refreshControl)
        }
        
        guard let myURL = URL(string: myURLString) else {
            print("Error: \(myURLString) doesn't seem to be a valid URL")
            return
        }
        
        do {
            
            let myHTMLString = try String(contentsOf: myURL, encoding: .utf8)
            PSPosts = try! PlanetaryResponse(myHTMLString).posts

        } catch let error {
            print("Error parsing blogs: \(error)")
        }
        self.PSHomeTableView.isScrollEnabled = true
        self.PSHomeTableView.separatorStyle = .singleLine
        self.PSHomeTableView.backgroundColor = UIColor.white
        self.PSHomeTableView.reloadData()
    }
    
    func loadAdditionalPage(page: Int) {
        
        //Initiate spinner
        //self.PSHomeTableView.tableFooterView = footerSpinner
        //self.PSHomeTableView.sectionFooterHeight = 50
        //footerSpinner.startAnimating()
        
        guard let additionalURL = URL(string: myURLString + "index.jsp?page=\(page)") else {
            print("error")
            return
        }
        
        do {
            
            let myAdditionalHTMLString = try String(contentsOf: additionalURL, encoding: .utf8)
            PSPosts += try PlanetaryResponse(myAdditionalHTMLString).posts
            self.PSHomeTableView.reloadData()
            
        } catch let error {
            print(error)
            //reached last page? (unlikely)
        }
        
        //Remove spinner
        //self.footerSpinner.stopAnimating()
        //self.PSHomeTableView.sectionFooterHeight = 0
        //self.PSHomeTableView.tableFooterView = nil
        
    }
    
    func refreshData() {
        
        if VCReachability.isReachable {
            
            VCNativeAdView.adUnitID = VCAdUnitId
            VCNativeAdView.rootViewController = self
            VCNativeAdView.delegate = self
            let rq = GADRequest()
            rq.testDevices = [kGADSimulatorID, "b0564293d014496576bd95f02237d4dd"]
            VCNativeAdView.load(rq)
            
            guard let myURL = URL(string: myURLString) else {
                print("Error: \(myURLString) doesn't seem to be a valid URL")
                return
            }
            
            do {
                
                let myHTMLString = try String(contentsOf: myURL, encoding: .utf8)
                
                //print(PSPosts.count)
                
                if !PSPosts.isEmpty {
                    if try! PSPosts[0].title != PlanetaryResponse(myHTMLString).posts[0].title {
                        //prepend to PSPosts
                        try! PSPosts.insert(PlanetaryResponse(myHTMLString).posts[0], at: 0)
                    }
                }
                
                
            } catch let error {
                print("Error parsing blogs: \(error)")
            }
            
        } else {
            self.refreshControl.endRefreshing()
            print("cant' refresh; no network connection")
        }
        UIView.animate(withDuration: 0.5) {
            self.PSHomeTableView.reloadData()
            self.refreshControl.endRefreshing()
        }
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
    
    func setBackgroundDefault(){
        
        //check screen size and determine device.
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        //disable scroll
        PSHomeTableView.isScrollEnabled = false
        self.PSHomeTableView.separatorStyle = .none
        
        //iphone 5
        if (screenHeight == 568 && screenWidth == 320){
            PSHomeTableView.backgroundColor = UIColor(patternImage: UIImage(named: "noPosts_iphone5.pdf")!)
        }
            //iphone 6
        else if (screenHeight == 667 && screenWidth == 375){
            PSHomeTableView.backgroundColor = UIColor(patternImage: UIImage(named: "noPosts_iphone6.pdf")!)
        }
            //iphone 6+
        else if (screenHeight == 736 && screenWidth == 414){
            PSHomeTableView.backgroundColor = UIColor(patternImage: UIImage(named: "noPosts_iphonePlus.pdf")!)
            
        } else {
            PSHomeTableView.backgroundColor = UIColor(patternImage: UIImage(named: "noPosts_ipad.pdf")!)
        }
        
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PSPosts.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell = self.PSHomeTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! PSTableViewCell!
        
        // set the text from the data model
        cell?.PSTitleLabel.text = self.PSPosts[indexPath.row].title
        cell?.PSDescriptionLabel.text = self.PSPosts[indexPath.row].desc
        cell?.PSAuthorLabel.text = self.PSPosts[indexPath.row].author.uppercased()
        cell?.PSImageView.loadUsingCache(PSPosts[indexPath.row].imgUrl)
        
        //check to see if the user has reached the bottom
        if indexPath.row == self.PSPosts.count - 1 {
            pageCount += 1
            loadAdditionalPage(page: pageCount)
        }
        
        return cell!
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == blogSegueIdentifier {
            let destination = segue.destination as? PSBlogViewController
            let blogIndex = self.PSHomeTableView.indexPathForSelectedRow?.row
            destination?.blogUrl = PSPosts[blogIndex!].url
            destination?.blogTitle = PSPosts[blogIndex!].title
            self.PSHomeTableView.deselectRow(at: self.PSHomeTableView.indexPathForSelectedRow!, animated: true)
            Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
                AnalyticsParameterContent: PSPosts[blogIndex!].url as NSObject,
                AnalyticsParameterItemName: PSPosts[blogIndex!].title as NSObject,
                AnalyticsParameterContentType: "blog_post" as NSObject,
                ])
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func nativeExpressAdView(_ nativeExpressAdView: GADNativeExpressAdView, didFailToReceiveAdWithError error: GADRequestError) {
        //make the ad stuff go away
        print(error)
        self.VCNativeAdView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0)
        self.PSHomeTableView.tableHeaderView = nil
        
        self.PSHomeTableView.sectionHeaderHeight = 0
        
    }
    
    func nativeExpressAdViewDidReceiveAd(_ nativeExpressAdView: GADNativeExpressAdView) {
        print("receive it")
        print(nativeExpressAdView.adUnitID!)
        self.PSHomeTableView.sectionHeaderHeight = 150
        nativeExpressAdView.isHidden = false
        self.PSHomeTableView.tableHeaderView?.isHidden = false
        self.PSHomeTableView.tableHeaderView = nativeExpressAdView
        
    }
    
}

