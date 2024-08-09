//
//  String+Extension.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 16/07/24.
//

import Foundation

extension String {
    func toFrontCapital() -> String {
        if self.contains("_") {
            // Split the string by underscores and join with spaces while capitalizing each word
            let components = self.split(separator: "_")
            let capitalizedComponents = components.map { $0.capitalized }
            return capitalizedComponents.joined(separator: " ")
        } else {
            // Handle camelCase by inserting spaces before capital letters
            var result = ""
            var previousCharacter: Character?
            
            for char in self {
                if let previousChar = previousCharacter,
                   previousChar.isLowercase && char.isUppercase {
                    result.append(" ")
                }
                result.append(char)
                previousCharacter = char
            }
            
            // Capitalize the first character if it's lowercase
            if let firstChar = result.first, firstChar.isLowercase {
                result.replaceSubrange(result.startIndex...result.startIndex, with: String(firstChar).capitalized)
            }
            
            return result
        }
    }
    
    func truncated(to length: Int, trailing: String = "...") -> String {
        return self.count > length ? self.prefix(length) + trailing : self
    }
}
