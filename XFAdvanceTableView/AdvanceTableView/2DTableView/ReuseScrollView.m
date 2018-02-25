//
//  ReuseScrollView.m
//  QMPadManager
//
//  Created by 谢帆 on 2017/12/24.
//  Copyright © 2017年 谢帆. All rights reserved.
//

#import "ReuseScrollView.h"
#import "TableIndexPath.h"

@interface ReuseScrollView()

/** 复用池 */
@property(nonatomic,strong)NSMutableArray<UIView<ReuseScrollViewCellInterface>*>* reuseCellPool;

/** 可视范围内的第一个indexPath */
@property(nonatomic,strong)id<ReuseScrollViewIndexInterface> firstIndexPath;
/** 可视范围内的最后一个indexPath */
@property(nonatomic,strong)id<ReuseScrollViewIndexInterface> lastIndexPath;

@end

@implementation ReuseScrollView{
    __weak id<ReuseScrollViewDataSource> _dataSource;
    __weak id<ReuseScrollViewDelegate> _delegate;
}

- (void)setDelegate:(id<ReuseScrollViewDelegate>)delegate{
    _delegate = delegate;
    
    [super setDelegate:delegate];
}

#pragma mark - 懒加载
- (NSMutableArray<UIView<ReuseScrollViewCellInterface>*> *)reuseCellPool{
    
    if (_reuseCellPool == nil) {
        _reuseCellPool = [NSMutableArray new];
    }
    return _reuseCellPool;
}

#pragma mark - 接口实现
@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;

- (id<ReuseScrollViewIndexInterface>)createIndexPathWithRow:(NSInteger)row col:(NSInteger)col{
    return [[TableIndexPath alloc] initWithRow:row col:col];
}

- (UIView<ReuseScrollViewCellInterface> *)dequeueReusableCellWithIdentifier:(NSString *)identifier{
    return [self dequeueReusableCellWithIdentifier:identifier indexPath:nil];
}

- (UIView<ReuseScrollViewCellInterface> *)dequeueReusableCellWithIdentifier:(NSString *)identifier indexPath:(id<ReuseScrollViewIndexInterface>)indexPath{
    
    __block UIView<ReuseScrollViewCellInterface> * target = nil;
    //在当前可视范围内的视图中找找看
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if (![obj isKindOfClass:[UIImageView class]]) {
            UIView<ReuseScrollViewCellInterface>* cell = (UIView<ReuseScrollViewCellInterface>*)obj;
            
            if ([cell.identifier isEqualToString:identifier]) {
                
                if (cell.indexPath.row == indexPath.row && cell.indexPath.col == indexPath.col) {
                    target = cell;
                }
            }
        }
    }];
    
    if (target) {
        //找到了
        return target;
    }
    
    //没有找到，则在复用池中找一个没有被用过的，返回
    for (UIView<ReuseScrollViewCellInterface>* cell in self.reuseCellPool) {
        
        if ([cell.identifier isEqualToString:identifier]) {
            target = cell;
            [self.reuseCellPool removeObject:cell];
            break;
        }
    }
    return target;
}

- (void)queueReusableCell:(UIView<ReuseScrollViewCellInterface>*)cell{
    cell.indexPath = nil;
    cell.tap = nil;
    [self.reuseCellPool addObject:cell];
    [cell removeFromSuperview];
}

- (UIView<ReuseScrollViewCellInterface> *)cellForIndexPath:(id<ReuseScrollViewIndexInterface>)indexPath{
    for (UIView<ReuseScrollViewCellInterface>* cell in self.subviews) {
        if (![cell isKindOfClass:[UIImageView class]]) {
            if (indexPath.row == cell.indexPath.row && indexPath.col == cell.indexPath.col) {
                return cell;
            }
        }
    }
    return nil;
}

- (void)reloadData{
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if (![obj isKindOfClass:[UIImageView class]]) {
            
            UIView<ReuseScrollViewCellInterface>* cell = (UIView<ReuseScrollViewCellInterface>*)obj;
            
            [self queueReusableCell:cell];
        }
    }];
    
    [self setNeedsDisplay];
}

- (void)reloadDataWithIndexPath:(id<ReuseScrollViewIndexInterface>)indexPath{
    [self.dataSource reuseScrollView:self cellAtIndexPath:indexPath];
}

#pragma mark - 周期
- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.dataSource == nil) {
        return;
    }
    
    [self clearUI];
    [self loadUI];
}

#pragma mark - 逻辑
//清除不在范围内的视图
- (void)clearUI{
    
    __weak typeof(self)sself = self;
    //获取此时，视图的展示范围
    CGRect showRect = CGRectZero;
    showRect.origin = self.contentOffset;
    showRect.size = self.frame.size;
    
    
    NSInteger allRow = [self.dataSource rowNumberWithReuseScrollView:self];
    NSInteger allCol = [self.dataSource colNumberWithReuseScrollView:self];
    
    //记录可是范围内的位置范围
    self.lastIndexPath = [self createIndexPathWithRow:0 col:0];
    self.firstIndexPath = [self createIndexPathWithRow:allRow col:allCol];
    
    [self.subviews enumerateObjectsUsingBlock:^(UIView<ReuseScrollViewCellInterface> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //首先，不在范围内的子视图，全部移除，进入复用池等待复用
        if (![obj isKindOfClass:[UIImageView class]]) {
            if (!CGRectIntersectsRect(showRect, obj.frame)) {
                //没有交集
                [sself queueReusableCell:obj];
            }else{
                //找到最小的
                if (sself.firstIndexPath.row >= obj.indexPath.row && sself.firstIndexPath.col >= obj.indexPath.col) {
                    sself.firstIndexPath = [sself createIndexPathWithRow:obj.indexPath.row col:obj.indexPath.col];
                }
                //找到最大的
                if (sself.lastIndexPath.row <= obj.indexPath.row && sself.lastIndexPath.col <= obj.indexPath.col) {
                    sself.lastIndexPath = [sself createIndexPathWithRow:obj.indexPath.row col:obj.indexPath.col];
                }
            }
        }
    }];
}

//加载显示相应范围内的ui
- (void)loadUI{
    
    //获取此时，视图的展示范围
    CGRect showRect = CGRectZero;
    showRect.origin = self.contentOffset;
    showRect.size = self.frame.size;
    
    NSInteger allRow = [self.dataSource rowNumberWithReuseScrollView:self];
    NSInteger allCol = [self.dataSource colNumberWithReuseScrollView:self];
    
    //获取最大的cell的size，当做每一个cell的size
    CGSize maxSize = CGSizeZero;
    if ([self.dataSource respondsToSelector:@selector(maxCellSizeWithReuseScrollView:)]) {
        maxSize = [self.dataSource maxCellSizeWithReuseScrollView:self];
    }else{
        maxSize = CGSizeMake(200, 200);
    }
    
    //设置滚动范围
    [self setContentSize:CGSizeMake(allCol * maxSize.width,allRow * maxSize.height)];
    
    //计算应该显示的
    for (NSInteger row = 0; row < allRow; row ++) {
        //先判断这个行，是否在显示范围之内，不是的换，继续下一个循环
        /*
         row * maxSize.height + self.contentInset.top > self.contentOffset.y + self.frame.size.height
         
         目的：首先这个判断条件是判断视图下边界出现的cell是否满足计算条件，即是否出现在可视范围内
         由来：
            1.row是行的计算，从0开始，所以row * height 其实是计算第row行的总高度，因为row = 0的情况下也是一行cell，但是高度却是0. 比如row 是3 ，其实应该表示是第四行cell，但是计算的高度却是3 * height。
            2.但此时的位置信息标记的是下一个的位置，同上一个例子，如果row是3，这个判断条件就代表，第四行的cell是否超出在可视范围内了。
         
         
         (row + 1) * maxSize.height + self.contentInset.top < self.contentOffset.y
         
         目的：判断是否超出上边界的可视范围
         */
        if ((row * maxSize.height + self.contentInset.top > self.contentOffset.y + self.frame.size.height) || ((row + 1) * maxSize.height + self.contentInset.top < self.contentOffset.y)) {
            continue;
        }
        for (NSInteger col = 0; col < allCol; col ++) {
            //同上
            if ((col * maxSize.width + self.contentInset.left > self.contentOffset.x + self.frame.size.width) || ((col + 1) * maxSize.width + self.contentInset.left < self.contentOffset.x)) {
                continue;
            }
            
            //这里需要判断，该位置上是否有视图，如果有，则不必要处理
            if (row <= self.lastIndexPath.row && col <= self.lastIndexPath.col && row >= self.firstIndexPath.row && col >= self.firstIndexPath.col) {
                //这个是可是范围内都有视图的
                continue;
            }
            
            //走到这里，就是满足的,安全起见，再次判断是否在可视范围内
            CGRect frame = CGRectMake(maxSize.width * col + self.contentInset.left, maxSize.height * row + self.contentInset.top, maxSize.width, maxSize.height);
            if (CGRectIntersectsRect(frame, showRect)) {
                
                //可以放置新的cell
                id<ReuseScrollViewIndexInterface> indexPath = [self createIndexPathWithRow:row col:col];
                
                UIView<ReuseScrollViewCellInterface>* cell = [self.dataSource reuseScrollView:self cellAtIndexPath:indexPath];
                
                cell.indexPath = indexPath;
                
                cell.frame = frame;
                
                [cell setTap:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellAction:)]];
                
                [self insertSubview:cell atIndex:0];
            }
        }
    }
}


- (void)cellAction:(UITapGestureRecognizer*)tap{
    if(self.delegate){
        if ([self.delegate respondsToSelector:@selector(reuseScrollView:selectAtIndexPath:)]) {
            
            UIView<ReuseScrollViewCellInterface>* cell = (UIView<ReuseScrollViewCellInterface>*)tap.view;
            
            [self.delegate reuseScrollView:self selectAtIndexPath:cell.indexPath];
        }
    }
}

@end
