//
//  RouterRequestExtension.swift
//  APC Swift
//
//  Created by 砚渤 on 2023/2/10.
//

import Foundation
import Kitura

extension RouterRequest {
    var routes: [String] {
        let raw = self.urlURL.pathComponents[1...]
        return raw.compactMap {
            String($0)
        }
    }
}
