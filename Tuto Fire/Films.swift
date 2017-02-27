//
//  Films.swift
//  Tuto Fire
//
//  Created by Yassine on 11/02/2017.
//  Copyright © 2017 Yassine EN. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Films {
    var name: String
    var film: String
    
    init(name: String, film: String) {
        self.name = name
        self.film = film
    }
}
