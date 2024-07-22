//
//  ModifiersTest.swift
//  APC Swift
//
//  Created by 砚渤 on 2024/3/21.
//

import XCTest

final class ModifiersTest: XCTestCase {
    
    static let toTest = """
    # blah
    
    [blah]
    remove = uu, vv, ww
    """
    
    static let goodResult = ModifiersResult(toRemove: ["uu", "vv", "ww"])
    func testModifiers() throws {
        let runResult = readModifiers(string: ModifiersTest.toTest, section: "blah")
        XCTAssert(runResult == ModifiersTest.goodResult)
    }
}

final class ModificationTest: XCTestCase {
    
    let localText = """
sth

[Proxy]
remove = old1, old2

[Proxy Group]
local
group

sth
"""
    let remoteText = """
sth

[Proxy]
foo=bar
bar=old1
bar=foo
foo=old2

[Proxy Group]
remote
group

sth
"""
    let replacedCheck = """
sth

[Proxy]
foo=bar
bar=foo
[Proxy Group]
remote
group

sth
"""
    
    func testModification() throws {
        let modifiers = readModifiers(string: localText, section: "Proxy")
        var read = readSection(string: remoteText, section: "Proxy")!
        var context = localText
        applyModifiers(newString: read, targetContent: &context, modifiers: modifiers)
        print(context)
        let replaced = replaceSection(string: localText, newString: read, section: "Proxy")
        XCTAssert(replaced == replacedCheck, "Modification error")
    }
}
