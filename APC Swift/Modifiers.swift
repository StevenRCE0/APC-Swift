//
//  Modifiers.swift
//  APC Swift
//
//  Created by 砚渤 on 2024/3/21.
//

import Foundation

let removeKey = "remove"
let insertKey = "insert"
let replaceKey = "replace"

struct ModifiersResult: Equatable {
    var toRemove: [String] = []
    var toInsert: [String] = []
    var toReplace: [String] = []
}

func readModifiers(string: String, section: String) -> ModifiersResult {
    let matchPattern = "\\s*=\\s*(.*)"
    
    let removePattern = try! NSRegularExpression(pattern: removeKey + matchPattern, options: .caseInsensitive)
    let insertPattern = try! NSRegularExpression(pattern: insertKey + matchPattern, options: .caseInsensitive)
    let replacePattern = try! NSRegularExpression(pattern: replaceKey + matchPattern, options: .caseInsensitive)
    
    var result = ModifiersResult()
    
    func sequenceMatcher(line: String, pattern: NSRegularExpression) -> [String] {
        if let match = pattern.matches(in: line, range: .init(location: 0, length: line.count)).first {
            if let range = Range(match.range(at: 1), in: line) {
                return String(line[range]).split(separator: ",").map({String($0).trimmingCharacters(in: .whitespacesAndNewlines)})
            }
        }
        return []
    }
    
    let method: LinearMethod = { sequence, start, end in
        for line in sequence[start..<end] {
            result.toRemove.append(contentsOf: sequenceMatcher(line: String(line), pattern: removePattern))
            result.toInsert.append(contentsOf: sequenceMatcher(line: String(line), pattern: insertPattern))
            result.toReplace.append(contentsOf: sequenceMatcher(line: String(line), pattern: replacePattern))
        }
        return ""
    }
    
    _ = sectionLinearProcessor(string: string, section: section, method: method)
    
    return result
}
