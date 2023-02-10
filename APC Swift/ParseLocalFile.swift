//
//  ParseLocalFile.swift
//  APC Swift
//
//  Created by 砚渤 on 2023/2/10.
//

import Foundation
import Kitura

func parseLocalFile(_ targetContent: inout String, _ runtimeConfiguration: RuntimeParams, _ response: RouterResponse, _ next: () -> Void) {
    if let localURL = runtimeConfiguration.file ?? configuration.defaultFilePath {
        do {
            targetContent = String(data: try Data(contentsOf: localURL), encoding: .utf8) ?? ""
        } catch {
            response.send(error.localizedDescription)
            next()
            return
        }
    } else {
        response.send("No file provided")
        next()
        return
    }
}
