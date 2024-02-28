//
//  HandleRequest.swift
//  APC Swift
//
//  Created by 砚渤 on 2023/2/10.
//

import Foundation
import Kitura


func beginRequest(_ targetContent: inout String, _ response: RouterResponse, _ request: RouterRequest, _ next: () -> Void, _ data: Data?, _ remoteResp: URLResponse?, _ runtimeConfiguration: RuntimeConfiguration, _ error: Error?) {
    if configuration.secret != nil && configuration.secret != runtimeConfiguration.secret {
        handleSecretError(response: response, next: next)
        return
    }
    if data == nil {
        handleServerError(response: response, next: next)
        return
    }
    guard let httpResponse = remoteResp as? HTTPURLResponse,
          (200...299).contains(httpResponse.statusCode) else {
        handleServerError(response: response, next: next)
        return
    }
    let remoteContent = String(data: data!, encoding: .utf8)!
    
//    Make headers
    response.headers["Content-Type"] = httpResponse.value(forHTTPHeaderField: "Content-Type")
    response.headers["Content-Disposition"] = "attachment; filename=Aggregated.conf"
    
//    Make target final
    responseConstructor(response, next, request, &targetContent, remoteContent, runtimeConfiguration)
    response.send(targetContent)
    next()
}

func handleSecretError(response: RouterResponse, next: () -> Void) {
    response.send("bad secret")
    response.statusCode = .badRequest
    next()
}

func handleServerError(response: RouterResponse, next: () -> Void) {
    response.send("fetched nothing")
    response.statusCode = .badGateway
    next()
}
