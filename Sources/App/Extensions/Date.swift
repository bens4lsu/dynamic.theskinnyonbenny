//
//  File.swift
//  
//
//  Created by Ben Schultz on 5/11/23.
//

import Foundation

extension Date {
    
    var yyyyMMddString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.string(from: self)
    }
    
}
