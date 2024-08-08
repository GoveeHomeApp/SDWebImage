//
//  GHFireBaseManager.swift
//  GHFirebase
//
//  Created by yang song on 2024/1/4.
//

import Foundation

@objc open class GHCryptoKitManager: NSObject {
    /// 单例
    @objc public private(set) static var instance = GHCryptoKitManager()
    
}

// MARK: Biz Layer
extension GHCryptoKitManager: EncryptProtocol {
    
    @objc public func verifyP256_ECDSA(pubKeyBase64: String, signatureBase64: String, msg: String) -> Bool {
        return verify256(pubKeyBase64: pubKeyBase64, signatureBase64: signatureBase64, msg: msg)
    }
    
    @objc public func verifyP384_ECDSA(pubKeyBase64: String, signatureBase64: String, msg: String) -> Bool {
        return verify384(pubKeyBase64: pubKeyBase64, signatureBase64: signatureBase64, msg: msg)
    }
    
    @objc public func verifyP521_ECDSA(pubKeyBase64: String, signatureBase64: String, msg: String) -> Bool {
        return verify521(pubKeyBase64: pubKeyBase64, signatureBase64: signatureBase64, msg: msg)
    }
    
    ///  AES + RC4 single pack encrypt; params: data -> origin key -> secertKey position: sub position default is 16 default length is 20
    @objc public func encryptBLEData(data: Data, key: Data? = nil) -> Data {
        return gh_encryptData(data: data, key)
    }
    @objc public func encryptBLEData(data: Data) -> Data {
        return gh_encryptData(data: data, nil)
    }
    ///  AES + RC4 single pack decrypt; params: data -> origin key -> secertKey position: sub position default is 16 default length is 20
    @objc public func decryptBLEData(data: Data, key: Data? = nil) -> Data {
        return gh_decryptData(data: data, key)
    }
    @objc public func decryptBLEData(data: Data) -> Data {
        return gh_decryptData(data: data, nil)
    }
    ///  AES + RC4 multi pack encrypt; params: data -> origin key -> secertKey position: sub position default is 16 default length is 20
    @objc public func encryptBLEDataArray(dataArray: [Data], key: Data? = nil) -> [Data] {
        return gh_encryptDataArray(dataArray: dataArray, key)
    }
    @objc public func encryptBLEDataArray(dataArray: [Data]) -> [Data] {
        return gh_encryptDataArray(dataArray: dataArray, nil)
    }
    ///  AES + RC4 multi pack decrypt; params: data -> origin key -> secertKey position: sub position default is 16 default length is 20
    @objc public func decryptBLEDataArray(dataArray: [Data], key: Data? = nil) -> [Data] {
        return gh_decryptDataArray(dataArray: dataArray, key)
    }
    @objc public func decryptBLEDataArray(dataArray: [Data]) -> [Data] {
        return gh_decryptDataArray(dataArray: dataArray, nil)
    }
    
}

// MARK: Resources encrypt/decrypt padding
extension GHCryptoKitManager {
    
    @objc public func decryptResource(encryptData: Data) -> Data? {
        print("log.f ====== 开始资源解密流程 =======")
        var result: Data? = nil
        // 根据规则解出原始Data
        let arr: [UInt8] = encryptData.bytesArray
        print("log.f 密文Data长度 \(arr.count)")
        print("log.f ====== 解密数据准备 =======")
        guard let segment = arr[check: 0] else { print("log.f ⚠️⚠️获取密文段数失败！！！");  return nil }
        let versionCode = arr[check: 1] ?? 1 // 解不出来就默认初始版本
        print("log.f 密文拆分段数 \(segment)")
        print("log.f 密文规则版本 \(versionCode)")
        // 段数(1byte)+版本(1byte)+[(序号(1byte)+长度(2byte)+密文块)]+向量长度(2byte)+IV
        if let res = ResourceDataPadding.processingData(originArray: arr, version: versionCode, segment: Int(segment)) {
            result = Data(res.resources)
        }
        print("log.f ====== 资源解密流程完成 =======")
        return result
    }
    
}
