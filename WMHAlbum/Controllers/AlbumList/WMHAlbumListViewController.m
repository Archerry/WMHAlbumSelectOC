//
//  WMHAlbumListViewController.m
//  WMHAlbum
//
//  Created by 王闽航 on 2018/8/8.
//  Copyright © 2018年 9JIBidding. All rights reserved.
//

#import "WMHAlbumListViewController.h"
#import "WMHAlbumListCell.h"
#import "WMHThumbnailViewController.h"

@interface WMHAlbumListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UITableView *baseTable;
@property(nonatomic, strong) NSMutableArray<WMHAlbumList *> *arrayDataSource;
@end

@implementation WMHAlbumListViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    _arrayDataSource = [[NSMutableArray alloc] init];
    [self navigationSet];
    if ([self judgeAuthority] == NO) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self getAlbumData];
                });
            }else{
                [self openAuthority];
            }
        }];
    }else{
        [self getAlbumData];
    }    
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    if (_baseTable) {
        [_baseTable reloadData];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
}

#pragma mark - Configure
- (void)navigationSet {
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationBarHeight)];
    [navigationView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:navigationView];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [titleLbl setText:@"相册列表"];
    [titleLbl setFont:[UIFont systemFontOfSize:16]];
    [titleLbl setTextColor: CH_RGBColor(51, 51, 51, 1.0)];
    [titleLbl setTextAlignment:NSTextAlignmentCenter];
    [titleLbl sizeToFit];
    [titleLbl setFrame:CGRectMake((kScreenWidth - CGRectGetWidth(titleLbl.frame)) / 2, (44 - CGRectGetHeight(titleLbl.frame)) / 2 + Height_StatusBar, CGRectGetWidth(titleLbl.frame), CGRectGetHeight(titleLbl.frame))];
    [navigationView addSubview:titleLbl];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 44, Height_StatusBar, 44, 44)];
    [rightBtn setTitle:@"取消" forState:UIControlStateNormal];
    [rightBtn setTitleColor:CH_RGBColor(51, 51, 51, 1.0) forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [rightBtn addTarget:self action:@selector(clickNavigationRightBtn) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:rightBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(navigationView.frame) - 1, kScreenWidth, 1)];
    [lineView setBackgroundColor:CH_RGBColor(223, 223, 223, 1.0)];
    [navigationView addSubview:lineView];
}

- (void)configureUI {
    [self.view addSubview:self.baseTable];
}

#pragma mark - Action
- (void)clickNavigationRightBtn {
    if (self.CancelBlock) {
        self.CancelBlock();
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)judgeAuthority {
    if (PHPhotoLibrary.authorizationStatus == PHAuthorizationStatusNotDetermined) {
        return NO;
    }else{
        return YES;
    }
}

- (void)openAuthority {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
        [self getAlbumData];
    }];
}

- (void)getAlbumData {
    [_arrayDataSource addObjectsFromArray:[[WMHPhotoTool sharePhotoTool] getPhotoAblumList]];
    [self configureUI];
    if (self.isPushAllPhotoSoon == YES) {
        [self pushAllPhotoSoon];
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
}

#pragma mark - 直接push到所有照片界面
- (void)pushAllPhotoSoon
{
    NSInteger i = 0;
    for (WMHAlbumList *ablum in _arrayDataSource) {
        if (ablum.assetCollection.assetCollectionSubtype == 209) {
            i = [_arrayDataSource indexOfObject:ablum];
            break;
        }
    }
    [self pushThumbnailVCWithIndex:i animated:NO];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrayDataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WMHAlbumListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlbumListCell"];
    if (!cell) {
        cell = [[WMHAlbumListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AlbumListCell"];
    }
    
    WMHAlbumList *albumList = _arrayDataSource[indexPath.row];
    
    [[WMHPhotoTool sharePhotoTool] requestImageForAsset:albumList.headImageAsset size:CGSizeMake(65 * 3, 65 * 3) resizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage *image, NSDictionary *info) {
        [cell.AlbumHeader setImage:image];
    }];
    [cell.AlbumTitle setText:albumList.title];
    [cell.AlbumCountLbl setText:[NSString stringWithFormat:@"(%ld)",albumList.count]];
    
    int selectInCurrent = 0;
    for (WMHPhotoModel *model in _arraySelectPhotos) {
        if ([model.albumId isEqualToString:albumList.albumId]) {
            selectInCurrent++;
        }
    }
    if (selectInCurrent > 0) {
        [cell.hasSelectInCurrentLbl setHidden:NO];
        cell.hasSelectInCurrentLbl.text = [NSString stringWithFormat:@"%d",selectInCurrent];
    }else{
        [cell.hasSelectInCurrentLbl setHidden:YES];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self pushThumbnailVCWithIndex:indexPath.row animated:YES];
}

- (void)pushThumbnailVCWithIndex:(NSInteger)index animated:(BOOL)animated{
    WMHAlbumList *ablum = _arrayDataSource[index];
    
    WMHThumbnailViewController *tvc = [[WMHThumbnailViewController alloc] init];
    tvc.showTitle = ablum.title;
    tvc.assetCollection = ablum.assetCollection;
    tvc.maxSelectCount = self.maxSelectCount;
    tvc.isSelectOriginalPhoto = self.isSelectOriginalPhoto;
    tvc.arraySelectPhotos = self.arraySelectPhotos.mutableCopy;
    tvc.sender = self;
    tvc.DoneBlock = self.DoneBlock;
    tvc.CancelBlock = self.CancelBlock;
    weakify(self);
    [tvc setOnSelectedPhotos:^(NSArray<WMHPhotoModel *> *selectedPhotos, BOOL isSelectOriginalPhoto) {
        strongify(weakSelf);
        strongSelf.isSelectOriginalPhoto = isSelectOriginalPhoto;
        [strongSelf.arraySelectPhotos removeAllObjects];
        [strongSelf.arraySelectPhotos addObjectsFromArray:selectedPhotos];
        [strongSelf.baseTable reloadData];
    }];
    [self.navigationController pushViewController:tvc animated:animated];
}

#pragma mark - Lazy
- (UITableView *)baseTable {
    if (!_baseTable) {
        _baseTable = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight - kNavigationBarHeight - iPhone_X_BottomHeight)];
        [_baseTable setBackgroundColor:[UIColor whiteColor]];
        [_baseTable setDelegate:self];
        [_baseTable setDataSource:self];
        [_baseTable setShowsVerticalScrollIndicator:NO];
        [_baseTable setShowsHorizontalScrollIndicator:NO];
        [_baseTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_baseTable registerNib:[UINib nibWithNibName:@"WMHAlbumListCell" bundle:nil] forCellReuseIdentifier:@"AlbumListCell"];
    }
    return _baseTable;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
