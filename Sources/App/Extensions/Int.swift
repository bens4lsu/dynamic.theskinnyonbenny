//
//  File.swift
//  
//
//  Created by Ben Schultz on 5/15/23.
//

import Foundation

extension Int {
    var isEven: Bool {
        self % 2 == 0
    }
    
    var isOdd: Bool {
        !self.isEven
    }
}
