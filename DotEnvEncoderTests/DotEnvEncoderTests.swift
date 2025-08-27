//
//  DotEnvEncoderTests.swift
//  DotEnvEncoderTests
//
//  Created by David Rosenberg on 8/27/25.
//

import Testing

@testable import DotEnvEncoder

struct DotEnvEncoderTests {
    struct TestStruct: Codable {
        var BOOL_VALUE: Bool? = nil
        var STRING_VALUE: String? = nil
    }
    
    @Test("can encode true bool value")
    func canEncodeTrueBoolValue() async throws {
        // GIVEN
        let data = TestStruct(BOOL_VALUE: true)
        let encoder = DotEnvEncoder()
        
        // WHEN
        let result = try encoder.encode(data)
        let expectedResult = "BOOL_VALUE=true"
        
        // THEN
        #expect(result == expectedResult)
    }
    
    @Test("can encode false bool value")
    func canEncodeFalseBoolValue() async throws {
        // GIVEN
        let data = TestStruct(BOOL_VALUE: false)
        let encoder = DotEnvEncoder()
        
        // WHEN
        let result = try encoder.encode(data)
        let expectedResult = "BOOL_VALUE="
        
        // THEN
        #expect(result == expectedResult)
    }
    
    @Test("can encode simple string value")
    func canEncodeSimpleStringValue() async throws {
        // GIVEN
        let data = TestStruct(STRING_VALUE: "hello")
        let encoder = DotEnvEncoder()
        
        // WHEN
        let result = try encoder.encode(data)
        let expectedResult = "STRING_VALUE=hello"
        
        // THEN
        #expect(result == expectedResult)
    }
    
    @Test("can encode string value with spaces")
    func canEncodeStringValueWithSpaces() async throws {
        // GIVEN
        let data = TestStruct(STRING_VALUE: "hello world")
        let encoder = DotEnvEncoder()
        
        // WHEN
        let result = try encoder.encode(data)
        let expectedResult = "STRING_VALUE=\"hello world\""
        
        // THEN
        #expect(result == expectedResult)
    }
    
    @Test("can encode string value with double quotes")
    func canEncodeStringValueWithDoubleQuotes() async throws {
        // GIVEN
        let data = TestStruct(STRING_VALUE: "hello \"john\"")
        let encoder = DotEnvEncoder()
        
        // WHEN
        let result = try encoder.encode(data)
        let expectedResult = "STRING_VALUE=\"hello \\\"john\\\"\""
        
        // THEN
        #expect(result == expectedResult)
    }
}
