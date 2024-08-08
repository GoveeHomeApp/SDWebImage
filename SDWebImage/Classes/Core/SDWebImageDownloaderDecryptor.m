/*
* This file is part of the SDWebImage package.
* (c) Olivier Poitrey <rs@dailymotion.com>
*
* For the full copyright and license information, please view the LICENSE
* file that was distributed with this source code.
*/

#import "SDWebImageDownloaderDecryptor.h"
@import GHCryptoKit;

@interface SDWebImageDownloaderDecryptor ()

@property (nonatomic, copy, nonnull) SDWebImageDownloaderDecryptorBlock block;

@end

@implementation SDWebImageDownloaderDecryptor

- (instancetype)initWithBlock:(SDWebImageDownloaderDecryptorBlock)block {
    self = [super init];
    if (self) {
        self.block = block;
    }
    return self;
}

+ (instancetype)decryptorWithBlock:(SDWebImageDownloaderDecryptorBlock)block {
    SDWebImageDownloaderDecryptor *decryptor = [[SDWebImageDownloaderDecryptor alloc] initWithBlock:block];
    return decryptor;
}

- (nullable NSData *)decryptedDataWithData:(nonnull NSData *)data response:(nullable NSURLResponse *)response {
    if (!self.block) {
        return nil;
    }
    return self.block(data, response);
}

@end

@implementation SDWebImageDownloaderDecryptor (Conveniences)

+ (SDWebImageDownloaderDecryptor *)base64Decryptor {
    static SDWebImageDownloaderDecryptor *decryptor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        decryptor = [SDWebImageDownloaderDecryptor decryptorWithBlock:^NSData * _Nullable(NSData * _Nonnull data, NSURLResponse * _Nullable response) {
            NSData *modifiedData = [[NSData alloc] initWithBase64EncodedData:data options:NSDataBase64DecodingIgnoreUnknownCharacters];
            return modifiedData;
        }];
    });
    return decryptor;
}

+ (SDWebImageDownloaderDecryptor *)aesDecryptor {
    static SDWebImageDownloaderDecryptor *decryptor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        decryptor = [SDWebImageDownloaderDecryptor decryptorWithBlock:^NSData * _Nullable(NSData * _Nonnull data, NSURLResponse * _Nullable response) {
            NSURL *downLoadURL = [response URL];
            NSString *urlString = [downLoadURL absoluteString];
            // 属于加密资源
            if ([urlString hasSuffix:@".enc"]) {
                NSData *modifiedData = [GHCryptoKitManager.instance decryptResourceWithEncryptData:data];
                return modifiedData;
            } else {
                return data;
            }
        }];
    });
    return decryptor;
}

@end
