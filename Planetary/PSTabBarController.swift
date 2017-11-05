//
//  PSTabBarController.swift
//  
//
//  Created by Matthew Turk on 8/24/17.
//
//

import Foundation
import UIKit

class PSTabBarController: UITabBarController, UITabBarControllerDelegate {

    let alert = UIAlertController(title: nil, message: "Loading...", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.delegate = self
        if UserDefaults.isFirstLaunch() {
            //First launch
            perform(#selector(showSlideshow), with: nil, afterDelay: 0.001)
        } else {
            self.selectedIndex = 0
            //perform(#selector(showSlideshow), with: nil, afterDelay: 0.001)
        }
    }
    
    func showSlideshow() {
        present(LaunchSlideshow(), animated: true, completion: nil)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        alertController.view.addSubview(spinnerIndicator)
//        self.present(alertController, animated: false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
