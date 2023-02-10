//
//  ResponseConstructor.swift
//  APC Swift
//
//  Created by 砚渤 on 2023/2/10.
//

import Foundation
import Kitura

func responseConstructor(_ response: RouterResponse, _ next: () -> Void, _ request: RouterRequest, _ targetContent: inout String, _ remoteContent: String, _ runtimeConfiguration: RuntimeParams) {
    
    //    Actual replacing
    for segment in runtimeConfiguration.replacing {
        if let newString = readSection(string: remoteContent, section: segment) {
            targetContent = replaceSection(string: targetContent, newString: newString, section: segment)
        } else {
            print("Section [\(segment)] not found")
        }
    }
    
    //    Append MANAGED info
    var managedText: String {
        return "#!MANAGED-CONFIG \(request.originalURL)\n"
    }
    targetContent = managedText + targetContent
}
