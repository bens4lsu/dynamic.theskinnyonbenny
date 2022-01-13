import Foundation
//import Leaf
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    let appConfig = AppConfig()
    app.http.server.configuration.port = appConfig.listenOnPort
    app.views.use(.leaf)
    // register routes
    try routes(app)
}
