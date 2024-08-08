//
//  RC4.swift
//  GHCryptoKit
//
//  Created by sy on 2024/7/23.
//
//  RC4 流密码一种 对称的 RC4可以使用40位到256位的可变长度密钥

public struct RC4 {

    static func encryptData(_ data: Data, withKey key: Data) -> Data {
        return processData(data: data, key: key)
    }

    static func decryptData(_ data: Data, withKey key: Data) -> Data {
        return processData(data: data, key: key)
    }

    static func processData(data: Data, key: Data) -> Data {
        var s = [UInt8](repeating: 0, count: 256)
        var temp: UInt8
        // 初始化S-box
        for i in 0..<256 {
            s[i] = UInt8(i)
        }
        // 根据密钥初始化S-box
        var i = 0
        var j = 0
        let keyLength = key.count
        for _ in 0..<256 {
            j = (j + Int(s[i]) + Int(key[key.startIndex.advanced(by: i % keyLength)])) % 256
            temp = s[i]
            s[i] = s[j]
            s[j] = temp
            i += 1
        }
        // 生成密钥流并异或
        var output = Data(count: data.count)
        i = 0
        j = 0        
        data.withUnsafeBytes { dataBytes in
            output.withUnsafeMutableBytes { outputBytes in
                // 确保 dataBytes 和 outputBytes 是 UnsafeBufferPointer 类型
                let bytes = dataBytes.bindMemory(to: UInt8.self)
                let mutableBytes = outputBytes.bindMemory(to: UInt8.self)
                // 遍历数据并执行你的处理逻辑
                for k in 0..<data.count {
                    i = (i + 1) % 256
                    j = (j + Int(s[i])) % 256
                    // s数组密钥流
                    let keyStreamByte = s[(Int(s[i]) + Int(s[j])) % 256]
                    // 使用异或操作处理字节
                    mutableBytes[k] ^= bytes[k] ^ keyStreamByte
                }
            }
        }
        return output
    }
}
