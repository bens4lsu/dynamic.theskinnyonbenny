//
//  File.swift
//  
//
//  Created by Ben Schultz on 1/13/22.
//

import Foundation
import Vapor
import Leaf

struct DailyPhotoEntry: Content, Codable {
    
    var entryText: String
    var entryImgPath: String
    var isValid: Bool
    var date: Date?
    var linkPrevious: String?
    var linkNext: String?
    
    var ac: AppConfig {
        DailyPhotoPublicFileManager.ac
    }
    
    init (year: String, month: String, day: String) throws {
        self.init()
        guard let textFileName = DailyPhotoPublicFileManager.fileNameFor(year: year, month: month, day: day, type: .text),
              let imgPath = DailyPhotoPublicFileManager.fileNameFor(year: year, month: month, day: day, type: .image)
        else {
            return
        }
        self.entryText = DailyPhotoPublicFileManager.textFileContents(textFileName)
        let fullPath = ac.dpImageUrlStart + imgPath
        self.entryImgPath = fullPath
        self.isValid = true
        self.date = String(textFileName.suffix(12).prefix(8)).toDate()
        self.linkPrevious = try DailyPhotoPublicFileManager.imageBefore(ImageIndex(yyyy: year, mm: month, dd: day))?.context.link
        self.linkNext = try DailyPhotoPublicFileManager.imageAfter(ImageIndex(yyyy: year, mm: month, dd: day))?.context.link
    }
    
    init() {
        self.entryText = ""
        self.entryImgPath = ""
        self.isValid = false
        return
    }
    
}
