//
//  Processor.swift
//  APC Test
//
//  Created by 砚渤 on 2023/2/11.
//

import XCTest

final class ProcessorTest: XCTestCase {
    
    let testText = """
sth

[toReplace]
old
text

[notToReplace]
fine
text

sth
"""
    let toRead = """
[toReplace]
old
text
"""
    let replaceWith = """
new
text
"""
    
    let replacedCheck = """
sth
[toReplace]
new
text
[notToReplace]
fine
text
sth
"""
    
    func testRead() throws {
        let read = readSection(string: testText, section: "toReplace")!
        XCTAssert(read == toRead, "Read error")
    }
    
    func testReplace() throws {
        let replaced = replaceSection(string: testText, newString: replaceWith, section: "toReplace")
        XCTAssert(replaced == replacedCheck, "Replace error")
    }
}
