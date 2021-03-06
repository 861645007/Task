//
//  UIColor+ExtensionWithUIColor.m
//  PopingTest
//
//  Created by wanghuanqiang on 14/12/24.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "UIColor+ExtensionWithUIColor.h"

@implementation UIColor (ExtensionWithUIColor)

#pragma mark - 创建 Color
+ (UIColor *)customGrayColor {
    return [self colorWithRed:84 green:84 blue:84];
}

+ (UIColor *)customRedColor {
    return [self colorWithRed:231 green:76 blue:60];
}

+ (UIColor *)customYellowColor {
    return [self colorWithRed:241 green:196 blue:15];
}

+ (UIColor *)customGreenColor {
    return [self colorWithRed:46 green:204 blue:113];
}

+ (UIColor *)customBlueColor {
    return [self colorWithRed:52 green:152 blue:219];
}

#pragma mark - Private class methods
+ (UIColor *)colorWithRed:(NSUInteger)red
                    green:(NSUInteger)green
                     blue:(NSUInteger)blue {
    return [UIColor colorWithRed:(float)(red/255.f)
                           green:(float)(green/255.f)
                            blue:(float)(blue/255.f)
                           alpha:1.f];
}


@end
