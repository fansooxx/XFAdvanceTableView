//
//  UIColor+ColorUntil.h
//  WorkManager
//
//  Created by ukongm on 17/1/5.
//  Copyright © 2017年 ukongm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ColorUntil)


+ (instancetype)colorWith16:(NSInteger)param;

/**
 RGB 模式的颜色设置 （经过 小数处理 处理）

 @param red   red
 @param green green
 @param blue  blue

 @return 颜色对象
 */
+ (instancetype)red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;


/**
 随机颜色

 @return 颜色对象
 */
+ (instancetype)arcColor;


/**
 彩虹色数组(里面装的（id）CGColor)

 @return 彩虹色数组
 */
+ (NSArray*)rainbowColors;



/**
 主题颜色

 @return 颜色对象
 */
+ (instancetype)themeColor;



@end
