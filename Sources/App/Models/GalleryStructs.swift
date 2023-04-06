//
//  File.swift
//  
//
//  Created by Ben Schultz on 4/6/23.
//

import Foundation
import Vapor

struct Gallery {
    var id: Int
    var name: String
    var path: String
    var html: String?
    var normalImagePath: String
    var redImagePath: String
    var images = [GalleryImage]()
}

struct GalleryImage {
    var lineNum: Int
    var imagePath: String
    var caption: String
}
