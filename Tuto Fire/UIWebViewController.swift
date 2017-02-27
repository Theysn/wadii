//
//  UIWebViewController.swift
//  Tuto Fire
//
//  Created by Yassine on 14/02/2017.
//  Copyright © 2017 Yassine EN. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class UIWebViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    var LinkURL:String! = ""
    var ref: FIRDatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if (LinkURL) != nil {
            let url = NSURL (string: LinkURL)
            let request = NSURLRequest(url : url! as URL)
            webView.loadRequest(request as URLRequest)
        }
        else
        {
            self.dismiss(animated: true, completion: {})
        }
    }
    @IBAction func killButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: {})
    }
    
    
    @IBAction func SignalEpisode(_ sender: Any) {
        ref = FIRDatabase.database().reference()
        self.ref.child("users").childByAutoId().setValue(LinkURL)
        let thanksAlert = "شكرا"
        let messageAlert = "سنقوم بإصلاح الحلقة في أقرب وقت ممكن"
        let continueAlert = "متابعة"
        let alert = UIAlertController(title: thanksAlert, message: messageAlert, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: continueAlert, style: .cancel, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
        
        
        
    }
    
    
    
}
