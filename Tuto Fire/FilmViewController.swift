//
//  FilmViewController.swift
//  Tuto Fire
//
//  Created by Yassine on 11/02/2017.
//  Copyright © 2017 Yassine EN. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import GoogleMobileAds

class FilmViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var ref: FIRDatabaseReference!
    var databaseHandle: FIRDatabaseHandle?
    var imageData: String!
    var episodeData = [String]()
    var episodeLink = [String]()
    var labelText:String!
    var counter: Int!
    var imageToCache = UIImage()
    var interstitial = GADInterstitial()
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        createAndLoadInterstitial()
        if let item = labelText {
            
            self.databaseHandle = self.ref?.child("Films").child(item).child("image").observe(.childAdded, with: { (snapshot) in
                
                let post = snapshot.value as? String
                if let actualpost = post {
                    self.imageData = actualpost
                    let url = URL(string: actualpost)
                    let data = try? Data(contentsOf: url!)
                    self.imageToCache = UIImage(data: data!)!
                }
            })
            self.databaseHandle = self.ref?.child("Films").child(item).child("episodes").observe(.childAdded, with: { (snapshot) in
                
                // Get episodes Links
                let eLink = snapshot.value as? String
                if let actual = eLink {
                    self.episodeLink.append(actual)
                    self.collectionView.reloadData()
                    
                }
                
            })
            
            self.databaseHandle = self.ref?.child("Films").child(item).child("episodes").observe(.childAdded, with: { (snapshot) in
                //Get episodes name
                let post = snapshot.key as? String
                if let actualpost = post {
                    self.episodeData.append(actualpost)
                    self.collectionView.reloadData()
                }
            })
            
            
        }
    }
    func createAndLoadInterstitial() {
        
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-1421873277477413/1190644289")
        let request = GADRequest()
        //TEST CODE
        //request.testDevices = [ kGADSimulatorID, "2077ef9a63d2b398840261c8221a0c9b" ]
        interstitial.load(request)
    }
    func ShowAds() {
        if (interstitial.isReady) {
            interstitial.present(fromRootViewController: self)
        }
    }
    
    //numberOfSections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    //NumberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return episodeData.count
    }
    //CollectionViewCell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FilmCollectionViewCell
        //Add Shadow to The cell
        //  cell.layer.addShadow(cell: cell)
        
        // let url = URL(string: imageData)
        
        DispatchQueue.global().async {
            
            DispatchQueue.main.async {
                
                cell.imageCell.image = self.imageToCache
            }
        }
        
        
        cell.labelCell?.text = episodeData[indexPath.row]
        
        
        return cell
    }
    //didSelectItemAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "UIWebViewController") as! UIWebViewController
        controller.LinkURL = episodeLink[indexPath.row]
        ShowAds()
        self.present(controller, animated: true, completion: nil)
    }
    @IBAction func killButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: {})
    }
    
    
    
}
