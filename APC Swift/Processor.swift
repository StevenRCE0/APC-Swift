//
//  Processor.swift
//  APC Swift
//
//  Created by 砚渤 on 2023/2/9.
//

import Foundation

typealias LinearMethod = ([String.SubSequence], Int, Int) -> String

func readSection(string: String, section: String) -> String? {
    let method: LinearMethod = { sequence, start, end in
        sequence[start..<end].joined(separator: "\n")
    }
    return sectionLinearProcessor(string: string, section: section, method: method)
}

func replaceSection(string: String, newString: String, section: String) -> String {
    let method: LinearMethod = { sequence, start, end in
        let firstSegment: [String] = sequence[0..<start].compactMap({String($0)})
        let endSegment: [String] = sequence[end...].compactMap({String($0)})
        let joined = firstSegment + [newString] + endSegment
        return joined.joined(separator: "\n")
    }
    return sectionLinearProcessor(string: string, section: section, method: method) ?? ""
}

func sectionLinearProcessor(string: String, section: String, method: LinearMethod) -> String? {
    let lines = string.split(omittingEmptySubsequences: false, whereSeparator: \.isNewline)
    let nextSectionPattern = "^\\s*\\[.+\\]\\s*$"
    let regEx = try? NSRegularExpression(pattern: nextSectionPattern, options: .caseInsensitive)
    var i = 0
    while i < lines.count {
        if lines[i].trimmingCharacters(in: .whitespaces) == "[\(section)]" {
            i += 1
            let start = i
            var condition: Bool {
                if i >= lines.count {
                    return false
                }
                if !(regEx?.matches(in: String(lines[i]), range: .init(location: 0, length: lines[i].count)).isEmpty ?? false) {
                    return false
                }
                return true
            }
            while condition {
                i += 1
            }
            let end = i
            return method(lines, start, end)
        }
        i += 1
    }
    return nil
}


func applyModifiers(newString: String, targetContent: inout String, modifiers: ModifiersResult) {
    if modifiers.toRemove.isEmpty && modifiers.toReplace.isEmpty && modifiers.toInsert.isEmpty {
        targetContent = newString
    } else {
        var modifierLines: [String] = []
        newString.enumerateLines { line, _ in
            for toRemove in modifiers.toRemove {
                if line.contains(toRemove) {
                    return
                }
                modifierLines.append(line)
            }
        }
        targetContent = modifierLines.joined(separator: "\n")
    }
}
