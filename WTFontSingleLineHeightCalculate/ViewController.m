//
//  ViewController.m
//  WTFontSingleLineHeightCalculate
//
//  Created by wintel on 2018/6/15.
//  Copyright © 2018年 wintelsui. All rights reserved.
//

#import "ViewController.h"

#import "WTFontSingleLineHeightCalculate.h"

static NSString *const contentZh = @"“龖”";
static NSString *const contentEn= @"'\"fxyZ";
static NSString *const contentZhEn = @"“龖”fxyZ";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor redColor]];
    
    UIFont *font = [UIFont systemFontOfSize:17.0];
    CGFloat y = 64.0;
    for (NSInteger i = 0 ; i <= WTFontHeightCalculateTypeZhEnUpper; i++) {
        CGFloat height = [[WTFontSingleLineHeightCalculate calculator] calculateFont:font contentType:i];
        
        
        UILabel *label = [[UILabel alloc] init];
        [label setFrame:CGRectMake(0, 0, 200, 100)];
        label.backgroundColor = [UIColor blackColor];
        label.textColor = [UIColor whiteColor];
        
        switch (i) {
            case WTFontHeightCalculateTypeZh:
                label.text = contentZh;
                break;
            case WTFontHeightCalculateTypeEn:
                label.text = contentEn;
                break;
            case WTFontHeightCalculateTypeEnLowercase:
                label.text = [contentEn lowercaseString];
                break;
            case WTFontHeightCalculateTypeEnUpper:
                label.text = [contentEn uppercaseString];
                break;
            case WTFontHeightCalculateTypeZhEnLowercase:
                label.text = [contentZhEn lowercaseString];
                break;
            case WTFontHeightCalculateTypeZhEnUpper:
                label.text = [contentZhEn uppercaseString];
                break;
            default:
                label.text = contentZhEn;
                break;
        }
        label.font = font;
        CGRect frameTmp = label.frame;
        frameTmp.size.height = height;
        frameTmp.origin.y = y;
        label.frame = frameTmp;
        
        y += (height + 20);
        [self.view addSubview:label];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
