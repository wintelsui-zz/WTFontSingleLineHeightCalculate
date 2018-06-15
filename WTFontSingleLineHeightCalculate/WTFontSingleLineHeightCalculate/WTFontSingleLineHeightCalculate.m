//
//  WTFontSingleLineHeightCalculate.m
//  WTFontSingleLineHeightCalculate
//
//  Created by wintel on 2018/6/15.
//  Copyright © 2018年 wintelsui. All rights reserved.
//

#import "WTFontSingleLineHeightCalculate.h"
#import "pthread.h"


static NSString *const contentZh = @"“龖”";
static NSString *const contentEn= @"'\"fxyZ";
static NSString *const contentZhEn = @"“龖”fxyZ";

static WTFontSingleLineHeightCalculate * _instance;

@interface WTFontSingleLineHeightCalculate ()
{
    UILabel *_contextLabel;
    
    pthread_mutex_t mylock;
    NSMutableDictionary *_fontInfo;
}
@end

@implementation WTFontSingleLineHeightCalculate

+ (instancetype)calculator{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _instance = [[[self class] alloc] init];
        [_instance setup];
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (void)setup{
    pthread_mutex_init(&mylock,NULL);
//    pthread_mutex_destroy(&mylock);
}

- (UILabel *)contextLabel {
    if (_contextLabel == nil) {
        _contextLabel = [[UILabel alloc] init];
        [_contextLabel setFrame:CGRectMake(0, 0, 200, 100)];
        _contextLabel.backgroundColor = [UIColor blackColor];
        _contextLabel.textColor = [UIColor whiteColor];
    }
    return _contextLabel;
}

- (NSMutableDictionary *)fontInfo{
    if (_fontInfo == nil) {
        _fontInfo = [[NSMutableDictionary alloc] init];
    }
    return _fontInfo;
}

- (CGFloat)calculateFont:(UIFont *)textFont contentType:(WTFontHeightCalculateType)type {
    NSString *key = [NSString stringWithFormat:@"%@-%ld",[textFont description],type];
    CGFloat height = [self getHeightByKey:key];
    if (height > 0.0) {
        return height;
    }
    height = [self calculateDrawFont:textFont contentType:type];
    [self setHeight:height forKey:key];
    return height;
}

- (void)setHeight:(CGFloat)height forKey:(NSString *)key {
    if (key != nil) {
        pthread_mutex_lock(&mylock);
        [[self fontInfo] setObject:@(height) forKey:key];
        pthread_mutex_unlock(&mylock);
    }
}

- (CGFloat)getHeightByKey:(NSString *)key {
    if (key != nil) {
        NSNumber *height = [[self fontInfo] objectForKey:key];
        if (height != nil) {
            return [height floatValue];
        }
    }
    return 0.0f;
}

- (CGFloat)calculateDrawFont: (UIFont *)textFont contentType:(WTFontHeightCalculateType)type
{
    UILabel *label = [self contextLabel];
    
    switch (type) {
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
    label.font = textFont;
    CGRect frameTmp = label.frame;
    frameTmp.size.height = textFont.lineHeight;
    label.frame = frameTmp;
    [label sizeToFit];
    
    UIGraphicsBeginImageContext(label.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [label.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGPoint point = CGPointZero;
    {
        const int imageWidth = image.size.width;
        const int imageHeight = image.size.height;
        size_t bytesPerRow = imageWidth * 4;
        uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
        CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
        // 遍历像素
        int pixelNum = imageWidth * imageHeight;
        uint32_t* pCurPtr = rgbImageBuf;
        NSInteger firstPoint = 0;
        NSInteger lastPoint = 0;
        for (int i = 0; i < pixelNum; i++, pCurPtr++)
        {
            //ARGB这种表示方式。ptr[0]:透明度,ptr[1]:R,ptr[2]:G,ptr[3]:B
            //分别取出RGB值后。
            uint8_t* ptr = (uint8_t*)pCurPtr;
            
            if (ptr[1] > 100 && ptr[2] > 100 && ptr[3] > 100) {
                if (firstPoint == 0) {
                    firstPoint = i;
                }else{
                    lastPoint = i;
                }
            }
        }
        NSInteger start = firstPoint / imageWidth;
        NSInteger end = lastPoint / imageWidth;
        point.x = start;
        point.y = end + 1;
    }
    return point.y - point.x;
}
@end
