//
//  ViewController.m
//  WMHAlbum
//
//  Created by 王闽航 on 2018/8/8.
//  Copyright © 2018年 9JIBidding. All rights reserved.
//

#import "ViewController.h"
#import "WMHAlbumListViewController.h"
#import "WMHPhotoModel.h"

@interface ViewController ()
@property(nonatomic, strong) NSMutableArray *selectImgArray;
@property(nonatomic, assign) BOOL *isSelectOriginalPhoto;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isSelectOriginalPhoto = NO;
    _selectImgArray = [[NSMutableArray alloc] init];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"click" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)click{
    WMHAlbumListViewController *albumList = [[WMHAlbumListViewController alloc] init];
    [albumList setMaxSelectCount:9];
//    [albumList setIsPushAllPhotoSoon:YES];
    [albumList setIsSelectOriginalPhoto:self.isSelectOriginalPhoto];
    [albumList setArraySelectPhotos:_selectImgArray];
    
    weakify(self);
    [albumList setDoneBlock:^(NSArray<WMHPhotoModel *> *selPhotoModels, BOOL isSelectOriginalPhoto) {
        strongify(weakSelf);
        strongSelf.isSelectOriginalPhoto = isSelectOriginalPhoto;
        [strongSelf.selectImgArray removeAllObjects];
        [strongSelf.selectImgArray addObjectsFromArray:selPhotoModels];
    }];
    
    [albumList setCancelBlock:^{
        NSLog(@"取消了");
    }];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:albumList];
    [self presentViewController:nav animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
