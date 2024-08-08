
public protocol EncryptProtocol {
    
    /// ECC 椭圆加密算法验证256位
    func verify256(pubKeyBase64: String, signatureBase64: String, msg: String) -> Bool
    /// ECC 椭圆加密算法验证384位
    func verify384(pubKeyBase64: String, signatureBase64: String, msg: String) -> Bool
    /// ECC 椭圆加密算法验证521位
    func verify521(pubKeyBase64: String, signatureBase64: String, msg: String) -> Bool
    
}
