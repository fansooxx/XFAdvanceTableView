//
//  TableIndexPath.m
//  QMPadManager
//
//  Created by 谢帆 on 2017/12/24.
//  Copyright © 2017年 谢帆. All rights reserved.
//

#import "TableIndexPath.h"

@implementation TableIndexPath{
    NSInteger _row;
    NSInteger _col;
}

@synthesize row = _row;
@synthesize col = _col;

- (instancetype)initWithRow:(NSInteger)row col:(NSInteger)col{
    if (self = [super init]) {
        
        self.row = row;
        self.col = col;
    }
    return self;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"class:%@   row : %ld    col : %ld",self.class,self.row,self.col];
}

@end
