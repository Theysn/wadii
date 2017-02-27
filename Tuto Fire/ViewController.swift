//
//  ViewController.swift
//  Tuto Fire
//
//  Created by Yassine on 11/02/2017.
//  Copyright © 2017 Yassine EN. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import GoogleMobileAds

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var ref: FIRDatabaseReference!
    var databaseHandle: FIRDatabaseHandle?
    var databaseImageHandle: FIRDatabaseHandle?
    var postData : [String] = []
     var interstitial = GADInterstitial()
   
    @IBOutlet weak var BannerView: GADBannerView!
    var imageData = [String]()
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        makeAd()
        createAndLoadInterstitial()
        
        ref = FIRDatabase.database().reference()
        
        databaseHandle = ref?.child("Films").observe(.childAdded, with: { (snapshot) in

            if let actualpost = snapshot.key as? String {
                self.postData.append(actualpost)
               
                self.collectionView.reloadData()
               // print(actualpost)
            }
        })
        
        
    }
    //BannerView
    func makeAd() {
        
        BannerView.adUnitID = "ca-app-pub-1421873277477413/8713911087"
        BannerView.rootViewController = self
        let request = GADRequest()
       // request.testDevices = [kGADSimulatorID]
        BannerView.load(request)
        
        
    }
    func createAndLoadInterstitial() {
       
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-1421873277477413/1190644289")
        let request = GADRequest()
        //TEST CODE
       // request.testDevices = [ kGADSimulatorID, "2077ef9a63d2b398840261c8221a0c9b" ]
        interstitial.load(request)
    }
    func ShowAds() {
        if (interstitial.isReady) {
            interstitial.present(fromRootViewController: self)
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        //Add Shadow from extension Named Colors
       cell.layer.addShadow(cell: cell)
        let topColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        let bottomColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        cell.gradientView.layer.addGradient(gradientView: cell.gradientView, TopColor: topColor, BottomColor: bottomColor)
        
        cell.labelCell.text = postData[indexPath.row]
        
        databaseImageHandle = ref?.child("Films").child(postData[indexPath.row]).child("image").observe(.childAdded, with: { (snapImage) in
            
            let ImagePost = snapImage.value as? String
            if let image = ImagePost {
                
                let url = URL(string: image)
                
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: url!)
                                      DispatchQueue.main.async {
                        cell.imageCell.image = UIImage(data: data!)
                    }
                }

                //self.collectionView.reloadData()
            }
        })
        return cell
    }
   
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "FilmViewController") as! FilmViewController
        
        controller.labelText = postData[indexPath.row]
        
     
        self.ShowAds()
        
            
        self.present(controller, animated: true, completion: nil)
       
        
    }
   
}

