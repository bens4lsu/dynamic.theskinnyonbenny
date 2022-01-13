import Vapor

func routes(_ app: Application) throws {

    app.get { req in
        return "It works!"
    }

    app.get(":year", ":month", ":day") { req -> View in
        let year = req.parameters.get("year")!
        let month = req.parameters.get("month")!
        let day = req.parameters.get("day")!
        let entry = Entry(year: year, month: month, day: day)
        let bigIndex = try PublicFileManager.folderIndexes()
        print(bigIndex)
        return try await req.view.render("index", entry)
    }
}
