/*************************************************************************
 *
 * UNIVERSITY OF NEBRASKA AT OMAHA CONFIDENTIAL
 * __________________
 *
 *  [2018] - [2019] University of Nebraska at Omaha
 *  All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains
 * the property of University of Nebraska at Omaha and its suppliers,
 * if any.  The intellectual and technical concepts contained
 * herein are proprietary to University of Nebraska at Omaha
 * and its suppliers and may be covered by U.S. and Foreign Patents,
 * patents in process, and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from University of Nebraska at Omaha.
 *
 * Code written by Lyle Reinholz and Abdullahi Mahamed.
 */
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
