//
//  File.swift
//  
//
//  Created by Ben Schultz on 1/13/22.
//

import Foundation
import Vapor
import Leaf

struct Entry: Content {
    
    var entryText: String
    var entryImgPath: String
    var isValid: Bool
    
    init (year: String, month: String, day: String) {
        guard let textFileName = PublicFileManager.fileNameFor(year: year, month: month, day: day, type: .text),
              let imgPath = PublicFileManager.fileNameFor(year: year, month: month, day: day, type: .image)
        else {
            self.entryText = ""
            self.entryImgPath = ""
            self.isValid = false
            return
        }
        self.entryText = PublicFileManager.textFileContents(textFileName)
        self.entryImgPath = imgPath
        self.isValid = true
    }
}




