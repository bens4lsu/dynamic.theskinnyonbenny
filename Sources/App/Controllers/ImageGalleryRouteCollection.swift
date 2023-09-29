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
        
        gal.get { req -> Response in
            return req.redirect(to: "https://theskinnyonbenny.com/pgHome")
        }
        
        gal.get(":id") { req -> Response in
            guard let parameter = req.parameters.get("id"),
                  let id = Int(parameter)
            else {
                throw Abort (.badRequest, reason: "Gallery ID in request was not numeric.")
            }
            return req.redirect(to: "https://theskinnyonbenny.com/gal/\(id)")
        }

    }
}
