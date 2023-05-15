//
//  File.swift
//  
//
//  Created by Ben Schultz on 4/6/23.
//

import Foundation
import Vapor
import Leaf

enum GalleryHomePageColumn: String, Content {
    case left
    case right
    case undetermined
}


struct Gallery: Content {
    var id: Int
    var name: String
    var path: String
    var html: String?
    var normalImagePath: String
    var redImagePath: String
    var images = [GalleryImage]()
    var column = GalleryHomePageColumn.undetermined
}

struct GalleryImage: Content {
    var lineNum: Int
    var imagePath: String
    var thumbnailpath: String
    var caption: String
}


