//
//  WMHThumbnailCell.m
//  WMHAlbum
//
//  Created by 王闽航 on 2018/8/9.
//  Copyright © 2018年 9JIBidding. All rights reserved.
//

#import "WMHThumbnailCell.h"

@implementation WMHThumbnailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self configureUI];
}

- (void)configureUI {
    [self.selectBtn setImage:[UIImage imageNamed:@"ico_check_nomal"] forState:UIControlStateNormal];
    [self.selectBtn setImage:[UIImage imageNamed:@"ico_check_select"] forState:UIControlStateSelected];
}

@end
