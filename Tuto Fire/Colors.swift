//
//  Colors.swift
//  Tuto Fire
//
//  Created by Yassine on 13/02/2017.
//  Copyright © 2017 Yassine EN. All rights reserved.
//

import UIKit

extension CALayer {
    func addShadow(cell: UICollectionViewCell) {
        
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1)
        cell.layer.shadowOpacity = 0.2
        cell.layer.shadowRadius = 1.0
        cell.clipsToBounds = false
        cell.layer.masksToBounds = false
        cell.layer.cornerRadius = 2.0
        
    }
    func addGradient(gradientView: UIImageView, TopColor : UIColor, BottomColor : UIColor) {
        
        let gradient = CAGradientLayer()
        
        gradient.frame = gradientView.bounds
        
        gradient.colors = [TopColor.cgColor, BottomColor.cgColor]
        
        gradientView.layer.insertSublayer(gradient, at: 0)
    }
}
