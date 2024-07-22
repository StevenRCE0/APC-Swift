//
//  ResponseConstructor.swift
//  APC Swift
//
//  Created by 砚渤 on 2023/2/10.
//

import Foundation
import Kitura

func responseConstructor(_ response: RouterResponse, _ next: () -> Void, _ request: RouterRequest, _ targetContent: inout String, _ remoteContent: String, _ runtimeConfiguration: RuntimeConfiguration) {
    
    //    Remove comments in remoteContent
    let remoteContent = removeComments(remoteContent)
    
    //    Actual replacing
    for segment in runtimeConfiguration.replacing {
//        let modifiers = readModifiers(string: targetContent, section: segment)
        if let newString = readSection(string: remoteContent, section: segment) {
//            applyModifiers(newString: newString, targetContent: &targetContent, modifiers: modifiers)
            targetContent = replaceSection(string: targetContent, newString: newString, section: segment)
        } else {
            print("Section [\(segment)] not found")
        }
    }
    
    //    Append MANAGED info
    targetContent = getManagedText(request.originalURL, runtimeConfiguration) + targetContent
}

func getManagedText(_ url: String, _ runtimeConfiguration: RuntimeConfiguration) -> String {
    let protocolPattern = "^http(s?)"
    var urlString = url
    
    if runtimeConfiguration.sslOverride != nil {
        urlString = urlString.replacingOccurrences(of: protocolPattern, with: runtimeConfiguration.sslOverride! ? "https" : "http", options: .regularExpression)
    }
    
    return "#!MANAGED-CONFIG \(urlString)\n"
}

func removeComments(_ content: String) -> String {
    let lines = content.split(omittingEmptySubsequences: false, whereSeparator: \.isNewline)
    var result = ""
    for line in lines {
        if !line.trimmingCharacters(in: .whitespaces).hasPrefix("#") {
            result += line + "\n"
        }
    }
    return result
}
