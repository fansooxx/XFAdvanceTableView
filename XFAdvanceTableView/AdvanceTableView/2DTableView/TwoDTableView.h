//
//  2DTableView.h
//  QMPadManager
//
//  Created by 谢帆 on 2017/12/23.
//  Copyright © 2017年 谢帆. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReuseScrollViewInterface.h"

@class TwoDTableView;
@protocol TwoDTableViewDataSource<NSObject>

- (UIView<ReuseScrollViewCellInterface>*)rowScrollView:(UIView<ReuseScrollViewInterface>*)scrollView cellAtIndexPath:(id<ReuseScrollViewIndexInterface>)indexPath;
- (NSInteger)rowCountWithRowScrollView:(UIView<ReuseScrollViewInterface>*)scrollView;
- (NSInteger)colCountRowScrollView:(UIView<ReuseScrollViewInterface>*)scrollView;
- (CGSize)cellSizeRowScrollView:(UIView<ReuseScrollViewInterface>*)scrollView;

- (UIView<ReuseScrollViewCellInterface>*)colScrollView:(UIView<ReuseScrollViewInterface>*)scrollView cellAtIndexPath:(id<ReuseScrollViewIndexInterface>)indexPath;
- (NSInteger)rowCountWithColScrollView:(UIView<ReuseScrollViewInterface>*)scrollView;
- (NSInteger)colCountColScrollView:(UIView<ReuseScrollViewInterface>*)scrollView;
- (CGSize)cellSizeColScrollView:(UIView<ReuseScrollViewInterface>*)scrollView;

- (UIView<ReuseScrollViewCellInterface>*)scrollView:(UIView<ReuseScrollViewInterface>*)scrollView cellAtIndexPath:(id<ReuseScrollViewIndexInterface>)indexPath;
- (NSInteger)rowCountWithScrollView:(UIView<ReuseScrollViewInterface>*)scrollView;
- (NSInteger)colCountScrollView:(UIView<ReuseScrollViewInterface>*)scrollView;
- (CGSize)cellSizeScrollView:(UIView<ReuseScrollViewInterface>*)scrollView;

@end

@protocol TwoDTableViewDelegate<NSObject>

@optional
- (void)rowScrollView:(UIView<ReuseScrollViewInterface>*)scrollView selectAtIndexPath:(id<ReuseScrollViewIndexInterface>)indexPath;
- (void)colScrollView:(UIView<ReuseScrollViewInterface>*)scrollView selectAtIndexPath:(id<ReuseScrollViewIndexInterface>)indexPath;
- (void)scrollView:(UIView<ReuseScrollViewInterface>*)scrollView selectAtIndexPath:(id<ReuseScrollViewIndexInterface>)indexPath;

@end

@interface TwoDTableView : UIView


/** 数据代理 */
@property(nonatomic,weak)id<TwoDTableViewDataSource> dataSource;
/** 事件代理 */
@property(nonatomic,weak)id<TwoDTableViewDelegate> delegate;

/**
 工厂方法，创建合适的滚动视图

 @return 实现了复用的滚动视图
 */
- (UIScrollView<ReuseScrollViewInterface>*)createScrollView;

@end
