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
    
    static let path = DirectoryConfiguration.detect().publicDirectory + "/content/"
    static let fileManager = FileManager.default
    static var url: URL {
        URL(fileURLWithPath: path)
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
    
    static func folderIndexes() throws -> [FolderIndex] {
        var dirList = [FolderIndex]()
        let dirCandidates = try fileManager.contentsOfDirectory(atPath: path)
        for dirC in dirCandidates {
            let u = url.appendingPathComponent(dirC)
            let v = try u.resourceValues(forKeys: [.isDirectoryKey])
            if v.isDirectory! {
                let imageIndexes = try addImageIndexes(dirC)
                dirList.append(FolderIndex(year: dirC, mmdd: imageIndexes))
            }
        }
        return dirList
    }
    
    private static func addImageIndexes(_ subfolder: String) throws -> [ImageIndex] {
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
        return imageList
    }
}
