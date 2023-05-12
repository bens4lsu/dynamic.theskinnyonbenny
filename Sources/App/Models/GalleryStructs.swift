//
//  File.swift
//  
//
//  Created by Ben Schultz on 4/6/23.
//

import Foundation
import Vapor
import Leaf

struct Gallery: Content {
    var id: Int
    var name: String
    var path: String
    var html: String?
    var normalImagePath: String
    var redImagePath: String
    var images = [GalleryImage]()
}

struct GalleryImage: Content {
    var lineNum: Int
    var imagePath: String
    var caption: String
}
