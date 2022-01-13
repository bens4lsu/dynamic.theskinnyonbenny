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
}
