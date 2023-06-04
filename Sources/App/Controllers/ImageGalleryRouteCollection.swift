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
        
        gal.get(":id") { req -> View in
            return try await req.view.render("gallery", loadGallery(req))
        }
        
        gal.get("data", ":id") { req -> Response in
            try await loadGallery(req).encodeResponse(for: req)
        }
    }
    
    private func loadGallery(_ req: Request) async throws -> Gallery {
        guard let parameter = req.parameters.get("id"),
              let id = Int(parameter)
        else {
            throw Abort (.badRequest, reason: "Gallery ID in request was not numeric.")
        }
        let gallery = try ImageGalleryPublicFileManager.getGallery(id)
        return gallery
    }
}
