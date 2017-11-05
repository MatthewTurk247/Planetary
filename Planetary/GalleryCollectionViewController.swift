//
//  GalleryCollectionViewController.swift
//  Planetary
//
//  Created by Matthew Turk on 8/3/17.
//  Copyright © 2017 MonitorMOJO, Inc. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "galleryCell"
private let segueIdentifier = "gallerySegue"
var PSGalleryPosts = [PlanetaryPost]()
var screenSize: CGRect!
var screenWidth: CGFloat!
var screenHeight: CGFloat!
let rc = Reachability()!
let preferredLanguage = Locale.preferredLanguages[0]
let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
var didLoadData = false


class GalleryCollectionViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //perform(#selector(asdf), with: nil, afterDelay: 0.01)
        customActivityIndicatory(self.view, startAnimate: true)

        //self.collectionView?.backgroundView = activityIndicatorView
        self.title = "Gallery"

        rc.whenUnreachable = { _ in
            self.setBackgroundDefault()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(internetChanged(note:)), name: ReachabilityChangedNotification, object: rc)
        do {
            try rc.startNotifier()
        } catch {
            print("failed to start notifier")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Analytics.setScreenName("Gallery", screenClass: "GalleryCollectionViewController")
        UIApplication.shared.statusBarStyle = .lightContent
        
        if rc.isReachable {
            if !didLoadData {
                self.loadData()
            }
        }
        
        if self.collectionView?.visibleCells.count != 0 {
            self.title = "Gallery"
            self.customActivityIndicatory(self.view, startAnimate: false)
        } else {
            self.loadData()
            self.collectionView?.reloadData()
            self.customActivityIndicatory(self.view, startAnimate: false)
        }
        
        self.customActivityIndicatory(self.view, startAnimate: false)
        //activityIndicatorView.startAnimating()
         // a bit of trpouble with hiding this...
    }
    
    func loadData() {
        
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: screenWidth/2 - 0.5, height: screenWidth/2)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 1
        collectionView!.collectionViewLayout = layout
        
        let myURLString = "http://planetary.org/multimedia/space-images/"
        guard let myURL = URL(string: myURLString) else {
            print("Error: \(myURLString) doesn't seem to be a valid URL")
            return
        }
        
        do {
            let myHTMLString = try String(contentsOf: myURL, encoding: .utf8)
            PSGalleryPosts = try! GalleryResponse(myHTMLString).posts
            
        } catch let error {
            print("Error parsing blogs: \(error)")
        }
        collectionView?.isScrollEnabled = true
        collectionView?.reloadData()
        didLoadData = true
    }
    
    func internetChanged(note: NSNotification) {
        let reachability = note.object as! Reachability
        if reachability.isReachable {
            print("established network connection")
            self.loadData()
            self.customActivityIndicatory(self.view, startAnimate: false)
            //activityIndicatorView.stopAnimating()
        } else {
            print("lost network connection")
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
        if startAnimate! {
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        layout.itemSize = CGSize(width: size.width/2 - 0.5, height: size.width/2)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == segueIdentifier {
            let destination = segue.destination as? PSImageViewController
            let galleryIndex = self.collectionView?.indexPath(for: sender as! UICollectionViewCell)?.row
            destination?.PSImageViewControllerUrl = PSGalleryPosts[galleryIndex!].imgUrl
            Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
                AnalyticsParameterSource: PSGalleryPosts[galleryIndex!].url as NSObject,
                AnalyticsParameterItemName: PSGalleryPosts[galleryIndex!].title as NSObject,
                AnalyticsParameterContentType: "image" as NSObject
                ])
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PSGalleryPosts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
        
        if let cellImageView = cell.viewWithTag(1) as? UIImageView {
            cellImageView.loadUsingCache(PSGalleryPosts[indexPath.row].imgUrl)
        }
        
        if let cellLabelView = cell.viewWithTag(2) as? UILabel {
            cellLabelView.text = "  " + PSGalleryPosts[indexPath.row].title
        }
        
        return cell
    }
    
    func setBackgroundDefault() {
        
        //remove the spinner becuase nothing's loading
        //activityIndicatorView.stopAnimating()
        self.customActivityIndicatory(self.view, startAnimate: false)
        
        //check screen size and determine device.
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        //disable scroll
        self.collectionView?.isScrollEnabled = false
        
        //iphone 5
        if (screenHeight == 568 && screenWidth == 320){
            collectionView?.backgroundColor = UIColor(patternImage: UIImage(named: "noPosts_iphone5.pdf")!)
        }
            //iphone 6
        else if (screenHeight == 667 && screenWidth == 375){
            collectionView?.backgroundColor = UIColor(patternImage: UIImage(named: "noPosts_iphone6.pdf")!)
        }
            //iphone 6+
        else if (screenHeight == 736 && screenWidth == 414){
            collectionView?.backgroundColor = UIColor(patternImage: UIImage(named: "noPosts_iphonePlus.pdf")!)
            
        } else {
            collectionView?.backgroundColor = UIColor(patternImage: UIImage(named: "noPosts_ipad.pdf")!)
        }
        
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
