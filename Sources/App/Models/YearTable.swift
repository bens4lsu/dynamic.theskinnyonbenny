//
//  File.swift
//  
//
//  Created by Ben Schultz on 1/17/22.
//

import Foundation

enum DayCell: Codable {
    case empty(isLast: Bool)
    case numbered(DayCellContent)
    
    var context: DayCellContext {
        switch self {
        case .empty(let isLast):
            return DayCellContext(displayed: false, number: nil, index: nil, rowBreakAfter: false, isLast: isLast, isSelected: false)
        case.numbered(let dayCellContent):
            return DayCellContext(displayed: true, number: dayCellContent.number, index: dayCellContent.index, rowBreakAfter: dayCellContent.rowBreakAfter, isLast: dayCellContent.isLast, link:dayCellContent.link, isSelected: dayCellContent.isSelected )
        }
    }
}

struct DayCellContent: Codable {
    var number: Int
    var index: ImageIndex?
    var rowBreakAfter: Bool
    var isLast: Bool
    
    var link: String? {
        guard let index = self.index else {
            return nil
        }
        return AppConfig().dpLinkUrlStart + index.yyyy + "/" + index.mm + "/" + index.dd
    }
    
    var isSelected: Bool = false
}

struct DayCellContext: Codable {
    var displayed: Bool
    var number: Int?
    var index: ImageIndex?
    var rowBreakAfter: Bool
    var isLast: Bool
    var link: String?
    var isSelected: Bool
}

struct MonthTable: Codable {
    
    static func makeDate(year: Int, month: Int, day: Int) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let components = DateComponents(year: year, month: month, day: day)
        return calendar.date(from: components)!
    }
    
    var cells: [DayCellContext]
    var monthName: String
    var breakAfter: Bool
    var isLast: Bool
    
    init (month: Int, year: Int, selectedMonth: Int, selectedDay: Int) throws {
        
        //  cells gets initialized with 42 items, one for each day spot
        //  on the month table.
        
        let dt = Self.makeDate(year: year, month: month, day: 1)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        self.monthName = formatter.string(from: dt)
        
        self.breakAfter = month == 3 || month == 6 || month == 9
        self.isLast = month == 12
        
        formatter.dateFormat = "EEEE"
        let firstDOW = formatter.string(from: dt)
        let cellForFirst = firstDOW.dowToNumber()
        var dateComponent = DateComponents()
        dateComponent.month = 1
        dateComponent.day = -1
        let lastDayDt = Calendar.current.date(byAdding: dateComponent, to: dt)!
        formatter.dateFormat = "d"
        let lastDayInt = Int(formatter.string(from: lastDayDt))
        var table = [DayCellContext]()
        var currDay: Int? = nil
        for i in 1...42 {
            let isLast = i == 42
            if currDay == nil && cellForFirst == i {
                currDay = 1
            }
            else if currDay ?? -1 > lastDayInt! {
                currDay = nil
            }
            if let day = currDay {
                let idx = try DailyPhotoPublicFileManager.lazyIndex[String(year)]?.filter {
                    let yyyy = String(year).prependZerosToMake(size: 4)
                    let mm = String(month).prependZerosToMake(size: 2)
                    let dd = String(day).prependZerosToMake(size: 2)
                    return yyyy == $0.yyyy && mm == $0.mm && dd == $0.dd
                }.first
                let rowbreak = i % 7 == 0
                let isSelected = month == selectedMonth && day == selectedDay
                let dayCellContent = DayCellContent(number: day, index: idx, rowBreakAfter: rowbreak, isLast: isLast, isSelected: isSelected)
                table.append(DayCell.numbered(dayCellContent).context)
            }
            else {
                var dc = DayCell.empty(isLast: isLast).context
                if i % 7 == 0 {
                    dc.rowBreakAfter = true
                }
                table.append(dc)
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
    
    init(year: Int, selectedMonth: Int, selectedDay: Int) throws {
        var tableData = [MonthTable]()
        for i in 1...12 {
            try tableData.append(MonthTable(month: i, year: year, selectedMonth: selectedMonth, selectedDay: selectedDay))
        }
        self.tableData = tableData
    }
}
