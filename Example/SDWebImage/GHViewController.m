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
    NSString *urlString = @"https://d1f2504ijhdyjw.cloudfront.net/test/test-enc.png.enc";
//    NSString *urlString =
    NSString *urlString1 = @"https://d1f2504ijhdyjw.cloudfront.net/test/test-enc.gif.enc";
    self.imageView = [[UIImageView alloc] init];
    self.imageView.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview: self.imageView];
    NSURL *url = [NSURL URLWithString:urlString];
    [self.imageView sd_setImageWithURL:url];
    
    self.button = [[UIButton alloc] init];
    self.button.frame = CGRectMake(100, 300, 100, 100);
    [self.view addSubview: self.button];
    NSURL *url1 = [NSURL URLWithString:urlString1];
    [self.button sd_setImageWithURL:url1 forState:UIControlStateNormal];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
