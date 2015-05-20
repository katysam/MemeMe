//
//  Meme.swift
//  Image Picker
//
//  Created by Kathryn on 5/6/15.
//  Copyright (c) 2015 KSamalin. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    
    let text1: String?
    let text2: String?
    let originalImage: UIImage?
    let memedImage: UIImage!
    
    init(text1: String, text2: String, originalImage: UIImage, memedImage: UIImage) {
        self.text1 = text1
        self.text2 = text2
        self.originalImage = originalImage
        self.memedImage = memedImage
    }


}
