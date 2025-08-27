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
        var INT_VALUE: Int? = nil
        var ARRAY_VALUE: [String]? = nil
    }
    
    @Test("can encode true bool value")
    func canEncodeTrueBoolValue() async throws {
        // GIVEN
        let data = TestStruct(BOOL_VALUE: true)
        let encoder = DotEnvEncoder()
        
        // WHEN
        let result = try encoder.encode(data)
        
        // THEN
        let expectedResult = "BOOL_VALUE=true"
        #expect(result == expectedResult)
    }
    
    @Test("can encode false bool value")
    func canEncodeFalseBoolValue() async throws {
        // GIVEN
        let data = TestStruct(BOOL_VALUE: false)
        let encoder = DotEnvEncoder()
        
        // WHEN
        let result = try encoder.encode(data)
        
        // THEN
        let expectedResult = "BOOL_VALUE="
        #expect(result == expectedResult)
    }
    
    @Test("can encode simple string value")
    func canEncodeSimpleStringValue() async throws {
        // GIVEN
        let data = TestStruct(STRING_VALUE: "hello")
        let encoder = DotEnvEncoder()
        
        // WHEN
        let result = try encoder.encode(data)
        
        // THEN
        let expectedResult = "STRING_VALUE=hello"
        #expect(result == expectedResult)
    }
    
    @Test("can encode string value with spaces")
    func canEncodeStringValueWithSpaces() async throws {
        // GIVEN
        let data = TestStruct(STRING_VALUE: "hello world")
        let encoder = DotEnvEncoder()
        
        // WHEN
        let result = try encoder.encode(data)
        
        // THEN
        let expectedResult = "STRING_VALUE=\"hello world\""
        #expect(result == expectedResult)
    }
    
    @Test("can encode string value with double quotes")
    func canEncodeStringValueWithDoubleQuotes() async throws {
        // GIVEN
        let data = TestStruct(STRING_VALUE: "hello \"john\"")
        let encoder = DotEnvEncoder()
        
        // WHEN
        let result = try encoder.encode(data)
        
        // THEN
        let expectedResult = "STRING_VALUE=\"hello \\\"john\\\"\""
        #expect(result == expectedResult)
    }
    
    @Test("can encode int value")
    func canEncodeIntValue() async throws {
        // GIVEN
        let data = TestStruct(INT_VALUE: 42)
        let encoder = DotEnvEncoder()
        
        // WHEN
        let result = try encoder.encode(data)
        
        // THEN
        let expectedResult = "INT_VALUE=42"
        #expect(result == expectedResult)
    }
    
    @Test("can encode array values")
    func canEncodeArrayValues() async throws {
        // GIVEN
        let data = TestStruct(ARRAY_VALUE: ["one", "two", "three"])
        let encoder = DotEnvEncoder()
        
        // WHEN
        let result = try encoder.encode(data)
        
        // THEN
        let expectedResult = "ARRAY_VALUE=one two three"
        #expect(result == expectedResult)
    }
    
    @Test("can encode array values containing spaces")
    func canEncodeArrayValuesContainingSpaces() async throws {
        // GIVEN
        let data = TestStruct(ARRAY_VALUE: ["one apple", "two apples", "three apples"])
        let encoder = DotEnvEncoder()
        
        // WHEN
        let result = try encoder.encode(data)
        
        // THEN
        let expectedResult = "ARRAY_VALUE=\"one apple\" \"two apples\" \"three apples\""
        #expect(result == expectedResult)
    }
    
    @Test("can encode specific array values joined by comma")
    func canEncodeSpecificArrayValuesJoinedByComma() async throws {
        // GIVEN
        let data = TestStruct(ARRAY_VALUE: ["one", "two", "three"])
        let encoder = DotEnvEncoder(arraySeparators: ["ARRAY_VALUE": ","])
        
        // WHEN
        let result = try encoder.encode(data)
        
        // THEN
        let expectedResult = "ARRAY_VALUE=one,two,three"
        #expect(result == expectedResult)
    }
}
