//
//  ResData.swift
//  GHCryptoKit
//
//  Created by sy on 2024/8/8.
//

import Foundation

struct ResourceData {
    var key: [UInt8] = []
    var iv: [UInt8] = []
    var resources: [UInt8] = []
}

class ResourceDataPadding {
    // 返回解密Data pack
    static func processingData(originArray: [UInt8], version: UInt8, segment: Int) -> ResourceData? {
        var res: ResourceData? = nil
        // 丢掉前两位标记
        let paddingData = Array(originArray.dropFirst(2))
        switch version {
        case 1:
            let secTuple = parseAll(paddingData, segment: segment)
            if let key = secTuple.0, let iv = secTuple.1, let secData = secTuple.2 {
                print("log.f ====== 开始解密数据 =======")
//                print("log.f encryptData \(secData)")
                if let decryptData = decryptData(key: key, iv: iv, data: secData) {
                    res = ResourceData(key: key, iv: iv, resources: decryptData)
//                    print("log.f decryptData \(decryptData)")
                }
            }
            break
        default: break
        }
        print("log.f ====== 解密数据结束 =======")
        return res
    }
    
    private static func parseAll(_ data: [UInt8], segment: Int) -> ([UInt8]?, [UInt8]?, [UInt8]?) {
        var index = 0
        var currentSegment: Int = 1
        var resultDict: [Int: [UInt8]] = [:]
        var resultKey: [UInt8] = []
        // 转译密钥
        while resultDict.count < segment {
            // 读取序号
            guard let seg = data.safe(index..<index+1) else { break }
            currentSegment = Int(seg[0])
            print("log.f 当前组号 \(currentSegment)")
            // 跳过序号
            index += 1
            // 读取长度（小端模式）
            guard let lengthBytes = data.safe(index..<index+2) else { break }
            let length = UInt16(SmallEndBytes(lengthBytes[1], lengthBytes[0]))
            print("log.f 当前组号长度 \(Int(length))")
            // 跳过长度
            index += 2
            // 读取实际数据
            guard let actualData = data.safe(index..<index+Int(length)) else { break }
            print("log.f 当前组号数据 \(actualData)")
            // 将实际数据添加到结果数组中
            resultDict[currentSegment] = actualData
            // 跳到下一个数据块
            index += Int(length)
        }
        resultKey = resultDict.sorted { $0.key < $1.key }.flatMap { $0.value }
        print("log.f 已处理完密钥，当前index \(index)")
        print("log.f 当前密钥 \(resultKey)")
        print("log.f 当前密钥长度 \(resultKey.count)")
        let remainArray = Array(data.dropFirst(index))
        guard let ivlengthBytes = remainArray.safe(0..<2) else { return (nil, nil, nil) }
        let ivlength = UInt16(SmallEndBytes(ivlengthBytes[1], ivlengthBytes[0]))
        print("log.f 当前向量长度 \(Int(ivlength))")
        guard let ivData = remainArray.safe(2..<Int(ivlength)+2) else { return (nil, nil, nil) }
        print("log.f 当前向量数据 \(ivData)")
        let realLength = Int(ivlength) + 2
        let secDataArray = Array(remainArray.dropFirst(realLength))
        print("log.f 已处理完向量数据")
        print("log.f ====== 解密数据准备 结束 =======")
        return (resultKey.isEmpty ? nil : resultKey, ivData, secDataArray)
    }
    // 返回解密后资源Data
    static func decryptData(key: [UInt8], iv: [UInt8], data: [UInt8]) -> [UInt8]? {
        // 解密流程
        return AESBiz.aes128_CBC_PKCS5_Decrypt(cipherText: data, key: key, iv: iv)
    }
    
}
