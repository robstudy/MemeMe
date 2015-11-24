//
//  Meme.swift
//  MemeMe
//
//  Created by Robert Garza on 11/23/15.
//  Copyright © 2015 Robert Garza. All rights reserved.
//

import Foundation
import UIKit

class Meme {
    var topText: String = ""
    var bottomText: String = ""
    var image: UIImage?
    var memeImage: UIImage?
    
    init(tText: String, bText: String, img: UIImage, memeImg: UIImage){
        topText = tText
        bottomText = bText
        image = img
        memeImage = memeImg
    }
    
    var description: String {
        get {
            return "Top text:'\(self.topText)', bottom text: '\(self.bottomText)'."
        }
    }
    
}