//
//  File.swift
//  
//
//  Created by Ben Schultz on 1/13/22.
//

import Foundation

extension String {
    func prependZerosToMake (size: Int) -> String {
        String((String(repeating: "0", count: size) + self).suffix(size))
    }
    
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        dateFormatter.timeZone = .current
        if let date = dateFormatter.date(from: self) {
            return date
        }
        return nil
    }
    
    func dowToNumber() -> Int {
        if self == "Monday" { return 2 }
        else if self == "Tuesday" { return 3 }
        else if self == "Wednesday" { return 4 }
        else if self == "Thursday" { return 5 }
        else if self == "Friday" { return 6 }
        else if self == "Saturday" { return 7 }
        return 1
    }
    
}
