//
//  Regex.swift
//  glacInit
//
//  Created by Abdullahi Mahamed on 9/27/17.
//  Copyright © 2017 Parshav Chauhan. All rights reserved.
//
import Foundation

class Regex {
    var internalExpression: NSRegularExpression?
    var pattern: String
    
    init(_ pattern: String) {
        self.pattern = pattern
        
        do {
            self.internalExpression = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
        } catch {
            print("Error regex bad")
        }

    }
    
    func test(input: String) -> Bool {
        let matches = self.internalExpression?.matches(in: input, options: [], range: NSMakeRange(0, input.count))
        return matches!.count > 0
    }
}
