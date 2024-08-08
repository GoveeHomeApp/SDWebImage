//
//  Verify.swift
//  GHCryptoKit
//
//  Created by sy on 2024/7/23.
//
//  if #available(iOS 14.0, *) {
//      publicKey = try P256.Signing.PublicKey(derRepresentation: pubData)
//  } else {
//      // Fallback on earlier versions
//      publicKey = try P256.Signing.PublicKey(rawRepresentation: pubData)
//  }
//  publicKey = try P256.Signing.PublicKey(rawRepresentation: pubData)
//  publicKey = try P256.Signing.PublicKey(compactRepresentation: pubData)
//  publicKey = try P256.Signing.PublicKey(x963Representation: pubData)
//  publicKey = try P256.Signing.PublicKey(derRepresentation: pubData)

//  以上是所有256椭圆加密算法支持方式 目前采用的是x963 有固定长度和格式 注意模式以及类型区分

import Foundation
import CryptoKit

public extension EncryptProtocol {
    
    // 256bit
    func verify256(pubKeyBase64: String, signatureBase64: String, msg: String) -> Bool {
        var isValid = false
        guard let pubData = Data(base64Encoded: pubKeyBase64, options: .ignoreUnknownCharacters),
                let signatureData = Data(base64Encoded: signatureBase64, options: .ignoreUnknownCharacters) else { return false }
        let publicKey: P256.Signing.PublicKey
        do {
            publicKey = try P256.Signing.PublicKey(x963Representation: pubData)
        } catch {
            print("P256 ECDSA Failed to create public key: \(error)")
            return false
        }

        // Convert the signature data to CryptoKit signature
        let signature: P256.Signing.ECDSASignature
        do {
            signature = try P256.Signing.ECDSASignature(derRepresentation: signatureData)
        } catch {
            print("P256 ECDSA Failed to create signature: \(error)")
            return false
        }
        let msgData = msg.data(using: .utf8)
        isValid = publicKey.isValidSignature(signature, for: msgData!)
        print("P256 ECDSA Signature is valid: \(isValid)")
        return isValid
    }
    
    // 384bit
    func verify384(pubKeyBase64: String, signatureBase64: String, msg: String) -> Bool {
        var isValid = false
        guard let pubData = Data(base64Encoded: pubKeyBase64, options: .ignoreUnknownCharacters), let signatureData = Data(base64Encoded: signatureBase64, options: .ignoreUnknownCharacters) else { return false }
        
        let publicKey: P384.Signing.PublicKey
        do {
            if #available(iOS 14.0, *) {
                publicKey = try P384.Signing.PublicKey(derRepresentation: pubData)
            } else {
                // Fallback on earlier versions
                publicKey = try P384.Signing.PublicKey(rawRepresentation: pubData)
            }
        } catch {
            print("P384 ECDSA Failed to create public key: \(error)")
            return false
        }

        // Convert the signature data to CryptoKit signature
        let signature: P384.Signing.ECDSASignature
        do {
            signature = try P384.Signing.ECDSASignature(derRepresentation: signatureData)
        } catch {
            print("P384 ECDSA Failed to create signature: \(error)")
            return false
        }
        
        isValid = publicKey.isValidSignature(signature, for: msg.data(using: .utf8)!)
        print("P384 ECDSA Signature is valid: \(isValid)")
        return isValid
    }
    // 512bit
    func verify521(pubKeyBase64: String, signatureBase64: String, msg: String) -> Bool {
        var isValid = false
        guard let pubData = Data(base64Encoded: pubKeyBase64, options: .ignoreUnknownCharacters), let signatureData = Data(base64Encoded: signatureBase64, options: .ignoreUnknownCharacters) else { return false }
        
        let publicKey: P521.Signing.PublicKey
        do {
            if #available(iOS 14.0, *) {
                publicKey = try P521.Signing.PublicKey(derRepresentation: pubData)
            } else {
                // Fallback on earlier versions
                publicKey = try P521.Signing.PublicKey(rawRepresentation: pubData)
            }        } catch {
            print("P521 ECDSA Failed to create public key: \(error)")
            return false
        }

        // Convert the signature data to CryptoKit signature
        let signature: P521.Signing.ECDSASignature
        do {
            signature = try P521.Signing.ECDSASignature(derRepresentation: signatureData)
        } catch {
            print("P521 ECDSA Failed to create signature: \(error)")
            return false
        }
        
        isValid = publicKey.isValidSignature(signature, for: msg.data(using: .utf8)!)
        print("P521 ECDSA Signature is valid: \(isValid)")
        return isValid
    }
    
}
