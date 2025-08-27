//
//  DotEnvEncoder.swift
//  DotEnvEncoder
//
//  Created by David Rosenberg on 8/26/25.
//

import Foundation

private func escape(_ value: String) -> String {
    if value.rangeOfCharacter(from: .whitespaces) != nil {
        let escaped = value.replacingOccurrences(of: "\"", with: "\\\"")
        return "\"\(escaped)\""
    }
    return value
}

public class DotEnvEncoder: Encoder {
    public var codingPath: [any CodingKey] = []
    public var userInfo: [CodingUserInfoKey: Any] = [:]
    
    var keyValues: [String: String] = [:]
    var defaultArraySeparator: String
    var arraySeparators: [String : String]
    
    public init(
        defaultArraySeparator: String = " ",
        arraySeparators: [String : String] = [:]
    ) {
        self.defaultArraySeparator = defaultArraySeparator
        self.arraySeparators = arraySeparators
    }
    
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
private class DotEnvKeyedEncodingContainer<Key: CodingKey>: KeyedEncodingContainerProtocol {
    typealias Key = Key
    
    let encoder: DotEnvEncoder
    var codingPath: [any CodingKey] { encoder.codingPath }
    
    init(encoder: DotEnvEncoder) {
        self.encoder = encoder
    }
    
    func encodeNil(forKey key: Key) throws {
        // exclude nil values from dotenv files
        return
    }
    
    func encode<T>(_ value: T, forKey key: Key) throws where T: Encodable {
        encoder.codingPath.append(key)
        defer { encoder.codingPath.removeLast() }
        
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
        encoder.codingPath.append(key)
        defer { encoder.codingPath.removeLast() }
        return encoder.container(keyedBy: keyType)
    }
    
    func nestedUnkeyedContainer(forKey key: Key) -> any UnkeyedEncodingContainer {
        encoder.codingPath.append(key)
        defer { encoder.codingPath.removeLast() }
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
private class DotEnvUnkeyedEncodingContainer: UnkeyedEncodingContainer {
    let encoder: DotEnvEncoder
    var codingPath: [any CodingKey] { encoder.codingPath }
    let count = 0
    
    var values: [String] = []
    
    init(encoder: DotEnvEncoder) {
        self.encoder = encoder
    }
    
    deinit {
        if values.isEmpty {
            return
        }
        
        let key = codingPath.map { $0.stringValue }.joined(separator: "_")
        
        let separator: String
        if encoder.arraySeparators.keys.contains(key) {
            separator = encoder.arraySeparators[key]!
        } else {
            separator = encoder.defaultArraySeparator
        }
        
        encoder.addPair(key, values.joined(separator: separator))
    }
    
    func encodeNil() throws {
        // exclude nil values from dotenv files
        return
    }
    
    func encode<T: Encodable>(_ value: T) throws {
        switch value {
            case let value as Bool:
                values.append(value ? "true" : "")
            case let value as String:
                values.append(escape(value))
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
    }
    
    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type)
    -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey
    {
        encoder.container(keyedBy: keyType)
    }
    
    func nestedUnkeyedContainer() -> any UnkeyedEncodingContainer {
        self
    }
    
    func superEncoder() -> any Encoder {
        encoder
    }
}

// MARK: - single value encoding container
private class DotEnvSingleValueEncodingContainer: SingleValueEncodingContainer {
    let encoder: DotEnvEncoder
    var codingPath: [any CodingKey] { encoder.codingPath }
    
    init(encoder: DotEnvEncoder) {
        self.encoder = encoder
    }
    
    func encodeNil() throws {
        // exclude nil values from dotenv files
        return
    }
    
    func encode<T: Encodable>(_ value: T) throws {
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
