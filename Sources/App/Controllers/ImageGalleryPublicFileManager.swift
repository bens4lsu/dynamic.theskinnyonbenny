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
    static let galPath = DirectoryConfiguration.detect().publicDirectory + ac.imageGalPublicSubfolder + "/"
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
                try workingList.append(loadGalleryLight(atPath: dirC))
            }
        }
        workingList.sort(by: { $0.id > $1.id })
        
        // set which column the gallery should show up on on the main page
        for i in 0..<workingList.count {
            if (workingList.count.isEven && i.isOdd) || (workingList.count.isOdd && i.isEven) {
                workingList[i].column = .left
            }
            else {
                workingList[i].column = .right
            }
        }
        
        
        return workingList
    }
    
    static func getGallery(_ id: Int) throws -> Gallery {
        guard var gallery = try getGalleries().filter({ $0.id == id }).first else {
            throw Abort (.badRequest, reason: "Request for gallery using invalid id \(id)")
        }
        gallery.images = try galleryDetails(forGallery: gallery.filePath)
        gallery.html = try? fileContents(atPath: "\(gallery.filePath)/gal-desc.txt")
        print(gallery)
        return gallery
    }
    
    // MARK: Private
    
    private static func loadGalleryLight(atPath path: String) throws -> Gallery{
        /*  galPath = /Users/ben/XCode/projects/Vapor Projects/dynamic.theskinnyonbenny/Public//gal/
            
         
         */
        let (id, name) = try idFromFolderName(atPath: path)
        let galleryPath = ac.rootUrl + "/" + ac.imageGalPublicSubfolder + "/" + String(id)
        let imgRootPath = ac.rootUrl + "/" + ac.imageGalPublicSubfolder + "/" + path + "/"
        let normalImagePath = ac.rootUrl + "/" + ac.imageGalPublicSubfolder + "/" + path + "/data/normal.jpg"
        let redImagePath = ac.rootUrl + "/" + ac.imageGalPublicSubfolder + "/" + path + "/data/red.jpg"
        return Gallery(id: id, name: name, path: galleryPath, filePath: galPath + path, imgRootPath: imgRootPath, html: nil, normalImagePath: normalImagePath, redImagePath: redImagePath, images: [])
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
    
    private static func galleryDetails (forGallery path: String) throws -> [GalleryImage] {
        let captionFile = path + "/pic-desc.txt"
        guard let captionContents = try? fileContents(atPath: captionFile) else {
            throw Abort (.internalServerError, reason: "Error reading caption file for \(path)")
        }
        let lines = captionContents.split(whereSeparator: \.isNewline)
        var images = [GalleryImage]()
        for i in 0..<lines.count{
            let line = lines[i]
            let split = line.split(separator: "|")
            var caption = ""
            if split.count > 1 {
                caption = String(split[1])
            }
            let imagePath = String(split[0])
            let thumbnailPath = "_thb_" + String(split[0])
            let galleryImage = GalleryImage(lineNum: i+1, imagePath: imagePath, thumbnailpath: thumbnailPath, caption: caption)
            images.append(galleryImage)
        }
        return images
    }
    
    
}
