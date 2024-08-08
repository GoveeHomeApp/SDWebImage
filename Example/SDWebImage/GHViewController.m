//
//  GHViewController.m
//  SDWebImage
//
//  Created by songyang on 08/05/2024.
//  Copyright (c) 2024 songyang. All rights reserved.
//

#import "GHViewController.h"
#import <SDWebImage/UIImage+GIF.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDWebImageDownloaderDecryptor.h>

@interface GHViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *button;

@end

@implementation GHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSString *urlString = @"https://d1f2504ijhdyjw.cloudfront.net/test/test-enc.gif.enc";
//    NSString *urlString = @"https://govee-public.s3.amazonaws.com/device/gif/01760833db209be77145e716b73b0977.gif";
    self.imageView = [[UIImageView alloc] init];
    self.imageView.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview: self.imageView];
    NSURL *url = [NSURL URLWithString:urlString];
    [self.imageView sd_setImageWithURL:url];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
