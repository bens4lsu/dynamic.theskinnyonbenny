//
//  File.swift
//  
//
//  Created by Ben Schultz on 4/6/23.
//

import Foundation
import Vapor
import Leaf

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
        // set which column the gallery should show up on on the main page
        for i in 0..<workingList.count {
            if (workingList.count.isEven && workingList[i].id.isEven) || (workingList.count.isOdd && workingList[i].id.isOdd) {
                workingList[i].column = .left
            }
            else {
                workingList[i].column = .right
            }
        }
        
        workingList.sort(by: { $0.id > $1.id })
        return workingList
    }
    
    private static func loadGallery(atPath path: String, includeDetails: Bool) throws -> Gallery{
        let (id, name) = try idFromFolderName(atPath: path)
        let galleryPath = ac.rootUrl + "/" + ac.imageGalPublicSubfolder + "/" + String(id)
        let normalImagePath = ac.rootUrl + "/" + ac.imageGalPublicSubfolder + "/" + path + "/data/normal.jpg"
        let redImagePath = ac.rootUrl + "/" + ac.imageGalPublicSubfolder + "/" + path + "/data/red.jpg"
        var galDesc: String?
        var images = [GalleryImage]()
        if includeDetails {
            galDesc = try fileContents(atPath: galleryPath + "/gal-desc.txt")
            images = try loadImages(forGallery: path)
        }
        return Gallery(id: id, name: name, path: galleryPath, html: galDesc, normalImagePath: normalImagePath, redImagePath: redImagePath, images: images)
    }
    
    private static func idFromFolderName(atPath path: String) throws -> (Int, String) {
        guard let idEndIndex = path.firstIndex(of: " ")
        else {
            throw Abort(.internalServerError, reason: "no space in gallery directory name: \(path)")
        }
        let idStartIndex = path.lastIndex(of: "/") ?? path.startIndex
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
    
    public static func loadImages(forGallery path: String) throws -> [GalleryImage] {
        let folder = galPath + path
        let files = try fileManager.contentsOfDirectory(atPath: galPath + "/" + path)
        let captions = try captions(forGallery: path)
        var images = [GalleryImage]()
        for file in files {
            if file.prefix(5) != "_thb_" && file.suffix(4) == ".jpg" {
                let imagePath = file
                let thumbnailPath = "_thb_" + imagePath
                
                let i = GalleryImage(lineNum: 0, imagePath:"" , thumbnailpath: "", caption: "")
            }
        }
        
        return [];
    }
    
    private static func captions (forGallery path: String) throws -> [String: String] {
        let captionFile = galPath + path + "/pic-desc.txt"
        guard let captionContents = try? fileContents(atPath: captionFile) else {
            return [:]
        }
        let lines = captionContents.split(whereSeparator: \.isNewline)
        let dict = lines.reduce(into: [String: String]()) { result, line in
            let split = line.split(separator: "|")
            if split.count > 1 {
                result[String(split[0])] = String(split[1])
            }
            else {
                result[String(split[0])] = ""
            }
        }
        return dict
    }
    
    
}
