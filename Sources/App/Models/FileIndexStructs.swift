//
//  File.swift
//  
//
//  Created by Ben Schultz on 1/13/22.
//

import Foundation
import Vapor


struct ImageIndex: Codable, Comparable {
    var yyyy: String
    var mm: String
    var dd: String
    
    var context: ImageIndexContext {
        let index = mm + dd
        let link = AppConfig().imageUrlStart + yyyy + "/" + mm + "/" + dd
        return ImageIndexContext(index: index, link: link)
    }
    
    static func < (lhs: ImageIndex, rhs: ImageIndex) -> Bool {
        if lhs.yyyy != rhs.yyyy { return lhs.yyyy < rhs.yyyy }
        if lhs.mm != rhs.mm { return lhs.mm < rhs.mm }
        return lhs.dd < rhs.dd
    }
    
    static func == (lhs: ImageIndex, rhs:ImageIndex) -> Bool {
        (lhs.yyyy == rhs.yyyy) && (lhs.mm == rhs.mm) && (lhs.dd == rhs.dd)
    }
}

struct ImageIndexContext: Content, Codable {
    var index: String
    var link: String
}

struct FolderContext: Content, Codable {
    var index: String
    var link: String
    
    init(_ index: String) {
        self.index = index
        self.link = AppConfig().imageUrlStart + index
    }
}

