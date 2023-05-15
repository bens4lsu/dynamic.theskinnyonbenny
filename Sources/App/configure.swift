import Foundation
import Leaf
import Vapor
import LeafKit

// configures your application
public func configure(_ app: Application) throws {
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    let appConfig = AppConfig()
    app.http.server.configuration.port = appConfig.listenOnPort
    app.views.use(.leaf)
        
    
    //let x = try ImageGalleryPublicFileManager.getGalleries() //(atPath: "175 - Europe 2022 pt 2 - Coastal Croatia")
    //print(x)
    // register routes
    try routes(app, appConfig)
    
    // load image index on startup
    let _ = try DailyPhotoPublicFileManager.lazyIndex
    let _ = try ImageGalleryPublicFileManager.loadImages(forGallery: "176 - Eurpoe 2022 pt 1 - Slovenia Croatia Montenegro")
}
