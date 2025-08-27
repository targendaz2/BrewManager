//
//  DotEnvEncoderTests.swift
//  DotEnvEncoderTests
//
//  Created by David Rosenberg on 8/27/25.
//

import Testing

@testable import DotEnvEncoder

struct DotEnvEncoderTests {
    @Test("can encode true bool value")
    func canEncodeTrueBoolValue() async throws {
        // GIVEN
        struct TestStruct: Codable {
            let MY_VALUE: Bool
        }
        let data = TestStruct(MY_VALUE: true)
        let encoder = DotEnvEncoder()
        
        // WHEN
        let result = try encoder.encode(data)
        let expectedResult = "MY_VALUE=true"
        
        // THEN
        #expect(result == expectedResult)
    }
    
    @Test("can encode false bool value")
    func canEncodeFalseBoolValue() async throws {
        // GIVEN
        struct TestStruct: Codable {
            let MY_VALUE: Bool
        }
        let data = TestStruct(MY_VALUE: false)
        let encoder = DotEnvEncoder()
        
        // WHEN
        let result = try encoder.encode(data)
        let expectedResult = "MY_VALUE="
        
        // THEN
        #expect(result == expectedResult)
    }
}
