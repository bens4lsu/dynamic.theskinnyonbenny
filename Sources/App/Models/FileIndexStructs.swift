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
        let link = "/" + yyyy + "/" + mm + "/" + dd
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
    // dict [mmdd: link]
    var index: String
    var link: String
}

struct LocalContext: Content, Codable {
    var entry: Entry
    var years: [String]
    var dayLinks: [ImageIndexContext]
}
