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
    var dataDidLoad = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if CReachability.isReachable {
            loadAd()
        } else {
            print("network unreachable")
            //alert user/update UI
            //self.setBackgroundDefault()
        }
        
        loadData()
        
        /*CReachability.whenUnreachable = { _ in
            print("network unreachable")
            //alert user/update UI
            self.setBackgroundDefault()
        }*/
        
        NotificationCenter.default.addObserver(self, selector: #selector(internetChanged(note:)), name: ReachabilityChangedNotification, object: CReachability)
        do {
            try CReachability.startNotifier()
        } catch {
            print("failed to start notifier")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {

        UIApplication.shared.statusBarStyle = .lightContent
        Analytics.setScreenName("Learn", screenClass: "ClassesTableViewController")
    }

    func loadData() {
        
        let myURLString = "http://www.planetary.org/multimedia/video/bettsclass/"
        guard let myURL = URL(string: myURLString) else {
            print("Error: \(myURLString) doesn't seem to be a valid URL")
            return
        }
        
        do {
            //let myHTMLString = try String(contentsOf: myURL, encoding: .utf8)
            //PSClassPosts = try! ClassesResponse(myHTMLString).posts
            
            PSClassPosts = [PlanetaryPost(title: "Intro Astronomy 2017. Class 1: Tour of the Solar System", desc: "Take a tour of the Solar System in class 1 of Dr. Bruce Betts\' online Introductory Planetary Science and Astronomy course at California State University Dominguez Hills.", author: "Bruce Betts", url: "http://www.youtube.com/embed/YDchpN9f95Y?rel=0", imgUrl: "http://img.youtube.com/vi/YDchpN9f95Y/0.jpg"), PlanetaryPost(title: "Intro Astronomy 2017. Class 2: How We Explore Space", desc: "Lecture 2 of Dr. Bruce Betts\' online Introductory Planetary Science and Astronomy course covers easy things to see in the night sky without a telescope, and the electromagnetic spectrum (from gamma rays to visible to radio waves) -- what it is, and how and why we use different wavelength regions to explore planets and even learn their compositions. The class begins with guest Mat Kaplan, Media Producer for The Planetary Society and Bruce and Mat record a What\'s Up segment for Planetary Radio. Recorded at California State University Dominguez Hills.", author: "Bruce Betts", url: "http://www.youtube.com/embed/v21gJ25aw3c?rel=0", imgUrl: "http://img.youtube.com/vi/v21gJ25aw3c/0.jpg"), PlanetaryPost(title: "Intro Astronomy 2017. Class 3: Telescopes, Eclipses, and the Moon", desc: "Lecture 3 of Dr. Bruce Betts\' online Introductory Planetary Science and Astronomy course covers optical, radio, and space telescopes, eclipses, and an introduction to the Moon including lunar tides, phases and impact cratering. Recorded at California State University Dominguez Hills.", author: "Bruce Betts", url: "https://www.youtube.com/embed/hCv0697DSGw?rel=0", imgUrl: "http://img.youtube.com/vi/hCv0697DSGw/0.jpg"), PlanetaryPost(title: "Intro Astronomy 2017. Class 4: Moon, Mercury, Venus-Earth-Mars Atmospheres", desc: "Lecture 4 of Dr. Bruce Betts\' online Introductory Planetary Science and Astronomy course covers the Moon, Mercury (characteristics, geology, core, exploration, water ice at poles), the Terrestrial Planet Atmospheres/Triad Planets -- a comparison of Venus, Earth, and Mars and why their atmospheres are so different, including discussions of the habitable zone, greenhouse effect, temperature systems (Kelvins, Celsius, Fahrenheit), and the carbon cycle. Recorded at California State University Dominguez Hills.", author: "Bruce Betts", url: "https://www.youtube.com/embed/MeSmCcx3GFU?rel=0", imgUrl: "http://img.youtube.com/vi/MeSmCcx3GFU/0.jpg"), PlanetaryPost(title: "Intro Astronomy 2017. Class 5: Venus & Mars", desc: "Lecture 6 of Dr. Bruce Betts\' 2017 online Introductory Planetary Science and Astronomy course covers Venus (characteristics, geologic evolution, exploration, surface landers, exploration), and Mars (characteristics, many types of geologic features, poles, exploration spacecraft). Recorded at California State University Dominguez Hills.", author: "Bruce Betts", url: "http://www.youtube.com/embed/7cceVMpxrGE?rel=0", imgUrl: "http://img.youtube.com/vi/7cceVMpxrGE/0.jpg"), PlanetaryPost(title: "Intro Astronomy 2017. Class 6: Mars", desc: "Lecture 6 of Dr. Bruce Betts\' 2016 online Introductory Planetary Science and Astronomy course continues exploring Mars including its atmosphere, spacecraft landing and surface operations, and its moons Phobos and Deimos. Recorded at California State University Dominguez Hills.", author: "Bruce Betts", url: "https://www.youtube.com/embed/VTL1J4AVcI8?rel=0", imgUrl: "http://img.youtube.com/vi/VTL1J4AVcI8/0.jpg"), PlanetaryPost(title: "Intro Astronomy 2017. Class 7: Asteroids and the Asteroid Threat", desc: "Lecture 7 of Dr. Bruce Betts\' 2017 online Introductory Planetary Science and Astronomy course covers asteroids and the near Earth asteroid threat to Earth (including statistics, past impacts, and information on the Chelyabinsk fireball). Recorded at California State University Dominguez Hills.", author: "Bruce Betts", url: "http://www.youtube.com/embed/BWpdXwdAgew?rel=0", imgUrl: "http://img.youtube.com/vi/BWpdXwdAgew/0.jpg"), PlanetaryPost(title: "Intro Astronomy 2017. Class 8: Jupiter and Saturn", desc: "Lecture 8 of Dr. Bruce Betts\' 2017 online Introductory Planetary Science and Astronomy course covers Jupiter, the Galilean Satellites (Io, Europa, Ganymede, Callisto), and introduces the Saturnian System. Recorded at California State University Dominguez Hills.", author: "Bruce Betts", url: "https://www.youtube.com/embed/J90hLpbh9-c?rel=0?rel=0", imgUrl: "http://img.youtube.com/vi/J90hLpbh9-c/0.jpg"), PlanetaryPost(title: "Intro Astronomy 2017. Class 9: Saturn and Uranus", desc: "Lecture 9 of Dr. Bruce Betts\' 2017 online Introductory Planetary Science and Astronomy course covers the Saturnian System including atmosphere, interior, rings, and moons and introduces the Uranian system. Recorded at California State University Dominguez Hills.", author: "Bruce Betts", url: "https://www.youtube.com/embed/bJtuZR5Iutg?rel=0", imgUrl: "http://img.youtube.com/vi/bJtuZR5Iutg/0.jpg"), PlanetaryPost(title: "Intro Astronomy 2017. Class 10: Neptune and Trans Neptunian Objects including Pluto and KBOs", desc: "Lecture 10 of Dr. Bruce Betts\' 2017 online Introductory Planetary Science and Astronomy course covers the Neptune System, Transneptunian Objects (TNOs) including the Pluto System and Kuiper Belt Objects, and also covers the solar wind, aurorae, and the heliosphere. Recorded at California State University Dominguez Hills.", author: "Bruce Betts", url: "https://www.youtube.com/embed/yYhkjKus4RA?rel=0", imgUrl: "http://img.youtube.com/vi/yYhkjKus4RA/0.jpg"), PlanetaryPost(title: "Intro Astronomy 2017. Class 11: The Outer Solar System", desc: "Lecture 11 of Dr. Bruce Betts\' 2017 online Introductory Planetary Science and Astronomy course covers the heliosphere, Oort Cloud, light pressure, solar sails, solar effects, comets, origin of solar system, and the laws of planetary motion. Recorded at California State University Dominguez Hills.", author: "Bruce Betts", url: "https://www.youtube.com/embed/zssjqKHI--g?rel=0", imgUrl: "http://img.youtube.com/vi/zssjqKHI--g/0.jpg"), PlanetaryPost(title: "Intro Astronomy 2017. Class 12: Exoplanets, the Sun, and Solar Physics", desc: "Lecture 12 of Dr. Bruce Betts\' 2017 online Introductory Planetary Science and Astronomy course covers exoplanets (planets around other stars) including discovery techniques, current knowledge and characteristics, and multi-planet systems. Lecture 12 also covers the Sun and solar physics. Recorded at California State University Dominguez Hills.", author: "Bruce Betts", url: "https://www.youtube.com/embed/7CZb_d2-TCY?rel=0", imgUrl: "http://img.youtube.com/vi/7CZb_d2-TCY/0.jpg"), PlanetaryPost(title: "Intro Astronomy 2017. Class 13: The Sun (cont.) and Stars", desc: "Lecture 13 of Dr. Bruce Betts\' 2017 online Introductory Planetary Science and Astronomy course continues exploring the Sun (physical characteristics, zones, solar cycle, sunspots, flares, coronal mass ejections, fusion, etc.) and covers stars and stellar evolution (star types and colors, evolution, HR Diagrams, birth and death phases, white dwarfs, neutron stars, black holes). Recorded at California State University Dominguez Hills.", author: "Bruce Betts", url: "https://www.youtube.com/embed/UM4CWcVowjQ?rel=0", imgUrl: "http://img.youtube.com/vi/UM4CWcVowjQ/0.jpg"), PlanetaryPost(title: "Intro Astronomy 2017. Class 14: Galaxies, the Universe, Life", desc: "Lecture 14 of Dr. Bruce Betts\' 2017 online Introductory Planetary Science and Astronomy course covers galaxies (our place in the Milky Way, types of galaxies, Hubble Deep Field), the Universe (determining distances, expansion of the universe, Big Bang theory and evolution of the universe, WMAP and Planck results, dark matter, dark energy, neutrinos), and life in the universe (Earth life requirements, astrobiology, SETI). Recorded at California State University Dominguez Hills.", author: "Bruce Betts", url: "https://www.youtube.com/embed/lJRsgaz6MFA?rel=0", imgUrl: "http://img.youtube.com/vi/lJRsgaz6MFA/0.jpg")]
            
        } catch let error {
            print("Error parsing blogs: \(error)")
        }
        ClassesTableView.isScrollEnabled = true
        ClassesTableView.backgroundColor = .white
        ClassesTableView.reloadData()
        didLoadData = true
    }
    
    func internetChanged(note: NSNotification) {
        let reachability = note.object as! Reachability
        if reachability.isReachable {
            print("established network connection")
            self.loadAd()
            self.loadData()
        } else {
            print("lost network connection")
        }
    }
    
    func loadAd() {
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
    }
    
    func setBackgroundDefault() {
        
        //remove the spinner because nothing's loading.
        
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
        // Configure the cell...
        let cell = tableView.dequeueReusableCell(withIdentifier: "classReuseIdentifier", for: indexPath) as! PSClassTableViewCell
        cell.PSClassTitleLabel.text = PSClassPosts[indexPath.row].title.replacingOccurrences(of: "Intro Astronomy 2017. ", with: "")
        cell.PSClassDescriptionLabel.text = PSClassPosts[indexPath.row].desc
        cell.PSClassImageView.loadUsingCache(PSClassPosts[indexPath.row].imgUrl)
        
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
