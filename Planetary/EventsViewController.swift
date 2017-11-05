//
//  EventsViewController.swift
//  
//
//  Created by Matthew Turk on 7/28/17.
//
//

import UIKit
import WebKit
import SwiftSoup
import Firebase
import Foundation

class EventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GADNativeExpressAdViewDelegate {

    @IBOutlet var eventsTableView: UITableView!
    private let EWAdUnitId = "ca-app-pub-2723394137854237/2325403689"
    let EWReachability = Reachability()!
    var EWNativeAdView = GADNativeExpressAdView()
    var PSEventsPosts = [PlanetaryPost]()
    private let eventSegueIdentifier = "eventSegue"
    let refreshControl = UIRefreshControl()
    let myURLString = "http://www.planetary.org/get-involved/events/"
    let preferredLanguage = Locale.preferredLanguages[0]
    var didLoadData = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //self.startActivityIndicator()
        customActivityIndicatory(self.view, startAnimate: true)
        
        eventsTableView.allowsSelection = true
        if EWReachability.isReachable {
            loadAd()
        } else {
            print("network unreachable")
            //alert user/update UI
            self.setBackgroundDefault()
        }
        
        /*EWReachability.whenUnreachable = { _ in
            print("network unreachable")
            //alert user/update UI
            self.setBackgroundDefault()
        }*/
        
        NotificationCenter.default.addObserver(self, selector: #selector(internetChanged(note:)), name: ReachabilityChangedNotification, object: EWReachability)
        do {
            try EWReachability.startNotifier()
        } catch {
            print("failed to start notifier")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if EWReachability.isReachable {
            if !didLoadData {
                self.loadData()
            }
            customActivityIndicatory(self.view, startAnimate: false)
            
            if self.eventsTableView?.visibleCells.count != 0 {
                self.title = "Events"
            } else {
                self.loadData()
            }
            customActivityIndicatory(self.view, startAnimate: false)
        }
        eventsTableView.isUserInteractionEnabled = true
        eventsTableView.isScrollEnabled = true
        Analytics.setScreenName("Events", screenClass: "EventsViewController")
    }
    
    func loadData() {
        
        refreshControl.addTarget(self, action: #selector(ViewController.refreshData), for: .valueChanged)
        
        if #available(iOS 10.0, *) {
            eventsTableView.refreshControl = refreshControl
        } else {
            eventsTableView.addSubview(refreshControl)
        }
        
        guard let myURL = URL(string: myURLString) else {
            print("Error: \(myURLString) doesn't seem to be a valid URL")
            return
        }
        
        do {
            
            let myHTMLString = try String(contentsOf: myURL, encoding: .utf8)
            PSEventsPosts = try! EventsResponse(myHTMLString).posts
            
            
        } catch let error {
            print("Error parsing blogs: \(error)")
        }
        self.eventsTableView.isScrollEnabled = true
        self.eventsTableView.separatorStyle = .singleLine
        self.eventsTableView.backgroundColor = UIColor.white
        self.eventsTableView.reloadData()
        didLoadData = true
    }
    
    func refreshData() {
        
        guard let myURL = URL(string: myURLString) else {
            print("Error: \(myURLString) doesn't seem to be a valid URL")
            return
        }
        
        do {
            
            let myHTMLString = try String(contentsOf: myURL, encoding: .utf8)
            PSEventsPosts = try! EventsResponse(myHTMLString).posts
            
            if !PSEventsPosts.isEmpty {
                if try! PSEventsPosts[0].title != EventsResponse(myHTMLString).posts[0].title {
                    //prepend to PSPosts
                    //this will be a loop eventually
                    try! PSEventsPosts.insert(PlanetaryResponse(myHTMLString).posts[0], at: 0)
                }
            }
            
            
        } catch let error {
            print("Error parsing blogs: \(error)")
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.eventsTableView.reloadData()
            self.refreshControl.perform(#selector(self.refreshControl.endRefreshing), with: nil, afterDelay: 0.01)
        })
        
    }
    
    func internetChanged(note: NSNotification) {
        let reachability = note.object as! Reachability
        if reachability.isReachable {
            print("established network connection")
            self.customActivityIndicatory(self.view, startAnimate: true)
            self.loadAd()
            self.loadData()
            self.customActivityIndicatory(self.view, startAnimate: false)
        } else {
            print("lost network connection")
        }
    }
    
    func loadAd() {
        EWNativeAdView.adUnitID = EWAdUnitId
        self.EWNativeAdView.adSize = GADAdSizeFromCGSize(CGSize(width: UIScreen.main.bounds.width, height: 150))
        self.EWNativeAdView.frame = CGRect(x: 0, y:0, width: UIScreen.main.bounds.width, height: 150)
        
        EWNativeAdView.rootViewController = self
        EWNativeAdView.delegate = self
        let rq = GADRequest()
        rq.testDevices = [kGADSimulatorID, "b0564293d014496576bd95f02237d4dd"]
        EWNativeAdView.load(rq)
        
        EWNativeAdView.isHidden = true
        self.eventsTableView.tableHeaderView?.isHidden = true
    }
    
    func setBackgroundDefault() {
        
        //remove the spinner because nothing's loading.
        customActivityIndicatory(self.view, startAnimate: false)
        
        //check screen size and determine device.
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        //disable scroll
        self.eventsTableView.isScrollEnabled = false
        self.eventsTableView.separatorStyle = .none
        
        //iphone 5
        if (screenHeight == 568 && screenWidth == 320){
            eventsTableView.backgroundColor = UIColor(patternImage: UIImage(named: "noPosts_iphone5.pdf")!)
        }
            //iphone 6
        else if (screenHeight == 667 && screenWidth == 375){
            eventsTableView.backgroundColor = UIColor(patternImage: UIImage(named: "noPosts_iphone6.pdf")!)
        }
            //iphone 6+
        else if (screenHeight == 736 && screenWidth == 414){
            eventsTableView.backgroundColor = UIColor(patternImage: UIImage(named: "noPosts_iphonePlus.pdf")!)
            
        } else {
            eventsTableView.backgroundColor = UIColor(patternImage: UIImage(named: "noPosts_ipad.pdf")!)
        }
        
    }
    
    func customActivityIndicatory(_ viewContainer: UIView, startAnimate:Bool? = true) -> UIActivityIndicatorView {
        let mainContainer: UIView = UIView(frame: viewContainer.frame)
        mainContainer.center = viewContainer.center
        //mainContainer.backgroundColor = .lightGray
        //mainContainer.alpha = 0.5
        mainContainer.tag = 789456123
        mainContainer.isUserInteractionEnabled = false
        
        let viewBackgroundLoading: UIView = UIView(frame: CGRect(x:0,y: 0,width: 80,height: 80))
        viewBackgroundLoading.center = viewContainer.center
        viewBackgroundLoading.backgroundColor = .darkGray
        viewBackgroundLoading.alpha = 0.5
        viewBackgroundLoading.clipsToBounds = true
        viewBackgroundLoading.layer.cornerRadius = 15
        
        let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.frame = CGRect(x:0.0,y: 0.0,width: 40.0, height: 40.0)
        activityIndicatorView.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        activityIndicatorView.center = CGPoint(x: viewBackgroundLoading.frame.size.width / 2, y: viewBackgroundLoading.frame.size.height / 2)
        if startAnimate!{
            self.eventsTableView.separatorStyle = .none
            viewBackgroundLoading.addSubview(activityIndicatorView)
            mainContainer.addSubview(viewBackgroundLoading)
            viewContainer.addSubview(mainContainer)
            activityIndicatorView.startAnimating()
        } else {
            for subview in viewContainer.subviews {
                if subview.tag == 789456123 {
                    subview.removeFromSuperview()
                }
            }
        }
        return activityIndicatorView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PSEventsPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventsCell", for: indexPath) as! EventsTableViewCell
        cell.eventTitleLabel.text = self.PSEventsPosts[indexPath.row].title
        cell.eventDescLabel.text = self.PSEventsPosts[indexPath.row].desc
        cell.eventImageView.loadUsingCache(PSEventsPosts[indexPath.row].imgUrl)
        
        return cell
    }
    
    func nativeExpressAdView(_ nativeExpressAdView: GADNativeExpressAdView, didFailToReceiveAdWithError error: GADRequestError) {
        print(error)
        
        self.EWNativeAdView.frame = CGRect(x: 0, y:0, width: UIScreen.main.bounds.width, height: 0)
        self.eventsTableView.tableHeaderView = nil
        
        self.eventsTableView.sectionHeaderHeight = 0
    }
    
    func nativeExpressAdViewDidReceiveAd(_ nativeExpressAdView: GADNativeExpressAdView) {
        self.eventsTableView.sectionHeaderHeight = 150
        nativeExpressAdView.isHidden = false
        self.eventsTableView.tableHeaderView?.isHidden = false
        self.eventsTableView.tableHeaderView = nativeExpressAdView
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == eventSegueIdentifier {
            let destination = segue.destination as? PSEventViewController
            let classIndex = self.eventsTableView.indexPathForSelectedRow?.row
            destination?.eventTitle = PSEventsPosts[classIndex!].title
            destination?.eventUrl = PSEventsPosts[classIndex!].url
            destination?.eventDescription = PSEventsPosts[classIndex!].desc
            self.eventsTableView.deselectRow(at: self.eventsTableView.indexPathForSelectedRow!, animated: true)
            Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
                AnalyticsParameterSource: PSEventsPosts[classIndex!].url as NSObject,
                AnalyticsParameterItemName: PSEventsPosts[classIndex!].title as NSObject,
                AnalyticsParameterContentType: "event" as NSObject
                ])
        }
    }

}
