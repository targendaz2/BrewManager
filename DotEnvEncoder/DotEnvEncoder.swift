//
//  DotEnvEncoder.swift
//  DotEnvEncoder
//
//  Created by David Rosenberg on 8/26/25.
//

import Foundation

public class DotEnvEncoder: Encoder {
    public var codingPath: [any CodingKey] = []
    public var userInfo: [CodingUserInfoKey: Any] = [:]
    var keyValues: [String: String] = [:]
    
    public init() {}
    
    public func encode<T: Encodable>(_ value: T) throws -> String {
        try value.encode(to: self)
        return keyValues.map { "\($0.key)=\($0.value)" }.joined(separator: "\n")
    }
    
    func addPair(_ key: String, _ value: String) {
        self.keyValues[key] = value
    }
    
    public func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key>
    where Key: CodingKey {
        KeyedEncodingContainer(DotEnvKeyedEncodingContainer(encoder: self))
    }
    
    public func unkeyedContainer() -> any UnkeyedEncodingContainer {
        DotEnvUnkeyedEncodingContainer(encoder: self)
    }
    
    public func singleValueContainer() -> any SingleValueEncodingContainer {
        DotEnvSingleValueEncodingContainer(encoder: self)
    }
}

// MARK: - keyed encoding container
private struct DotEnvKeyedEncodingContainer<Key: CodingKey>: KeyedEncodingContainerProtocol {
    typealias Key = Key
    
    let encoder: DotEnvEncoder
    var codingPath: [any CodingKey] { encoder.codingPath }
    
    func escape(_ value: String) -> String {
        if value.rangeOfCharacter(from: .whitespaces) != nil {
            let escaped = value.replacingOccurrences(of: "\"", with: "\\\"")
            return "\"\(escaped)\""
        }
        return value
    }
    
    func encodeNil(forKey key: Key) throws {
        // exclude nil values from dotenv files
        return
    }
    
    mutating func encode<T>(_ value: T, forKey key: Key) throws where T: Encodable {
        switch value {
            case let value as Bool:
                encoder.addPair(key.stringValue, value ? "true" : "")
            case let value as String:
                encoder.addPair(key.stringValue, escape(value))
            case let value as Double:
                encoder.addPair(key.stringValue, String(value))
            case let value as Float:
                encoder.addPair(key.stringValue, String(value))
            case let value as Int:
                encoder.addPair(key.stringValue, String(value))
            case let value as Int8:
                encoder.addPair(key.stringValue, String(value))
            case let value as Int16:
                encoder.addPair(key.stringValue, String(value))
            case let value as Int32:
                encoder.addPair(key.stringValue, String(value))
            case let value as Int64:
                encoder.addPair(key.stringValue, String(value))
            case let value as Int128:
                encoder.addPair(key.stringValue, String(value))
            case let value as UInt:
                encoder.addPair(key.stringValue, String(value))
            case let value as UInt8:
                encoder.addPair(key.stringValue, String(value))
            case let value as UInt16:
                encoder.addPair(key.stringValue, String(value))
            case let value as UInt32:
                encoder.addPair(key.stringValue, String(value))
            case let value as UInt64:
                encoder.addPair(key.stringValue, String(value))
            case let value as UInt128:
                encoder.addPair(key.stringValue, String(value))
            default:
                try value.encode(to: encoder)
        }
    }
    
    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key)
    -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey
    {
        encoder.container(keyedBy: keyType)
    }
    
    func nestedUnkeyedContainer(forKey key: Key) -> any UnkeyedEncodingContainer {
        return encoder.unkeyedContainer()
    }
    
    func superEncoder() -> any Encoder {
        encoder
    }
    
    func superEncoder(forKey key: Key) -> any Encoder {
        encoder
    }
    
}

// MARK: - unkeyed encoding container
private struct DotEnvUnkeyedEncodingContainer: UnkeyedEncodingContainer {
    let encoder: DotEnvEncoder
    var codingPath: [any CodingKey] { encoder.codingPath }
    let count = 0
    
    func encodeNil() throws {
        // exclude nil values from dotenv files
        return
    }
    
    mutating func encode<T: Encodable>(_ value: T) throws {
        let key = codingPath.map { $0.stringValue }.joined(separator: "_")
        var values: [String] = []
        
        switch value {
            case let value as Bool:
                values.append(value ? "true" : "")
            case let value as String:
                values.append(value)
            case let value as Double:
                values.append(String(value))
            case let value as Float:
                values.append(String(value))
            case let value as Int:
                values.append(String(value))
            case let value as Int8:
                values.append(String(value))
            case let value as Int16:
                values.append(String(value))
            case let value as Int32:
                values.append(String(value))
            case let value as Int64:
                values.append(String(value))
            case let value as Int128:
                values.append(String(value))
            case let value as UInt:
                values.append(String(value))
            case let value as UInt8:
                values.append(String(value))
            case let value as UInt16:
                values.append(String(value))
            case let value as UInt32:
                values.append(String(value))
            case let value as UInt64:
                values.append(String(value))
            case let value as UInt128:
                values.append(String(value))
            default:
                try value.encode(to: encoder)
        }
        
        if values.isEmpty {
            return
        }
        
        encoder.addPair(key, values.joined(separator: " "))
    }
    
    mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type)
    -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey
    {
        encoder.container(keyedBy: keyType)
    }
    
    mutating func nestedUnkeyedContainer() -> any UnkeyedEncodingContainer {
        self
    }
    
    mutating func superEncoder() -> any Encoder {
        encoder
    }
}

// MARK: - single value encoding container
private struct DotEnvSingleValueEncodingContainer: SingleValueEncodingContainer {
    let encoder: DotEnvEncoder
    var codingPath: [any CodingKey] { encoder.codingPath }
    
    func encodeNil() throws {
        // exclude nil values from dotenv files
        return
    }
    
    mutating func encode<T: Encodable>(_ value: T) throws {
        let key = codingPath.map { $0.stringValue }.joined(separator: "_")
        
        switch value {
            case let value as Bool:
                encoder.addPair(key, value ? "true" : "")
            case let value as String:
                encoder.addPair(key, value)
            case let value as Double:
                encoder.addPair(key, String(value))
            case let value as Float:
                encoder.addPair(key, String(value))
            case let value as Int:
                encoder.addPair(key, String(value))
            case let value as Int8:
                encoder.addPair(key, String(value))
            case let value as Int16:
                encoder.addPair(key, String(value))
            case let value as Int32:
                encoder.addPair(key, String(value))
            case let value as Int64:
                encoder.addPair(key, String(value))
            case let value as Int128:
                encoder.addPair(key, String(value))
            case let value as UInt:
                encoder.addPair(key, String(value))
            case let value as UInt8:
                encoder.addPair(key, String(value))
            case let value as UInt16:
                encoder.addPair(key, String(value))
            case let value as UInt32:
                encoder.addPair(key, String(value))
            case let value as UInt64:
                encoder.addPair(key, String(value))
            case let value as UInt128:
                encoder.addPair(key, String(value))
            default:
                try value.encode(to: encoder)
        }
    }
}
