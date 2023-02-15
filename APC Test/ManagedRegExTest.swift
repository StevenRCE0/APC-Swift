//
//  ManagedRegEx.swift
//  APC Test
//
//  Created by 砚渤 on 2023/2/11.
//

import XCTest

final class ManagedRegEx: XCTestCase {
    let url = "http://foo.bar:123?query=param"
    let goodResult = "#!MANAGED-CONFIG https://foo.bar:123?query=param\n"
    let mockConfiguration = RuntimeConfiguration(file: nil, replacing: [], sslOverride: true)
    
    func testManagedRegEx() throws {
        XCTAssert(getManagedText(url, mockConfiguration) == goodResult)
    }
}
