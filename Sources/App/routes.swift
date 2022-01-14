import Vapor
import Leaf



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
}

func getView(_ req: Request, year: String, month: String, day: String) async throws -> View {
    let entry = Entry(year: year, month: month, day: day)
    let years = try PublicFileManager.yearIndexes(forYear: year)
    let dayLinks = try PublicFileManager.imageIndexes(forYear: year).map { $0.context }
    let lc = LocalContext(entry: entry, years: years, dayLinks: dayLinks)
    return try await req.view.render("index", lc)
}

