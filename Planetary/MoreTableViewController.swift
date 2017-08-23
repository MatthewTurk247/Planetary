//
//  MoreTableViewController.swift
//  
//
//  Created by Matthew Turk on 8/3/17.
//
//

import UIKit
import WebKit
import SafariServices

class MoreTableViewController: UITableViewController {

    let preferredLanguage = Locale.preferredLanguages[0]
    var loginWebView = WKWebView()
    @IBOutlet var shopContentView: UIView!
    @IBOutlet var donateContentVIew: UIView!
    @IBOutlet var videoContentView: UIView!
    @IBOutlet var audioContentView: UIView!
    @IBOutlet var copyrightLabel: UILabel!
    func handleShopTap(_ sender: UITapGestureRecognizer) {
        let safariViewController = SFSafariViewController(url: URL(string: "https://www.chopshopstore.com/collections/planetarysociety")!, entersReaderIfAvailable: false)
        present(safariViewController, animated: true)
    }
    func handleDonateTap(_ sender: UITapGestureRecognizer) {
        let safariViewController = SFSafariViewController(url: URL(string: "https://secure.planetary.org/site/SPageNavigator/supportprojects.html")!, entersReaderIfAvailable: false)
        present(safariViewController, animated: true)
    }
    func handleVideoTap(_ sender: UITapGestureRecognizer) {
        let safariViewController = SFSafariViewController(url: URL(string: "http://www.planetary.org/multimedia/planetary-tv/")!, entersReaderIfAvailable: false)
        present(safariViewController, animated: true)
    }
    func handleAudioTap(_ sender: UITapGestureRecognizer) {
        let safariViewController = SFSafariViewController(url: URL(string: "http://www.planetary.org/multimedia/planetary-radio/")!, entersReaderIfAvailable: false)
        present(safariViewController, animated: true)
    }
    func handleLoginTap(_ sender: UITapGestureRecognizer) {
        
        let alertController = UIAlertController(title: "Login", message: "To register, please visit:\n\"planetary.org/register\"", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Login", style: .default) { (_) in
            if let fields = alertController.textFields! as? [UITextField] {
                
                // store and use entered email
                let username = fields[0].text!
                let password = fields[1].text!
                let loginUrl = URL(string: "https://secure.planetary.org/site/UserLogin")!
                let loginRequest = URLRequest(url: loginUrl)
                self.loginWebView.frame = CGRect(x: 0, y: 0, width: 400, height: 500)
                self.loginWebView.load(loginRequest)
                self.view.addSubview(self.loginWebView)
                self.loginWebView.evaluateJavaScript("document.getElementById('USERNAME').value = \(username);", completionHandler: nil)
                self.loginWebView.evaluateJavaScript("document.getElementById('Password').value = \(password);", completionHandler: nil)
                self.loginWebView.evaluateJavaScript("document.getElementById('login').submit()", completionHandler: nil)
                //loginWebView.reload()
                self.loginWebView.evaluateJavaScript("document.getElementsByTagName('html')[0].innerHTML", completionHandler: { (innerHTML, error) in
                    print("hello")
                    print(innerHTML!)
                })
                
                
            } else {
                print("please enter info")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Username"
            textField.keyboardType = .default
        }
        
        alertController.addTextField { (passwordTextField) in
            passwordTextField.placeholder = "Password"
            passwordTextField.keyboardType = .default
            passwordTextField.isSecureTextEntry = true
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let shopTap = UITapGestureRecognizer(target: self, action: #selector(self.handleShopTap(_:)))
        shopContentView.addGestureRecognizer(shopTap)
        let donateTap = UITapGestureRecognizer(target: self, action: #selector(self.handleDonateTap(_:)))
        donateContentVIew.addGestureRecognizer(donateTap)
        let videoTap = UITapGestureRecognizer(target: self, action: #selector(self.handleVideoTap(_:)))
        videoContentView.addGestureRecognizer(videoTap)
        let audioTap = UITapGestureRecognizer(target: self, action: #selector(self.handleAudioTap(_:)))
        audioContentView.addGestureRecognizer(audioTap)
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            let date = Date()
            let calendar = Calendar.current
            let year = calendar.component(.year, from: date)
            self.copyrightLabel.text = "Planetary v" + version + "\n©\(year) MonitorMOJO, Inc. All rights reserved."
        }
        //let loginTap = UITapGestureRecognizer(target: self, action: #selector(self.handleLoginTap(_:)))
        //loginContentView.addGestureRecognizer(loginTap)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Table view data source
    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    */

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
