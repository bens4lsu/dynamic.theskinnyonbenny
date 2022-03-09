import Foundation
import Leaf
import Vapor
import LeafKit

// configures your application
public func configure(_ app: Application) throws {
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    let appConfig = PublicFileManager.ac
    app.http.server.configuration.port = appConfig.listenOnPort
    app.views.use(.leaf)
        
    // register routes
    try routes(app)
}
