//
//  WTFontSingleLineHeightCalculate.h
//  WTFontSingleLineHeightCalculate
//
//  Created by wintel on 2018/6/15.
//  Copyright © 2018年 wintelsui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    WTFontHeightCalculateTypeZh,
    WTFontHeightCalculateTypeEn,
    WTFontHeightCalculateTypeEnLowercase,
    WTFontHeightCalculateTypeEnUpper,
    WTFontHeightCalculateTypeZhEn,
    WTFontHeightCalculateTypeZhEnLowercase,
    WTFontHeightCalculateTypeZhEnUpper,
} WTFontHeightCalculateType;

@interface WTFontSingleLineHeightCalculate : NSObject

+ (instancetype)calculator;

- (CGFloat)calculateFont:(UIFont *)textFont contentType:(WTFontHeightCalculateType)type;

@end
