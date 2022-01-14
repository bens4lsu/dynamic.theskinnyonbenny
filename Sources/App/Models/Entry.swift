//
//  File.swift
//  
//
//  Created by Ben Schultz on 1/13/22.
//

import Foundation
import Vapor
import Leaf

struct Entry: Content, Codable {
    
    var entryText: String
    var entryImgPath: String
    var isValid: Bool
    var date: Date?
    
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
        self.date = String(textFileName.prefix(8)).toDate()
    }
    
//    var context: EntryContext {
//        
//    }
}

struct EntryContext: Content, Codable {
    var entryText: String
    var entryImgPath: String
    var entryDate: Date
    var folderIndexes: [String]
    var imageIndexValues: [String: ImageIndex]
}

/*
 
 leaf can handle this:
 
 #if(contains(planets, "Earth")):
     Earth is here!
 #else:
     Earth is not in this array.
 #endif
 
 DICTIONARY IS OK
 */


