//
//  File.swift
//  
//
//  Created by Ben Schultz on 1/13/22.
//

import Foundation
import Vapor

struct FolderIndex {
    var year: String
    var mmdd: [ImageIndex]
}

struct ImageIndex {
    var yyyy: String
    var mm: String
    var dd: String
}
