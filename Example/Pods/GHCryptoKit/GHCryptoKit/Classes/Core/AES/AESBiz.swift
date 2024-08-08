//
//  AES128ECBBiz.swift
//  GHCryptoKit
//
//  Created by sy on 2024/7/24.
//

import Foundation
import CommonCrypto

public struct AESBiz {
    /**
     而PKCS#7更通用，适用于任何块大小，包括AES（其块大小通常是128位）。由于AES块大小固定为128位（即16字节），所以PKCS#5和PKCS#7在这种情况下是等效的。
     */
    static func aes128_CBC_PKCS5_Encrypt(plainText: [UInt8], key: [UInt8], iv: [UInt8]) -> [UInt8]? {
        var encryptedData: [UInt8] = Array(repeating: 0, count: plainText.count + kCCBlockSizeAES128)
        var numBytesEncrypted: Int = 0
        
        let status = key.withUnsafeBytes { keyBytes in
            iv.withUnsafeBytes { ivBytes in
                plainText.withUnsafeBytes { plainBytes in
                    CCCrypt(CCOperation(kCCEncrypt),
                            CCAlgorithm(kCCAlgorithmAES128),
                            CCOptions(kCCOptionPKCS7Padding),
                            keyBytes.baseAddress, key.count,
                            ivBytes.baseAddress,
                            plainBytes.baseAddress, plainText.count,
                            &encryptedData, encryptedData.count,
                            &numBytesEncrypted)
                }
            }
        }
        
        if status == kCCSuccess {
            encryptedData.removeSubrange(numBytesEncrypted...)
            return encryptedData
        } else {
            print("Encryption failed with error code: \(status)")
            return nil
        }
    }

    /// 解密
    static func aes128_CBC_PKCS5_Decrypt(cipherText: [UInt8], key: [UInt8], iv: [UInt8]) -> [UInt8]? {
        var decryptedData: [UInt8] = Array(repeating: 0, count: cipherText.count + kCCBlockSizeAES128)
        var numBytesDecrypted: Int = 0
        
        let status = key.withUnsafeBytes { keyBytes in
            iv.withUnsafeBytes { ivBytes in
                cipherText.withUnsafeBytes { cipherBytes in
                    CCCrypt(CCOperation(kCCDecrypt),
                            CCAlgorithm(kCCAlgorithmAES128),
                            CCOptions(kCCOptionPKCS7Padding),
                            keyBytes.baseAddress, key.count,
                            ivBytes.baseAddress,
                            cipherBytes.baseAddress, cipherText.count,
                            &decryptedData, decryptedData.count,
                            &numBytesDecrypted)
                }
            }
        }
        
        if status == kCCSuccess {
            decryptedData.removeSubrange(numBytesDecrypted...)
            return decryptedData
        } else {
            print("Decryption failed with error code: \(status)")
            return nil
        }
    }
    
    static func aes128ECBEncrypt(data: Data, key: Data) -> Data? {
        var cryptData = Data(count: data.count + kCCBlockSizeAES128)
        var cryptBytes: Int = 0
        
        let status = CCCrypt(CCOperation(kCCEncrypt),
                             CCAlgorithm(kCCAlgorithmAES128),
                             CCOptions(kCCOptionECBMode),
                             key.withUnsafeBytes { $0.baseAddress! },
                             key.count,
                             nil,
                             data.withUnsafeBytes { $0.baseAddress! },
                             data.count,
                             cryptData.withUnsafeMutableBytes { $0.baseAddress! },
                             cryptData.count,
                             &cryptBytes)
        
        if status == kCCSuccess {
            cryptData.removeSubrange(cryptBytes..<cryptData.count)
            return cryptData
        } else {
            return nil
        }
    }

    static func aes128ECBDecrypt(data: Data, key: Data) -> Data? {
        var cryptData = Data(count: data.count)
        var cryptBytes: Int = 0
        
        let status = CCCrypt(CCOperation(kCCDecrypt),
                             CCAlgorithm(kCCAlgorithmAES128),
                             CCOptions(kCCOptionECBMode),
                             key.withUnsafeBytes { $0.baseAddress! },
                             key.count,
                             nil,
                             data.withUnsafeBytes { $0.baseAddress! },
                             data.count,
                             cryptData.withUnsafeMutableBytes { $0.baseAddress! },
                             cryptData.count,
                             &cryptBytes)
        
        if status == kCCSuccess {
            cryptData.removeSubrange(cryptBytes..<cryptData.count)
            return cryptData
        } else {
            return nil
        }
    }
}
