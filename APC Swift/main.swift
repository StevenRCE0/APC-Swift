//
//  main.swift
//  APC Swift
//
//  Created by 砚渤 on 2023/2/9.
//

import Foundation
import Kitura

let router = Router()
let configuration = loadConfiguration()

router.get("*") { request, response, next in
    //    Check reserved keywords
    let conflicts = checkKeywords(request: request)
    if !conflicts.isEmpty {
        response.send("Reserved: " + conflicts.joined(separator: ", "))
        next()
        return
    }
    
    var targetContent = ""
    
//    Parse and response
    do {
        let runtimeConfiguration = try parseRuntimeConfiguration(request: request)
        parseLocalFile(&targetContent, runtimeConfiguration, response, next)
        
        let task = URLSession.shared.dataTask(with: configuration.url) { data, remoteResp, error in
            beginRequest(&targetContent, response, request, next, data, remoteResp, runtimeConfiguration, error)
        }
        
        task.resume()
    } catch RuntimeConfigError.FileNotInEnv(let name) {
        response.send("File not in environment values: \(name)")
        next()
        return
    } catch {
        response.send("Unknow error\n" + error.localizedDescription)
        next()
        return
    }
    
    
}

Kitura.addHTTPServer(onPort: configuration.port, with: router)
Kitura.run()
