//
//  ViewController.m
//  XFAdvanceTableView
//
//  Created by 谢帆 on 2018/2/25.
//  Copyright © 2018年 谢帆. All rights reserved.
//

#import "ViewController.h"
#import "TwoDTableView.h"
#import "TowDTableViewCell.h"
#import "TwoDTableView.h"

@interface ViewController ()<TwoDTableViewDelegate,TwoDTableViewDataSource>

/** 二维tables */
@property(nonatomic,strong)TwoDTableView* tableView;
/** 数据 */
@property(nonatomic,strong)NSMutableArray* dataSource;

@end

@implementation ViewController

- (NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initDataSource];
    [self initUI];
    [self addUI];
    
}

//初始化界面
- (void)initUI{
    
    CGRect frame = [UIScreen mainScreen].bounds;
    self.tableView = [[TwoDTableView alloc] initWithFrame:frame];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

//添加界面
- (void)addUI{
    [self.view addSubview:self.tableView];
}

//初始化测试数据
- (void)initDataSource{
    for (NSInteger row = 0; row < 10; row ++) {
        NSMutableArray* colSource = [NSMutableArray new];
        for (NSInteger col = 0; col < 10; col ++) {
            [colSource addObject:[NSString stringWithFormat:@"%ld-%ld",row,col]];
        }
        [self.dataSource addObject:colSource];
    }
}

#pragma mark - 下面都是代理方法

- (CGSize)cellSizeColScrollView:(UIView<ReuseScrollViewInterface> *)scrollView {
    return CGSizeMake(100, 100);
}

- (CGSize)cellSizeRowScrollView:(UIView<ReuseScrollViewInterface> *)scrollView {
    return CGSizeMake(100, 100);
}

- (CGSize)cellSizeScrollView:(UIView<ReuseScrollViewInterface> *)scrollView {
    return CGSizeMake(100, 100);
}

- (NSInteger)colCountColScrollView:(UIView<ReuseScrollViewInterface> *)scrollView {
    NSArray* temp = [self.dataSource firstObject];
    return temp.count;
}

- (NSInteger)colCountRowScrollView:(UIView<ReuseScrollViewInterface> *)scrollView {
    return 1;
}

- (NSInteger)colCountScrollView:(UIView<ReuseScrollViewInterface> *)scrollView {
    return [self colCountColScrollView:scrollView];
}

- (NSInteger)rowCountWithColScrollView:(UIView<ReuseScrollViewInterface> *)scrollView {
    return 1;
}

- (NSInteger)rowCountWithRowScrollView:(UIView<ReuseScrollViewInterface> *)scrollView {
    return self.dataSource.count;
}

- (NSInteger)rowCountWithScrollView:(UIView<ReuseScrollViewInterface> *)scrollView {
    return self.dataSource.count;
}

- (UIView<ReuseScrollViewCellInterface> *)colScrollView:(UIView<ReuseScrollViewInterface> *)scrollView cellAtIndexPath:(id<ReuseScrollViewIndexInterface>)indexPath {
    TowDTableViewCell* cell = [scrollView dequeueReusableCellWithIdentifier:@"cell" indexPath:indexPath];
    
    if (cell == nil) {
        cell = [[TowDTableViewCell alloc] initWithReuseIdentify:@"cell"];
    }
    
    cell.titleLb.text = [NSString stringWithFormat:@"上面的视图：%ld-%ld",indexPath.row,indexPath.col];
    
    return cell;
}


- (UIView<ReuseScrollViewCellInterface> *)rowScrollView:(UIView<ReuseScrollViewInterface> *)scrollView cellAtIndexPath:(id<ReuseScrollViewIndexInterface>)indexPath {
    TowDTableViewCell* cell = [scrollView dequeueReusableCellWithIdentifier:@"cell" indexPath:indexPath];
    
    if (cell == nil) {
        cell = [[TowDTableViewCell alloc] initWithReuseIdentify:@"cell"];
    }
    
    cell.titleLb.text = [NSString stringWithFormat:@"左边的视图：%ld-%ld",indexPath.row,indexPath.col];
    
    return cell;
}

- (UIView<ReuseScrollViewCellInterface> *)scrollView:(UIView<ReuseScrollViewInterface> *)scrollView cellAtIndexPath:(id<ReuseScrollViewIndexInterface>)indexPath {
    TowDTableViewCell* cell = [scrollView dequeueReusableCellWithIdentifier:@"cell" indexPath:indexPath];
    
    if (cell == nil) {
        cell = [[TowDTableViewCell alloc] initWithReuseIdentify:@"cell"];
    }
    
    NSString* title = self.dataSource[indexPath.row][indexPath.col];
    
    cell.titleLb.text = title;
    
    return cell;
}

- (void)scrollView:(UIView<ReuseScrollViewInterface> *)scrollView selectAtIndexPath:(id<ReuseScrollViewIndexInterface>)indexPath{
    
    NSMutableArray* temp = [self.dataSource objectAtIndex:indexPath.row];
    [temp replaceObjectAtIndex:indexPath.col withObject:@"点击"];
    [scrollView reloadDataWithIndexPath:indexPath];
}



@end
