//
//  ReuseScrollViewInterface.h
//  QMPadManager
//
//  Created by 谢帆 on 2017/12/24.
//  Copyright © 2017年 谢帆. All rights reserved.
//


#import <UIKit/UIKit.h>


@protocol ReuseScrollViewIndexInterface<NSObject>

/**
 初始化

 @param row 行
 @param col 列
 @return 对象
 */
- (instancetype)initWithRow:(NSInteger)row col:(NSInteger)col;
/** 行 */
@property(nonatomic,assign)NSInteger row;
/** 列 */
@property(nonatomic,assign)NSInteger col;

@end

#pragma mark cell的接口
@protocol ReuseScrollViewCellInterface


/**
 初始化方法
 
 @param identifier 复用标记
 @return 自己的对象
 */
- (instancetype)initWithReuseIdentify:(NSString*)identifier;

/** 复用标记 */
@property(nonatomic,strong,readonly)NSString* identifier;
/** 位置 */
@property(nonatomic,strong)id<ReuseScrollViewIndexInterface> indexPath;

/** 统一的点击事件 */
@property(nonatomic,strong)UITapGestureRecognizer* tap;

@end

@protocol ReuseScrollViewInterface;
#pragma mark -代理需要实现的协议
@protocol ReuseScrollViewDataSource<NSObject>

- (NSInteger)rowNumberWithReuseScrollView:(UIScrollView<ReuseScrollViewInterface>*)reuseScrollView;
- (NSInteger)colNumberWithReuseScrollView:(UIScrollView<ReuseScrollViewInterface>*)reuseScrollView;
- (UIView<ReuseScrollViewCellInterface>*)reuseScrollView:(UIScrollView<ReuseScrollViewInterface>*)reuseScrollView
                                         cellAtIndexPath:(id<ReuseScrollViewIndexInterface>)indexPath;

@optional
- (CGSize)maxCellSizeWithReuseScrollView:(UIScrollView<ReuseScrollViewInterface>*)reuseScrollView;
- (CGFloat)reuseScrollView:(UIScrollView<ReuseScrollViewInterface>*)reuseScrollView horizontalGapAtIndexPath:(id<ReuseScrollViewIndexInterface>)indexPath;
- (CGFloat)reuseScrollView:(UIScrollView<ReuseScrollViewInterface>*)reuseScrollView verticaGapAtIndexPath:(id<ReuseScrollViewIndexInterface>)indexPath;


@end

@protocol ReuseScrollViewDelegate<NSObject,UIScrollViewDelegate>

@optional
- (void)reuseScrollView:(UIScrollView<ReuseScrollViewInterface>*)reuseScrollView selectAtIndexPath:(id<ReuseScrollViewIndexInterface>)indexPath;
- (void)reuseScrollView:(UIScrollView<ReuseScrollViewInterface>*)reuseScrollView didSelectAtIndexPath:(id<ReuseScrollViewIndexInterface>)indexPath;

@end

@protocol ReuseScrollViewInterface

/**
 获取标记对象

 @param row 行
 @param col 列
 @return 对象
 */
- (id<ReuseScrollViewIndexInterface>)createIndexPathWithRow:(NSInteger)row col:(NSInteger)col;

/** 数据指针 */
@property(nonatomic,weak)id<ReuseScrollViewDataSource> dataSource;
/** 代理指针 */
@property(nonatomic,weak)id<ReuseScrollViewDelegate> delegate;


/**
 获取复用池中的cell

 @param identifier 对应的标记
 @param indexPath 位置
 @return cell
 */
- (__kindof UIView<ReuseScrollViewCellInterface> *)dequeueReusableCellWithIdentifier:(NSString *)identifier indexPath:(id<ReuseScrollViewIndexInterface>)indexPath;

/**
 获取cell

 @param indexPath 位置信息
 @return cell
 */
- (__kindof UIView<ReuseScrollViewCellInterface>*)cellForIndexPath:(id<ReuseScrollViewIndexInterface>)indexPath;

/**
 刷新
 */
- (void)reloadData;
- (void)reloadDataWithIndexPath:(id<ReuseScrollViewIndexInterface>)indexPath;


@end

