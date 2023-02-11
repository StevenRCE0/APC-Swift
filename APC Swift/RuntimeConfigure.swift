//
//  RuntimeConfigure.swift
//  APC Swift
//
//  Created by 砚渤 on 2023/2/10.
//

import Foundation
import Kitura


struct RuntimeParams {
    let file: URL?
    let replacing: [String]
    static let replacingKeyword = "replacing"
    static let sslKeywords = ["sslon": true, "ssloff": false]
    static let pathKeywords = ["PORT", "URL", "FILE", "HTTPS"]
}

enum RuntimeConfigError: Error {
    case FileNotInEnv(name: String)
}

func parseRuntimeConfiguration(request: RouterRequest) throws -> RuntimeParams {
    var file = configuration.defaultFilePath
    let replacing: [String] = request.queryParametersMultiValues[RuntimeParams.replacingKeyword] ?? []
    let fileEnvKey = request.routes.first
    
    if fileEnvKey != nil {
        if let filePathString = getEnvironmentVariable(fileEnvKey) {
            file = URL(fileURLWithPath: filePathString)
        } else {
            throw RuntimeConfigError.FileNotInEnv(name: fileEnvKey!)
        }
    }
    return .init(file: file, replacing: replacing)
}

func checkKeywords(request: RouterRequest) -> [String] {
    var conflicts: [String] = []
    for route in request.routes {
        if RuntimeParams.pathKeywords.contains(route) {
            conflicts.append(route)
        }
    }
    return conflicts
}
