//
//  File.swift
//  
//
//  Created by Ben Schultz on 5/12/23.
//

import Foundation
import Vapor

struct ImageGalleryRouteCollection: RouteCollection {
    
    let ac: AppConfig
    
    init(_ ac: AppConfig) {
        self.ac = ac
    }
    
    func boot(routes: RoutesBuilder) throws {
        let gal = routes.grouped("gal")
        
        gal.get { req -> View in
            let galleries = try ImageGalleryPublicFileManager.getGalleries()
            return try await req.view.render("galleries", ["galleries" : galleries])
        }
    }
}
