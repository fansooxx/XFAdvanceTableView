//
//  TowDTableViewCell.m
//  QMPadManager
//
//  Created by 谢帆 on 2017/12/24.
//  Copyright © 2017年 谢帆. All rights reserved.
//

#import "TowDTableViewCell.h"
#import "UIColor+ColorUntil.h"
#import "Masonry.h"
@implementation TowDTableViewCell{
    NSString* _identifier;
    id<ReuseScrollViewIndexInterface> _indexPath;
    UITapGestureRecognizer* _tap;
}

@synthesize titleLb = _titleLb;

#pragma mark - 自己的方法
- (UILabel *)titleLb{
    
    if (_titleLb == nil) {
        _titleLb = [[UILabel alloc] init];
        _titleLb.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLb;
}

#pragma mark - 接口
@synthesize identifier = _identifier;
@synthesize indexPath = _indexPath;
@synthesize tap = _tap;

- (void)layoutSubviews{
    
    __weak typeof(self)sself = self;
    [self.titleLb mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(sself);
    }];
    
}

- (instancetype)initWithReuseIdentify:(NSString *)identifier{
    if (self = [super init]) {
        
        _identifier = identifier;
        
        self.backgroundColor = [UIColor arcColor];
        
        [self addSubview:self.titleLb];
    }
    return self;
}

- (void)setTap:(UITapGestureRecognizer *)tap{
    
    if (tap == nil) {
        [self removeGestureRecognizer:_tap];
    }else{
        [self addGestureRecognizer:tap];
    }
    
    _tap = tap;
}

@end
