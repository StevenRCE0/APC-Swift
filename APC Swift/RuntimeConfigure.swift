//
//  RuntimeConfigure.swift
//  APC Swift
//
//  Created by 砚渤 on 2023/2/10.
//

import Foundation
import Kitura


struct RuntimeConfiguration {
    let file: URL?
    let replacing: [String]
    let sslOverride: Bool?
    let secret: String?
    static let replacingKeyword = "replace"
    static let sslKeyword = "ssl"
    static let secretKeyword = "secret"
    static let pathKeywords = ["PORT", "URL", "FILE", "HTTPS"]
}

enum RuntimeConfigError: Error {
    case FileNotInEnv(name: String)
}

func parseRuntimeConfiguration(request: RouterRequest) throws -> RuntimeConfiguration {
    var file = configuration.defaultFilePath
    let replacing: [String] = request.queryParametersMultiValues[RuntimeConfiguration.replacingKeyword] ?? []
    var sslOverride: Bool? {
        if let string = request.queryParameters[RuntimeConfiguration.sslKeyword] {
            return string == "true" || string == "1"
        }
        return nil
    }
    let fileEnvKey = request.routes.first
    let secret = request.queryParameters[RuntimeConfiguration.secretKeyword]
    
    if fileEnvKey != nil {
        if let filePathString = getEnvironmentVariable(fileEnvKey) {
            file = URL(fileURLWithPath: filePathString)
        } else {
            throw RuntimeConfigError.FileNotInEnv(name: fileEnvKey!)
        }
    }
    return .init(file: file, replacing: replacing, sslOverride: sslOverride, secret: secret)
}

func checkKeywords(request: RouterRequest) -> [String] {
    var conflicts: [String] = []
    for route in request.routes {
        if RuntimeConfiguration.pathKeywords.contains(route) {
            conflicts.append(route)
        }
    }
    return conflicts
}
