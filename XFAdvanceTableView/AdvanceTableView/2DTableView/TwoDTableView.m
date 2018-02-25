//
//  2DTableView.m
//  QMPadManager
//
//  Created by 谢帆 on 2017/12/23.
//  Copyright © 2017年 谢帆. All rights reserved.
//

#import "TwoDTableView.h"
#import "ReuseScrollView.h"
#import "Masonry.h"

@interface TwoDTableView()<ReuseScrollViewDelegate,ReuseScrollViewDataSource>

/** 行滚动视图 */
@property(nonatomic,strong)UIScrollView<ReuseScrollViewInterface>* rowScrollView;
/** 列滚动视图 */
@property(nonatomic,strong)UIScrollView<ReuseScrollViewInterface>* colScrollView;
/** 主体滚动 */
@property(nonatomic,strong)UIScrollView<ReuseScrollViewInterface>* scrollView;

@end

@implementation TwoDTableView

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self addLayout];
}

#pragma mark - 初始化

- (instancetype)init{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        [self addUI];
    }
    return self;
}

#pragma mark - 创建视图
- (UIScrollView<ReuseScrollViewInterface>*)createScrollView{
    ReuseScrollView* scrollView = [[ReuseScrollView alloc] init];
    
    if (@available(iOS 11.0 , *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    scrollView.delegate = self;
    scrollView.dataSource = self;
    scrollView.bounces = NO;
    return scrollView;
}

#pragma mark - 代理
- (UIView<ReuseScrollViewCellInterface> *)reuseScrollView:(UIScrollView<ReuseScrollViewInterface> *)reuseScrollView cellAtIndexPath:(id<ReuseScrollViewIndexInterface>)indexPath{
    
    if (reuseScrollView == self.rowScrollView) {
        return [self.dataSource rowScrollView:reuseScrollView cellAtIndexPath:indexPath];
    }else if (reuseScrollView == self.colScrollView){
        return [self.dataSource colScrollView:reuseScrollView cellAtIndexPath:indexPath];
    }else if (reuseScrollView == self.scrollView){
        return [self.dataSource scrollView:reuseScrollView cellAtIndexPath:indexPath];
    }
    return nil;
}

- (NSInteger)rowNumberWithReuseScrollView:(UIScrollView<ReuseScrollViewInterface> *)reuseScrollView{
    if (reuseScrollView == self.rowScrollView) {
        return [self.dataSource rowCountWithRowScrollView:reuseScrollView];
    }else if (reuseScrollView == self.colScrollView){
        return [self.dataSource rowCountWithColScrollView:reuseScrollView];
    }else if (reuseScrollView == self.scrollView){
        return [self.dataSource rowCountWithScrollView:reuseScrollView];
    }
    return 0;
}

- (NSInteger)colNumberWithReuseScrollView:(UIScrollView<ReuseScrollViewInterface> *)reuseScrollView{
    if (reuseScrollView == self.rowScrollView) {
        return [self.dataSource colCountRowScrollView:reuseScrollView];
    }else if (reuseScrollView == self.colScrollView){
        return [self.dataSource colCountColScrollView:reuseScrollView];
    }else if (reuseScrollView == self.scrollView){
        return [self.dataSource colCountScrollView:reuseScrollView];
    }
    return 0;
}

- (CGSize)maxCellSizeWithReuseScrollView:(UIScrollView<ReuseScrollViewInterface> *)reuseScrollView{
    
    if (reuseScrollView == self.rowScrollView) {
        return [self.dataSource cellSizeRowScrollView:reuseScrollView];
    }else if (reuseScrollView == self.colScrollView){
        return [self.dataSource cellSizeColScrollView:reuseScrollView];
    }else if (reuseScrollView == self.scrollView){
        return [self.dataSource cellSizeScrollView:reuseScrollView];
    }
    return CGSizeZero;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.dragging) {
        if (scrollView == self.rowScrollView) {
            [self.scrollView setContentOffset:scrollView.contentOffset];
        }else if (scrollView == self.colScrollView){
            [self.scrollView setContentOffset:scrollView.contentOffset];
        }else if (scrollView == self.scrollView){
            [self.rowScrollView setContentOffset:CGPointMake(0, scrollView.contentOffset.y)];
            [self.colScrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, 0)];
        }
    }
}

- (void)reuseScrollView:(UIScrollView<ReuseScrollViewInterface> *)reuseScrollView selectAtIndexPath:(id<ReuseScrollViewIndexInterface>)indexPath{
    
    if (self.delegate == nil) {
        return;
    }
    
    if (reuseScrollView == self.rowScrollView && [self.delegate respondsToSelector:@selector(rowScrollView:selectAtIndexPath:)]) {
        [self.delegate rowScrollView:reuseScrollView selectAtIndexPath:indexPath];
    }else if (reuseScrollView == self.colScrollView && [self.delegate respondsToSelector:@selector(colScrollView:selectAtIndexPath:)]){
        [self.delegate colScrollView:reuseScrollView selectAtIndexPath:indexPath];
    }else if (reuseScrollView == self.scrollView && [self.delegate respondsToSelector:@selector(scrollView:selectAtIndexPath:)]){
        [self.delegate scrollView:reuseScrollView selectAtIndexPath:indexPath];
    }
}

#pragma mark - 初始化视图
- (void)initUI{
    
    self.rowScrollView = [self createScrollView];
    self.rowScrollView.showsVerticalScrollIndicator = NO;
    self.colScrollView = [self createScrollView];
    self.colScrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView = [self createScrollView];
}

- (void)addUI{
    [self addSubview:self.rowScrollView];
    [self addSubview:self.colScrollView];
    [self addSubview:self.scrollView];
}

- (void)addLayout{
    __weak typeof(self)sself = self;
    
    //获取侧面宽度
    CGFloat rowWidth = [self.dataSource cellSizeRowScrollView:self.rowScrollView].width;
    [self.rowScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(sself);
        make.bottom.equalTo(sself);
        make.top.equalTo(sself.colScrollView.mas_bottom);
        make.width.mas_equalTo(rowWidth);
    }];
    
    //获取上面高度
    CGFloat colHeight = [self.dataSource cellSizeColScrollView:self.colScrollView].height;
    [self.colScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(sself.rowScrollView.mas_right);
        make.top.right.equalTo(sself);
        make.height.mas_equalTo(colHeight);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.equalTo(sself.colScrollView);
        make.top.equalTo(sself.colScrollView.mas_bottom);
        make.bottom.equalTo(sself);
        
    }];
}

@end
