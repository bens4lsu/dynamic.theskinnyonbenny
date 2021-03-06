import Vapor
import Leaf
import Foundation



func routes(_ app: Application) throws {

    app.get { req -> Response in
        if let year = try PublicFileManager.latestYear() {
            let imgIndex = try PublicFileManager.firstImageDay(forYear: year)
            return try await getView(req, year: imgIndex.yyyy, month: imgIndex.mm, day: imgIndex.dd).encodeResponse(for: req)
        }
        return try await "It works!".encodeResponse(for: req)
    }

    app.get(":year", ":month", ":day") { req -> View in
        let year = req.parameters.get("year")!
        let month = req.parameters.get("month")!
        let day = req.parameters.get("day")!
        return try await getView(req, year: year, month: month, day: day)
    }
    
    app.get(":year") { req -> View in
        let year = req.parameters.get("year")!
        let imgIndex = try PublicFileManager.firstImageDay(forYear: year)
        return try await getView(req, year: imgIndex.yyyy, month: imgIndex.mm, day: imgIndex.dd)
    }
    
    app.get("currentImg") { req async throws -> Response in
        let year =  PublicFileManager.currentYear
        let imgIndex = try PublicFileManager.firstImageDay(forYear: year)
        return try await imgIndex.context.link.encodeResponse(for: req)
    }
}

func getView(_ req: Request, year: String, month: String, day: String) async throws -> View {
    let entry = try Entry(year: year, month: month, day: day)
    let years = try PublicFileManager.yearIndexes(forYear: year)
    let yearTable = try YearTable(year: Int(year) ?? -1)
    let lc = LocalContext(entry: entry, years: years, dayLinks: yearTable)
    print(lc)
    return try await req.view.render("index", lc)
}

fileprivate struct LocalContext: Content, Codable {
    var entry: Entry
    var years: [FolderContext]
    var dayLinks: YearTable
}


