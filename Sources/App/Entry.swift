//
//  File.swift
//  
//
//  Created by Ben Schultz on 1/13/22.
//

import Foundation
import Vapor
import Leaf


extension String {
    func prependZerosToMake (size: Int) -> String {
        String((String(repeating: "0", count: size) + self).suffix(size))
    }
}

final class PublicFileManager {
    static let path = DirectoryConfiguration.detect().publicDirectory
    
    static func textFileContents (_ fileName: String) -> String {
        let url = URL(fileURLWithPath: path).appendingPathComponent(fileName)
        guard let data = try? Data(contentsOf: url) else {
            return ""
        }
        return String(data: data, encoding: .utf8) ?? ""
    }
}

final class Entry: Content {
    
    var entryText: String
    var entryImgPath: String
    var isValid: Bool
    
    init (year: String, month: String, day: String) {
        
        guard (Int(year) ?? -1) >= 2005 &&
                (Int(year) ?? -1) < 2200 &&
                (Int(month) ?? -1) >= 1 &&
                (Int(month) ?? -1) <= 12 &&
                (Int(day) ?? -1) >= 1 &&
                (Int(day) ?? -1) <= 31
        else {
            self.entryText = ""
            self.entryImgPath = ""
            self.isValid = false
            return
        }
        
        let year_ = year.prependZerosToMake(size: 4)
        let month_ = month.prependZerosToMake(size: 2)
        let day_ = day.prependZerosToMake(size: 2)
        
        let textFileName = "\(year_)/\(year_)\(month_)\(day_).txt"
        self.entryText = PublicFileManager.textFileContents(textFileName)
        self.entryImgPath = "\(year_)/\(year_)\(month_)\(day_).jpg"
        self.isValid = true
    }
}


