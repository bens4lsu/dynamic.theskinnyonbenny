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
    var linkPrevious: String?
    var linkNext: String?
    
    var ac: AppConfig {
        PublicFileManager.ac
    }
    
    init (year: String, month: String, day: String) throws {
        self.init()
        guard let textFileName = PublicFileManager.fileNameFor(year: year, month: month, day: day, type: .text),
              let imgPath = PublicFileManager.fileNameFor(year: year, month: month, day: day, type: .image)
        else {
            return
        }
        self.entryText = PublicFileManager.textFileContents(textFileName)
        let fullPath = ac.imageUrlStart + imgPath
        self.entryImgPath = fullPath
        self.isValid = true
        self.date = String(textFileName.suffix(12).prefix(8)).toDate()
        self.linkPrevious = try PublicFileManager.imageBefore(ImageIndex(yyyy: year, mm: month, dd: day))?.context.link
        self.linkNext = try PublicFileManager.imageAfter(ImageIndex(yyyy: year, mm: month, dd: day))?.context.link
    }
    
    init() {
        self.entryText = ""
        self.entryImgPath = ""
        self.isValid = false
        return
    }
    
}
