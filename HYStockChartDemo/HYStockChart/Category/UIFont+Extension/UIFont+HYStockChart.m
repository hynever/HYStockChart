//
//  UIFont+Extension.m
//  jimustock
//
//  Created by jimubox on 15/5/12.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "UIFont+HYStockChart.h"

@implementation UIFont (Extension)

#pragma mark - 1系列字体
#pragma mark 1-1字体
+(UIFont *)f11Font
{
    return [self blackSimpleFontWithSize:25];
}

#pragma mark 1-2字体
+(UIFont *)f12Font
{
    return [self blackSimpleFontWithSize:18];
}

#pragma mark 1-3字体
+(UIFont *)f13Font
{
    return [self blackSimpleFontWithSize:17];
}

#pragma mark 1-4字体
+(UIFont *)f14Font
{
    return [self blackSimpleFontWithSize:16];
}

#pragma mark 1-5字体
+(UIFont *)f15Font
{
    return [self blackSimpleFontWithSize:14];
}

#pragma mark 1-6字体
+(UIFont *)f16Font
{
    return [self blackSimpleFontWithSize:13];
}

#pragma mark 1-7字体
+(UIFont *)f17Font
{
    return [self blackSimpleFontWithSize:12];
}

#pragma mark 1-8字体
+(UIFont *)f18Font
{
    return [self blackSimpleFontWithSize:11];
}

#pragma mark 1-9字体
+(UIFont *)f19Font
{
    return [self blackSimpleFontWithSize:10];
}

#pragma mark 1-10字体
+(UIFont *)f110Font
{
    return [self blackSimpleFontWithSize:15];
}

#pragma mark - 2系列的字体
#pragma mark 2-1字体
+(UIFont *)f21Font
{
    return [self hnFontWithSize:50];
}

#pragma mark 2-2字体
+(UIFont *)f22Font
{
    return [self hnFontWithSize:25];
}

#pragma mark 2-3字体
+(UIFont *)f23Font
{
    return [self hnFontWithSize:20];
}

#pragma mark 2-4字体
+(UIFont *)f24Font
{
    return [self hnFontWithSize:18];
}

#pragma mark 2-5字体
+(UIFont *)f25Font
{
    return [self hnFontWithSize:12];
}

#pragma mark - 3系列的字体
#pragma mark 3-1字体
+(UIFont *)f31Font
{
    return [self hlFontWithSize:25];
}

#pragma mark 3-2字体
+(UIFont *)f32Font
{
    return [self hlFontWithSize:18];
}

#pragma mark 3-3字体
+(UIFont *)f33Font
{
    return [self hlFontWithSize:17];
}

#pragma mark 3-4字体
+(UIFont *)f34Font
{
    return [self hlFontWithSize:16];
}

#pragma mark 3-5字体
+(UIFont *)f35Font
{
    return [self hlFontWithSize:15];
}

#pragma mark 3-6字体
+(UIFont *)f36Font
{
    return [self hlFontWithSize:14];
}

#pragma mark 3-7字体
+(UIFont *)f37Font
{
    return [self hlFontWithSize:13];
}

#pragma mark 3-8字体
+(UIFont *)f38Font
{
    return [self hlFontWithSize:12];
}

#pragma mark 3-9字体
+(UIFont *)f39Font
{
    return [self hlFontWithSize:11];
}

#pragma mark 3-10字体
+(UIFont *)f310Font
{
    return [self hlFontWithSize:10];
}

#pragma mark 3-11字体
+(UIFont *)f311Font
{
    return [self hlFontWithSize:21];
}

#pragma mark 3-12字体
+(UIFont *)f312Font
{
    return [self hlFontWithSize:26];
}

#pragma mark - 4系列字体
#pragma mark 4-1字体
+(UIFont *)f41Font
{
    return [self adobeBlackFontWithSize:12];
}


#pragma mark - 统一的字体
#pragma mark 黑体-简 细体
+(UIFont *)blackSimpleFontWithSize:(CGFloat)size
{
    return [UIFont systemFontOfSize:size];
}

#pragma mark Helvetica Light字体
+(UIFont *)hlFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"Helvetica Light" size:size];
}


#pragma mark Helvetica Neue字体
+(UIFont *)hnFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"HelveticaNeue-Thin" size:size];
}

#pragma mark Adobe 黑体
+(UIFont *)adobeBlackFontWithSize:(CGFloat)size
{
    return [UIFont systemFontOfSize:size];
}

@end
