//
//  Configure.swift
//  APC Swift
//
//  Created by 砚渤 on 2023/2/9.
//

import Foundation
import DotEnv

let dotEnv = DotEnv(withFile: ".env")

struct Configuration {
    let port: Int
    let SSL: Bool
    let url: URL
    let defaultFilePath: URL?
}

func getEnvironmentVariable(_ unsafeName: String? = nil) -> String? {
    if unsafeName == nil {
        return nil
    }
    let name = unsafeName!
    
    var envString: String? {
        if let string = getenv(name) {
            return String(utf8String: string)
        }
        return nil
    }
    let value = dotEnv.get(name) ?? envString
    if value == nil {
        return nil
    }
    
    return value
}

func getEnvironmentVariableInt(_ unsafeName: String? = nil) -> Int? {
    if unsafeName == nil {
        return nil
    }
    let name = unsafeName!
    
    var envString: Int? {
        let envValue = getenv(name)
        if envValue == nil {
            return nil
        }
        if let string = String(utf8String: envValue!) {
            return Int(string)
        }
        return nil
    }
    let value = dotEnv.getAsInt(name) ?? envString
    if value == nil {
        return nil
    }
    
    return value
}

func loadConfiguration() -> Configuration {
    var defaultFilePath: URL? {
        if let defaultFileString = getEnvironmentVariable("FILE") {
            return URL(filePath: defaultFileString)
        }
        return nil
    }
    return .init(
        port: getEnvironmentVariableInt("PORT") ?? 8080,
        SSL: getEnvironmentVariable("HTTPS") == "true",
        url: URL(string: getEnvironmentVariable("URL")!)!,
        defaultFilePath: defaultFilePath
    )
}
