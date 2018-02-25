//
//  TowDTableViewCell.h
//  QMPadManager
//
//  Created by 谢帆 on 2017/12/24.
//  Copyright © 2017年 谢帆. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReuseScrollViewInterface.h"

@interface TowDTableViewCell : UIView<ReuseScrollViewCellInterface>

/** 标题 */
@property(nonatomic,strong,readonly)UILabel* titleLb;

@end
