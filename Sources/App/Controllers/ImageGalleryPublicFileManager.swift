//
//  File.swift
//  
//
//  Created by Ben Schultz on 4/6/23.
//

import Foundation
import Vapor

class ImageGalleryPublicFileManager {
    static let ac = AppConfig()
    static let galPath = DirectoryConfiguration.detect().publicDirectory + "/" + ac.imageGalPublicSubfolder + "/"
    static let fileManager = FileManager.default    
    static var galUrl: URL {
        URL(fileURLWithPath: galPath)
    }
    
    static func getGalleries() throws -> [Gallery] {
        var workingList = [Gallery]()
        let dirCandidates = try fileManager.contentsOfDirectory(atPath: galPath)
        for dirC in dirCandidates {
            let u = galUrl.appendingPathComponent(dirC)
            let v = try u.resourceValues(forKeys: [.isDirectoryKey])
            if v.isDirectory! {
                try workingList.append(loadGallery(atPath: dirC, includeDetails: false))
            }
        }
        return workingList
    }
    
    private static func loadGallery(atPath path: String, includeDetails: Bool) throws -> Gallery{
        let (id, name) = try idFromFolderName(atPath: path)
        let galleryPath = galPath + path
        let normalImagePath = galleryPath  + "/data/normal.jpg"
        let redImagePath = galleryPath + "/data/red.jpg"
        var galDesc: String?
        var images = [GalleryImage]()
        if includeDetails {
            galDesc = try fileContents(atPath: galleryPath + "/gal-desc.txt")
        }
        return Gallery(id: id, name: name, path: galleryPath, html: galDesc, normalImagePath: normalImagePath, redImagePath: redImagePath, images: images)
    }
    
    private static func idFromFolderName(atPath path: String) throws -> (Int, String) {
        guard let idEndIndex = path.firstIndex(of: " ")
        else {
            throw Abort(.internalServerError, reason: "no space in gallery directory name: \(path)")
        }
        let lastSlashIndex = path.lastIndex(of: "/") ?? path.startIndex
        let idStartIndex = path.index(after: lastSlashIndex)
        let idStr = String(path[idStartIndex...idEndIndex]).trimmingCharacters(in: .whitespaces)
        guard let id = Int(idStr) else {
            throw Abort(.internalServerError, reason: "gallery directory name starts with non-integer value \(idStr)")
        }
        let nameStartIndex = path.index(idEndIndex, offsetBy: 3)
        let name = String(path[nameStartIndex...])
        return (id, name)
    }
    
    private static func fileContents(atPath path: String) throws -> String {
        try String(contentsOfFile: path)
    }
    
}
