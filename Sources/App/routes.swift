import Vapor
import Leaf
import Foundation



func routes(_ app: Application, _ ac: AppConfig) throws {
    try? app.register(collection: DailyPhotoRouteCollection(ac))
    try? app.register(collection: ImageGalleryRouteCollection(ac))
}


