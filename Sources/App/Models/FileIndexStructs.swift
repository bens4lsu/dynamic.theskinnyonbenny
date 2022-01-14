//
//  File.swift
//  
//
//  Created by Ben Schultz on 1/13/22.
//

import Foundation
import Vapor


struct ImageIndex: Codable {
    var yyyy: String
    var mm: String
    var dd: String
    
    var context: ImageIndexContext {
        let index = mm + dd
        let link = "/" + yyyy + "/" + mm + "/" + dd
        return ImageIndexContext(index: index, link: link)
    }
}

struct ImageIndexContext: Content, Codable {
    // dict [mmdd: link]
    var index: String
    var link: String
}
