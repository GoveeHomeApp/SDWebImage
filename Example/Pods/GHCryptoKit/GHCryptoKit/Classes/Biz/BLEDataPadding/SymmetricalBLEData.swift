//
//  SymmetricalBLEData.swift
//  GHCryptoKit
//
//  Created by sy on 2024/7/23.
//

import Foundation
import CommonCrypto

extension EncryptProtocol {
    
    func gh_decryptDataArray(dataArray: [Data], _ key: Data? = nil, _ position: Int? = nil) -> [Data] {
        var defaultKey: Data = SymmetricalBiz.defaultKeyData()
        if let configKey = key { defaultKey = configKey }
        return dataArray.map {
            let defaultPosition = $0.count - ($0.count%16)
            return SymmetricalBiz.gh_decryptData(data: $0, key: defaultKey, position: defaultPosition)
        }
    }
    
    func gh_encryptDataArray(dataArray: [Data], _ key: Data? = nil, _ position: Int? = nil) -> [Data] {
        var defaultKey: Data = SymmetricalBiz.defaultKeyData()
        if let configKey = key { defaultKey = configKey }
        return dataArray.map {
            let defaultPosition = $0.count - ($0.count%16)
            return SymmetricalBiz.gh_encryptData(data: $0, key: defaultKey, position: defaultPosition)
        }
    }
    
    func gh_decryptData(data: Data, _ key: Data? = nil, _ position: Int? = nil) -> Data {
        var defaultKey: Data = SymmetricalBiz.defaultKeyData()
        if let configKey = key { defaultKey = configKey }
        let defaultPosition = data.count - (data.count%16)
        return SymmetricalBiz.gh_decryptData(data: data, key: defaultKey, position: defaultPosition)
    }
    
    func gh_encryptData(data: Data, _ key: Data? = nil, _ position: Int? = nil) -> Data {
        var defaultKey: Data = SymmetricalBiz.defaultKeyData()
        let defaultPosition = data.count - (data.count%16)
        if let configKey = key { defaultKey = configKey }
        return SymmetricalBiz.gh_encryptData(data: data, key: defaultKey, position: defaultPosition)
    }
    
}

class SymmetricalBiz {

    static func gh_encryptData(data: Data, key: Data, position: Int) -> Data {
        let length = data.count
        if length < position {
            return Data()
        }
        let data1 = data.subdata(in: 0..<position)
        let data2 = data.subdata(in: position..<length)
        let aesData = AESBiz.aes128ECBEncrypt(data: data1, key: key) ?? Data()
        let rc4Data = RC4.encryptData(data2, withKey: key)
        let resultData = aesData + rc4Data
        return resultData
    }

    static func gh_decryptData(data: Data, key: Data, position: Int) -> Data {
        let length = data.count
        if length < position {
            return Data()
        }
        let data1 = data.subdata(in: 0..<position)
        let data2 = data.subdata(in: position..<length)
        let aesData = AESBiz.aes128ECBDecrypt(data: data1, key: key) ?? Data()
        let rc4Data = RC4.decryptData(data2, withKey: key)
        let resultData = aesData + rc4Data
        return resultData
    }

    public static func defaultKeyData() -> Data {
        return Data(defaultKeyArray())
    }
    
    public static func defaultKeyArray() -> [UInt8] {
        let keyBytes: [UInt8] = [0x4D, 0x61, 0x6B, 0x69, 0x6E, 0x67, 0x4C, 0x69, 0x66, 0x65, 0x53, 0x6D, 0x61, 0x72, 0x74, 0x65]
        return keyBytes
    }
    
    static func dataToHex(_ data: Data) -> String {
        return data.map { String(format: "%02hhx ", $0) }.joined()
    }
}

