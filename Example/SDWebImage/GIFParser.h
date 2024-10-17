//
//  GIFParser.h
//  SDWebImage_Example
//
//  Created by sy on 2024/10/17.
//  Copyright © 2024 songyang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GIFParser : NSObject

- (void)parseGIFFileAtPath:(NSString *)filePath;

@end

NS_ASSUME_NONNULL_END
