//
//  GHViewController.m
//  SDWebImage
//
//  Created by songyang on 08/05/2024.
//  Copyright (c) 2024 songyang. All rights reserved.
//

#import "GHViewController.h"
#import <SDWebImage/SDWebImage.h>
#import "GIFParser.h"
#import "APNGParser.h"

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
    
    NSURL *gifURL = [[NSBundle mainBundle] URLForResource:@"new_6066_anzhuang_yanshi_gif_1ru" withExtension:@"gif"];
    NSData *gifData = [NSData dataWithContentsOfURL:gifURL];

    if (gifData) {
//        NSLog(@"%@", [self hexString:gifData]);
        NSLog(@"%@", gifData.description);
    } else {
        NSLog(@"Failed to load GIF data");
    }
    
    /**
     GIF 文件格式详解
     1. 文件头
     GIF 签名：47 49 46 38 39 61 或 47 49 46 38 37 61（GIF89a 或 GIF87a）
     
     2. 逻辑屏幕描述符 (Logical Screen Descriptor)
     屏幕宽度（2字节）
     屏幕高度（2字节）
     打包字段（1字节）
        全局颜色表标志（1位）
        颜色分辨率（3位）
        排序标志（1位）
        全局颜色表大小（3位）
     背景颜色索引（1字节）
     像素宽高比（1字节）
     
     3. 全局颜色表 (Global Color Table)
     如果全局颜色表标志为1，则存在全局颜色表。颜色表的大小为 2的（全局颜色表大小+1）次方个Item，每个item3字节（RGB）
     
     4. 图像描述符 (Image Descriptor)
     图像分离符：2C
     左位置（2字节）
     顶位置（2字节）
     宽度（2字节）
     高度（2字节）
     打包字段（1字节）
        局部颜色表标志（1位）
        交织标志（1位）
        排序标志（1位）
        局部颜色表大小（3位）
        保留位（2位）
     5. 局部颜色表 (Local Color Table)
     如果局部颜色表标志为1，则存在局部颜色表。颜色表的大小为 2的（全局颜色表大小+1）次方个Item，每个item3字节（RGB）

     6. 图像数据 (Image Data)
     LZW 最小码大小（1字节）
     数据子块：每个子块的第一个字节表示该子块的数据长度（0到255字节），最后一个子块的长度为0。
     
     7. 扩展块 (Extension Block)
     扩展代码：21
     标签（1字节）
        0x01：图形控制扩展
        0xF9：应用程序扩展
        0xFE：注释扩展
        0xFF：应用程序扩展
     数据子块：每个子块的第一个字节表示该子块的数据长度（0到255字节），最后一个子块的长度为0。
     
     8. 图像终止符 (Trailer)
     图像终止符：3B
     
     */
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *filePath = [mainBundle pathForResource:@"new_6066_anzhuang_yanshi_gif_1ru" ofType:@"gif"];
    GIFParser *parser = [[GIFParser alloc] init];
    [parser parseGIFFileAtPath:filePath];
    /**
     APNG 文件格式详解
     1. 文件头
     PNG 签名：89 50 4E 47 0D 0A 1A 0A
     
     2. 数据块结构
     APNG 文件由一系列数据块组成，每个数据块具有以下结构：
        长度字段（4字节）：指示此数据块中数据的长度。
        类型字段（4字节）：定义了数据块的类型。
        数据字段：根据类型字段确定的数据内容。
        CRC 校验码（4字节）：用于检测数据块损坏的循环冗余校验码。
     
     3. 关键数据块类型
     IHDR (Image Header)：图像头，描述图像的基本属性。
        宽度（4字节）
        高度（4字节）
        位深度（1字节）
        颜色类型（1字节）
        压缩方法（1字节）
        过滤方法（1字节）
        交错方法（1字节）
     PLTE (Palette)：调色板，如果图像使用索引颜色模式，则此块定义了颜色调色板。
     IDAT (Image Data)：图像数据，包含了实际的像素数据。
     IEND (Image End)：图像结束，表示图像数据的结束。
     acTL (Animation Control)：动画控制块，用于设置动画的整体参数。(6163544c)
        序列号（4字节）
        帧数（4字节）
        播放次数（4字节）
     fcTL (Frame Control)：帧控制块，用于设置单个动画帧的信息。
        序列号（4字节）
        宽度（4字节）
        高度（4字节）
        X 偏移（4字节）
        Y 偏移（4字节）
        延迟时间分子（2字节）
        延迟时间分母（2字节）
        处置方法（1字节）
        混合方法（1字节）
     fdAT (Frame Data)：帧数据块，类似于IDAT，但用于存储动画帧的数据。
        序列号（4字节）
     */
    
//    NSData *dt = [NSData dataWithBytes:@[@0x61, @0x63, @0x54, @0x4c] length:4];
    
    
    NSURL *apngURL = [[NSBundle mainBundle] URLForResource:@"pad_loading" withExtension:@"png"];
    NSData *apngData = [NSData dataWithContentsOfURL:apngURL];

    if (apngData) {
//        NSLog(@"%@", [self hexString:apngData]);
        NSLog(@"%@", apngData.description);
    } else {
        NSLog(@"Failed to load GIF data");
    }
    
    NSString *apngFilePath = [mainBundle pathForResource:@"pad_loading" ofType:@"png"];
    APNGParser *apngParser = [[APNGParser alloc] init];
    [apngParser parseAPNGFileAtPath:apngFilePath];
    
    
    
}

- (NSString *)hexString:(NSData *)data {
    NSMutableString *hexString = [NSMutableString stringWithCapacity:[data length] * 2];
    const unsigned char *bytes = [data bytes];
    for (NSUInteger i = 0; i < [data length]; i++) {
        [hexString appendFormat:@"%02X", bytes[i]];
    }
    return hexString;
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
