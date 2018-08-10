//
//  WMHAlbumListCell.h
//  WMHAlbum
//
//  Created by 王闽航 on 2018/8/8.
//  Copyright © 2018年 9JIBidding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMHAlbumListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *AlbumHeader;
@property (weak, nonatomic) IBOutlet UILabel *AlbumTitle;
@property (weak, nonatomic) IBOutlet UILabel *AlbumCountLbl;
@property (weak, nonatomic) IBOutlet UILabel *hasSelectInCurrentLbl;

@end
