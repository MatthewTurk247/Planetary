//
//  PSSafariViewController.swift
//  Hackin the Web
//
//  Created by Matthew Turk on 7/25/17.
//  Copyright © 2017 MonitorMOJO, Inc. All rights reserved.
//

import UIKit
import SafariServices

class PSSafariViewController: SFSafariViewController {

    func buttonAction(sender: UIButton!) {
        print("tapped")
        //just present the blog tableview controller un animated
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        //self.view.addSubview(btn)
        //self.view.bringSubview(toFront: self.view.viewWithTag(1)!)
        // The back button isn't working right now
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first?.location(in: self.view)
        print("touch ended at \(point!.x) and \(point!.y)")
        //it only registers the touch on the button!
        self.dismiss(animated: false)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
