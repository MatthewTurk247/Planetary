//
//  PSImageViewController.swift
//  Hackin the Web
//
//  Created by Matthew Turk on 8/5/17.
//  Copyright © 2017 MonitorMOJO, Inc. All rights reserved.
//

import UIKit

class PSImageViewController: UIViewController {
    
    let preferredLanguage = Locale.preferredLanguages[0]
    var alpha:CGFloat = 1
    @IBAction func didTapDone(_ sender: UIButton) {
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
        self.dismiss(animated: true, completion: nil)
    }
    var PSImageViewControllerUrl = String()
    @IBOutlet var PSGalleryImageView: UIImageView!
    @IBOutlet var PSGalleryHeader: UIButton!
    func longPressed() {
        print("save image")
        
        let imgActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let saveAction = UIAlertAction(title: "Save Image", style: .default) { (_) in
            let imageRepresentation = UIImagePNGRepresentation(self.PSGalleryImageView.image!)
            let imageData = UIImage(data: imageRepresentation!)
            UIImageWriteToSavedPhotosAlbum(imageData!, nil, nil, nil)
            
            let alert = UIAlertController(title: "Saved!", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        imgActionSheet.addAction(saveAction)
        imgActionSheet.addAction(cancelAction)
        
        self.present(imgActionSheet, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        UIApplication.shared.isStatusBarHidden = true
        PSGalleryImageView.isUserInteractionEnabled = true
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressed))
        longPressRecognizer.minimumPressDuration = 0.5
        PSGalleryImageView.addGestureRecognizer(longPressRecognizer)
        PSGalleryImageView.loadUsingCache(PSImageViewControllerUrl)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first?.location(in: self.view)
        
        UIView.animate(withDuration: 0.5, animations: {
            //self.PSGalleryHeader.isHidden = !self.PSGalleryHeader.isHidden
            
            self.PSGalleryHeader.alpha = -self.alpha
            self.alpha *= -1
            
            self.PSGalleryHeader.isEnabled = !self.PSGalleryHeader.isEnabled
        })
        
        if !PSGalleryHeader.frame.contains(point!) {

        }
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
