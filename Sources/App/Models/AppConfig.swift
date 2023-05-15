//
//  File.swift
//  
//
//  Created by Ben Schultz on 1/13/22.
//


import Foundation
import Vapor

final class AppConfig: Codable {
    var listenOnPort: Int
    var rootUrl: String
    var dailyphotoUrlPath: String
    var dailyPhotoPublicSubfolder: String
    var imageGalPublicSubfolder: String
    var serverPath: String
    var serverPathGal: String
    
    var dpImageUrlStart: String {
        rootUrl + "/" + dailyPhotoPublicSubfolder + "/"
    }
    
    var dpLinkUrlStart: String {
        rootUrl + dailyphotoUrlPath + "/"
    }
    
    init() {
    
        do {
            let path = DirectoryConfiguration.detect().resourcesDirectory
            let url = URL(fileURLWithPath: path).appendingPathComponent("Config.json")
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode(Self.self, from: data)
            
            self.listenOnPort = decoded.listenOnPort
            self.rootUrl = decoded.rootUrl
            self.dailyphotoUrlPath = decoded.dailyphotoUrlPath
            self.dailyPhotoPublicSubfolder = decoded.dailyPhotoPublicSubfolder
            self.imageGalPublicSubfolder = decoded.imageGalPublicSubfolder
            self.serverPath = decoded.serverPath
            self.serverPathGal = decoded.serverPathGal
        }
        catch {
            print ("Could not initialize app from Config.json.  Exiting now. \n \(error)")
            exit(0)
        }        
    }
}
