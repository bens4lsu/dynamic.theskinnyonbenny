//
//  File.swift
//  
//
//  Created by Ben Schultz on 1/13/22.
//

import Foundation
import Vapor

final class PublicFileManager {
    enum FileType: String {
        case text = ".txt"
        case image = ".jpg"
    }
    
    
    static let path = DirectoryConfiguration.detect().publicDirectory + "/" + AppConfig().publicSubfolder + "/"
    static let fileManager = FileManager.default
        
    static var url: URL {
        URL(fileURLWithPath: path)
    }
    
    static var currentYear: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: Date())
    }
    
    static var bigIndex = [String: [ImageIndex]]()
    static var lazyIndex: [String: [ImageIndex]] {
        get throws {
            if bigIndex.isEmpty {
                bigIndex = try folderIndexes()
            }
            return bigIndex
        }
    }
    
    static var rootUrl: String?
    static var lazyRootUrl: String {
        if let url = rootUrl {
            return url
        }
        rootUrl = AppConfig().rootUrl
        return rootUrl!
    }

    static func textFileContents (_ fileName: String) -> String {
        let url = url.appendingPathComponent(fileName)
        guard let data = try? Data(contentsOf: url) else {
            return ""
        }
        return String(data: data, encoding: .utf8) ?? ""
    }
    
    static func fileNameFor(year: String, month: String, day: String, type: PublicFileManager.FileType) -> String? {
        guard (Int(year) ?? -1) >= 2005 &&
                (Int(year) ?? -1) < 2200 &&
                (Int(month) ?? -1) >= 1 &&
                (Int(month) ?? -1) <= 12 &&
                (Int(day) ?? -1) >= 1 &&
                (Int(day) ?? -1) <= 31
        else {
            return nil
        }
        
        let year_ = year.prependZerosToMake(size: 4)
        let month_ = month.prependZerosToMake(size: 2)
        let day_ = day.prependZerosToMake(size: 2)
        
        return year_ + "/" + year_ + month_ + day_ + type.rawValue
    }
    
    static func imageIndexes(forYear year: String) throws -> [ImageIndex] {
        if year == currentYear {    // no cached indexes for current year
            return try imageIndexes(year)
        }
        return try lazyIndex[year] ?? []
    }
    
    static func yearIndexes(forYear year: String) throws -> [FolderContext] {
        try lazyIndex.map { FolderContext($0.key) }.filter{ $0.index != year }
    }
    
    static func firstImageDay(forYear year: String) throws -> ImageIndex {
        try lazyIndex[year]?.first ?? ImageIndex(yyyy: "0000", mm: "00", dd: "00")
    }
    
    static func latestYear() throws -> String? {
        try Array(lazyIndex.keys).sorted().last
    }
    
    private static func folderIndexes() throws -> [String: [ImageIndex]] {
        var dirList = [String: [ImageIndex]]()
        let dirCandidates = try fileManager.contentsOfDirectory(atPath: path)
        for dirC in dirCandidates {
            let u = url.appendingPathComponent(dirC)
            let v = try u.resourceValues(forKeys: [.isDirectoryKey])
            if v.isDirectory! {
                dirList[dirC] = try imageIndexes(dirC)
            }
        }
        return dirList
    }
  
    private static func imageIndexes(_ subfolder: String) throws -> [ImageIndex] {
        var imageList = [ImageIndex]()
        let subfolderPath = path + subfolder
        let imageCandidates = try fileManager.contentsOfDirectory(atPath: subfolderPath)
        for file in imageCandidates {
            if file.suffix(4) == ".jpg" {
                let mm = String(file.prefix(6).suffix(2))
                let dd = String(file.prefix(8).suffix(2))
                let yyyy = String(file.prefix(4))
                let imgIndex = ImageIndex(yyyy: yyyy, mm: mm, dd: dd)
                imageList.append(imgIndex)
            }
        }
        return imageList.sorted()
    }
    
}
