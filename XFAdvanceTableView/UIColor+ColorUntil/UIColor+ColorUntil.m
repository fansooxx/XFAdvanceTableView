//
//  UIColor+ColorUntil.m
//  WorkManager
//
//  Created by ukongm on 17/1/5.
//  Copyright © 2017年 ukongm. All rights reserved.
//

#import "UIColor+ColorUntil.h"

@implementation UIColor (ColorUntil)

+ (instancetype)red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue{
    
    CGFloat scale = 255;
    
    return [UIColor colorWithRed:red/scale green:green / scale blue:blue / scale alpha:1];
}

+ (instancetype)colorWith16:(NSInteger)param{
    
    CGFloat red = ((param & 0xFF0000) >> 16);
    CGFloat green = ((param & 0xFF00) >> 8);
    CGFloat blue = ((param & 0xFF));
    
    return [self red:red green:green blue:blue];
}

+ (instancetype)arcColor{
    
    CGFloat red = arc4random() % 255;
    CGFloat green = arc4random() % 255;
    CGFloat blue = arc4random() % 255;
    
    return [self red:red green:green blue:blue];
}

+ (NSArray*)rainbowColors{
    
    return @[(id)[UIColor redColor].CGColor,(id)[UIColor orangeColor].CGColor,(id)[UIColor yellowColor].CGColor,(id)[UIColor greenColor].CGColor,(id)[UIColor red:0 green:127 blue:255].CGColor,(id)[UIColor blueColor].CGColor,(id)[UIColor purpleColor].CGColor];
}
//
//+ (instancetype)pinkColor{
//    return [self red:242 green:156 blue:177];
//}

+ (instancetype)themeColor{
    return [self colorWith16:0xe5348d];
}

@end
