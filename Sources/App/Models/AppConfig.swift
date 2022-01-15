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
    var publicSubfolder: String
    
    var imageUrlStart: String {
        rootUrl + "/" + publicSubfolder + "/"
    }
    
    init() {
    
        do {
            let path = DirectoryConfiguration.detect().resourcesDirectory
            let url = URL(fileURLWithPath: path).appendingPathComponent("Config.json")
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode(Self.self, from: data)
            
            self.listenOnPort = decoded.listenOnPort
            self.rootUrl = decoded.rootUrl
            self.publicSubfolder = decoded.publicSubfolder
        }
        catch {
            print ("Could not initialize app from Config.json.  Exiting now. \n \(error)")
            exit(0)
        }        
    }
}
