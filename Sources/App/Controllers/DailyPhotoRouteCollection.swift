//
//  File.swift
//  
//
//  Created by Ben Schultz on 4/6/23.
//

import Foundation
import Vapor

struct DailyPhotoRouteCollection: RouteCollection {
    
    let ac: AppConfig
    
    var dpRouteGroup: String {
        let startIndex = ac.dailyphotoUrlPath.firstIndex(of: "/")!
        return String(ac.dailyphotoUrlPath[startIndex...])
    }
    
    init(_ ac: AppConfig) {
        self.ac = ac
    }
    
    func boot(routes: RoutesBuilder) throws {
        let dp = routes.grouped("dp")

        dp.get { req -> Response in
            if let year = try DailyPhotoPublicFileManager.latestYear() {
                let imgIndex = try DailyPhotoPublicFileManager.lastImageDay(forYear: year)
                return try await getView(req, year: imgIndex.yyyy, month: imgIndex.mm, day: imgIndex.dd).encodeResponse(for: req)
            }
            return try await "It works!".encodeResponse(for: req)
        }

        dp.get(":year", ":month", ":day") { req -> View in
            let year = req.parameters.get("year")!
            let month = req.parameters.get("month")!
            let day = req.parameters.get("day")!
            return try await getView(req, year: year, month: month, day: day)
        }
        
        dp.get(":year") { req -> View in
            let year = req.parameters.get("year")!
            let imgIndex = try DailyPhotoPublicFileManager.firstImageDay(forYear: year)
            return try await getView(req, year: imgIndex.yyyy, month: imgIndex.mm, day: imgIndex.dd)
        }
        
        dp.get("currentImg") { req async throws -> Response in
            let year =  DailyPhotoPublicFileManager.currentYear
            let imgIndex = try DailyPhotoPublicFileManager.firstImageDay(forYear: year)
            let link = ac.dpImageUrlStart + imgIndex.imgSrc
            return try await link.encodeResponse(for: req)
        }
        
    }
    
    fileprivate func getView(_ req: Request, year: String, month: String, day: String) async throws -> View {
        guard let yearInt = Int(year),
              let monthInt = Int(month),
              let dayInt = Int(day)
        else {
            throw Abort(.badRequest, reason:"year, month, or day input not provided or provided with invalid format.")
        }
        
        let entry = try DailyPhotoEntry(year: year, month: month, day: day)
        let years = try DailyPhotoPublicFileManager.yearIndexes(forYear: year)
        let yearTable = try YearTable(year: yearInt, selectedMonth: monthInt, selectedDay: dayInt)
        let lc = LocalContext(entry: entry, years: years, dayLinks: yearTable)
        return try await req.view.render("index", lc)
    }

    fileprivate struct LocalContext: Content, Codable {
        var entry: DailyPhotoEntry
        var years: [FolderContext]
        var dayLinks: YearTable
    }
}
