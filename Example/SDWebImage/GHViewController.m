//
//  GHViewController.m
//  SDWebImage
//
//  Created by songyang on 08/05/2024.
//  Copyright (c) 2024 songyang. All rights reserved.
//

#import "GHViewController.h"
#import <SDWebImage/SDWebImage.h>

@interface GHViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *button;

@end

@implementation GHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.imageView = [[UIImageView alloc] init];
    self.imageView.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview: self.imageView];
    self.button = [[UIButton alloc] init];
    self.button.frame = CGRectMake(100, 300, 100, 100);
    [self.view addSubview: self.button];
    
    
    NSString *urlString = @"https://d1f2504ijhdyjw.cloudfront.net/test/test-enc.png.enc";
    NSString *urlString1 = @"https://d1f2504ijhdyjw.cloudfront.net/test/test-enc.gif.enc";
    NSString *urlStringPlane = @"https://govee-public.s3.amazonaws.com/device/gif/01760833db209be77145e716b73b0977.gif";
    NSURL *url = [NSURL URLWithString:urlStringPlane];
    NSURL *url1 = [NSURL URLWithString:urlString1];
    
//    [[[SDWebImageManager sharedManager] imageCache] clearWithCacheType:SDImageCacheTypeAll completion:^{
//        [self.imageView sd_setImageWithURL:url];
//        [self.button sd_setImageWithURL:url1 forState:UIControlStateNormal];
//    }];
    [self.imageView sd_setImageWithURL:url];
    [self.button sd_setImageWithURL:url1 forState:UIControlStateNormal];
    
    
}

+ (BOOL)parseAPNGData:(NSData *)imageData {
    const uint8_t *bytes = [imageData bytes];
    size_t length = [imageData length];
    // 检查 PNG 签名
    if (memcmp(bytes, "\x89PNG", 4) != 0) {
        NSLog(@"Not a valid PNG/APNG file.");
        return NO;
    }
    // 解析块
    size_t offset = 8; // 跳过 PNG 签名和长度
    while (offset < length) {
        uint32_t chunkLength = *(uint32_t *)((const void *)&bytes[offset]);
        const char *chunkType = (const char *)&bytes[offset + 4];
        
        NSString *chunkTypeStr = [[NSString stringWithCString:chunkType encoding:NSUTF8StringEncoding] uppercaseString];
        
        if ([chunkTypeStr isEqualToString:@"ACTL"]) {
            // 解析 acTL 块
            uint32_t numFrames = (*(uint32_t *)((const void *)&bytes[offset + 8]));
            uint32_t loopCount = (*(uint32_t *)((const void *)&bytes[offset + 12]));
            NSLog(@"Number of frames: %u", numFrames);
            NSLog(@"Loop count: %u", loopCount);
            return YES;
        } else {
            // 移动到下一个块
            offset += 4 + chunkLength + 4; // 包括长度、块类型、块数据和CRC校验
        }
    }
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
