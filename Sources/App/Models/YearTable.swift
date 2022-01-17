//
//  File.swift
//  
//
//  Created by Ben Schultz on 1/17/22.
//

import Foundation


struct DayCell: Codable {
    var number: Int
    var index: ImageIndex?
    var rowBreakAfter: Bool
}

struct MonthTable: Codable {
    
    static func makeDate(year: Int, month: Int, day: Int) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let components = DateComponents(year: year, month: month, day: day)
        return calendar.date(from: components)!
    }
    
    var cells: [DayCell?]
    
    init (month: Int, year: Int) throws {
        
        //  cells gets initialized with 42 items, one for each day spot
        //  on the month table.
        
        let dt = Self.makeDate(year: year, month: month, day: 1)
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let firstDOW = formatter.string(from: dt)
        let cellForFirst = firstDOW.dowToNumber()
        var dateComponent = DateComponents()
        dateComponent.month = 1
        dateComponent.day = -1
        let lastDayDt = Calendar.current.date(byAdding: dateComponent, to: dt)!
        formatter.dateFormat = "d"
        let lastDayInt = Int(formatter.string(from: lastDayDt))
        var table = [DayCell?]()
        var currDay: Int? = nil
        for i in 1...42 {
            if currDay == nil && cellForFirst == i {
                currDay = 1
            }
            else if currDay ?? -1 > lastDayInt! {
                currDay = nil
            }
            if let day = currDay {
                let idx = try PublicFileManager.lazyIndex[String(year)]?.filter {
                    let yyyy = String(year).prependZerosToMake(size: 4)
                    let mm = String(month).prependZerosToMake(size: 2)
                    let dd = String(day).prependZerosToMake(size: 2)
                    return yyyy == $0.yyyy && mm == $0.mm && dd == $0.dd
                }.first
                let rowbreak = i % 7 == 0
                table.append(DayCell(number: day, index: idx, rowBreakAfter: rowbreak))
            }
            else {
                table.append(nil)
            }
            if currDay != nil {
                currDay! += 1
            }
        }
        cells = table
    }
}

struct YearTable: Codable {
    var tableData: [MonthTable]
    
    init(year: Int) throws {
        var tableData = [MonthTable]()
        for i in 1...12 {
            try tableData.append(MonthTable(month: i, year: year))
        }
        self.tableData = tableData
    }
}
