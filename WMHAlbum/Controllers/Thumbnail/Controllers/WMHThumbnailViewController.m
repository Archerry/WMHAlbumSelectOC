//
//  WMHThumbnailViewController.m
//  WMHAlbum
//
//  Created by 王闽航 on 2018/8/9.
//  Copyright © 2018年 9JIBidding. All rights reserved.
//

#import "WMHThumbnailViewController.h"
#import "WMHThumbnailCell.h"
#import "WMHShowBigImageViewController.h"

@interface WMHThumbnailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic, strong) UICollectionView *baseCollection;
@property(nonatomic, strong) UICollectionViewFlowLayout *baseLayout;
@property(nonatomic, strong) NSMutableArray<PHAsset *> *arrayDataSource;
@property(nonatomic, strong) NSMutableArray<WMHPhotoModel *> *tempArray;
@property(nonatomic, strong) UIButton *completeBtn;
@property(nonatomic, strong) UILabel *inCircleLbl;
@property(nonatomic, strong) UIButton *originalBtn;
@end

@implementation WMHThumbnailViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    _arrayDataSource = [[NSMutableArray alloc] init];
    _tempArray = [[NSMutableArray alloc] init];
    [self navigationSet];
    [self getAssetInAssetCollection];
    [self initCollectionFlowLayOut];
    [self configureUI];
}

#pragma mark - Configure
- (void)navigationSet {
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationBarHeight)];
    [navigationView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:navigationView];
    
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, Height_StatusBar, 44, 44)];
    [leftBtn setTitle:@"返回" forState:UIControlStateNormal];
    [leftBtn setTitleColor:CH_RGBColor(51, 51, 51, 1.0) forState:UIControlStateNormal];
    [leftBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [leftBtn addTarget:self action:@selector(clickNavigationLeftBtn) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:leftBtn];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [titleLbl setText:self.showTitle];
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

- (void)initCollectionFlowLayOut {
    _baseLayout = [[UICollectionViewFlowLayout alloc] init];
    _baseLayout.itemSize = CGSizeMake((kScreenWidth - 9) / 4, (kScreenWidth - 9) / 4);
    _baseLayout.minimumInteritemSpacing = 1.5;
    _baseLayout.minimumLineSpacing = 1.5;
    _baseLayout.sectionInset = UIEdgeInsetsMake(3, 0, 3, 0);
}

- (void)configureUI {
    [self.view addSubview:self.baseCollection];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 49, kScreenWidth, 49)];
    [bottomView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:bottomView];
    
    UIView *originalView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 50, 0, 100, 49)];
    [originalView setBackgroundColor:[UIColor whiteColor]];
    [bottomView addSubview:originalView];
    
    UILabel *outCircleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 14.5, 20, 20)];
    [outCircleLbl setClipsToBounds:YES];
    [outCircleLbl.layer setCornerRadius:CGRectGetHeight(outCircleLbl.frame) / 2];
    [outCircleLbl setBackgroundColor:[UIColor blackColor]];
    [originalView addSubview:outCircleLbl];
    
    _inCircleLbl = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 16, 16)];
    [_inCircleLbl setClipsToBounds:YES];
    [_inCircleLbl.layer setCornerRadius:CGRectGetHeight(_inCircleLbl.frame) / 2];
    [_inCircleLbl setBackgroundColor:CH_RGBColor(98, 170, 246, 1.0)];
    [outCircleLbl addSubview:_inCircleLbl];
    
    UILabel *originalLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [originalLbl setText:@"原图"];
    [originalLbl setFont:[UIFont systemFontOfSize:14]];
    [originalLbl setTextColor:CH_RGBColor(51, 51, 51, 1.0)];
    [originalLbl sizeToFit];
    [originalLbl setFrame:CGRectMake(CGRectGetMaxX(outCircleLbl.frame) + 5, 0, originalLbl.frame.size.width, 49)];
    [originalView setFrame:CGRectMake((kScreenWidth - CGRectGetMaxX(originalLbl.frame)) / 2, 0, CGRectGetMaxX(originalLbl.frame), 49)];
    [originalView addSubview:originalLbl];
    
    _originalBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(originalView.frame), CGRectGetHeight(originalView.frame))];
    [_originalBtn setBackgroundColor:[UIColor clearColor]];
    [_originalBtn addTarget:self action:@selector(clickOriginalBtn:) forControlEvents:UIControlEventTouchUpInside];
    [originalView addSubview:_originalBtn];
    
    UIView *completeView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth - 100, 0, 100, 49)];
    [completeView setBackgroundColor:[UIColor whiteColor]];
    [bottomView addSubview:completeView];
    
    _completeBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(completeView.frame) - 70, 9, 60, 31)];
    [_completeBtn setClipsToBounds:YES];
    [_completeBtn.layer setCornerRadius:4];
    [_completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    [_completeBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_completeBtn setBackgroundColor:CH_RGBColor(220, 220, 220, 1.0)];
    [_completeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_completeBtn addTarget:self action:@selector(completeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [completeView addSubview:_completeBtn];
    
    [self changeCompleteStatus];
    [self changeOriginalStatus];
}

#pragma mark - Action
- (void)clickNavigationLeftBtn {
    if (self.onSelectedPhotos) {
        self.onSelectedPhotos(self.arraySelectPhotos, self.isSelectOriginalPhoto);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickNavigationRightBtn {
    if (self.CancelBlock) {
        self.CancelBlock();
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)completeBtnClick {
    if (self.DoneBlock) {
        self.DoneBlock(self.arraySelectPhotos, self.isSelectOriginalPhoto);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)clickOriginalBtn:(UIButton *)sender {
    [sender setSelected:!sender.selected];
    if (sender.isSelected == YES) {
        self.isSelectOriginalPhoto = YES;
    }else {
        self.isSelectOriginalPhoto = NO;
    }
    [self changeOriginalStatus];
}

- (void)changeCompleteStatus {
    if (_arraySelectPhotos.count > 0) {
        [_completeBtn setBackgroundColor:CH_RGBColor(98, 170, 246, 1.0)];
        [_completeBtn setTitle:[NSString stringWithFormat:@"完成(%ld)",_arraySelectPhotos.count] forState:UIControlStateNormal];
        [_completeBtn setUserInteractionEnabled:YES];
    }else{
        [_completeBtn setUserInteractionEnabled:NO];
        [_completeBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_completeBtn setBackgroundColor:CH_RGBColor(220, 220, 220, 1.0)];
    }
}

- (void)changeOriginalStatus {
    if (self.isSelectOriginalPhoto == YES) {
        [_originalBtn setSelected:YES];
        [_inCircleLbl setBackgroundColor:CH_RGBColor(98, 170, 246, 1.0)];
    }else{
        [_originalBtn setSelected:NO];
        [_inCircleLbl setBackgroundColor:[UIColor whiteColor]];
    }
}

- (void)getAssetInAssetCollection {
    [_arrayDataSource addObjectsFromArray:[[WMHPhotoTool sharePhotoTool] getAssetsInAssetCollection:self.assetCollection ascending:YES]];
}

- (void)cellBtnClick:(UIButton *)sender {
    if (_arraySelectPhotos.count >= self.maxSelectCount) {
        NSLog(@"最多选择%ld张图片",self.maxSelectCount);
        if (sender.isSelected == YES) {
            
        }else{
            return;
        }
    }
    
    PHAsset *asset = _arrayDataSource[sender.tag];
    
    if (!sender.isSelected) {
        //添加图片至选中数组
        [sender.layer addAnimation:GetBtnStatusChangedAnimation() forKey:nil];
        WMHPhotoModel *model = [[WMHPhotoModel alloc] init];
        [model setAsset:asset];
        [model setLocalIdentifier:asset.localIdentifier];
        [model setAlbumId:self.assetCollection.localIdentifier];
        [_arraySelectPhotos addObject:model];
    }else{
        for (WMHPhotoModel *model in _arraySelectPhotos) {
            if ([model.localIdentifier isEqualToString:asset.localIdentifier]) {
                [_arraySelectPhotos removeObject:model];
                break;
            }
        }
    }
    
    [self changeCompleteStatus];
    [sender setSelected:!sender.selected];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _arrayDataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WMHThumbnailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ThumbnailCell" forIndexPath:indexPath];
    
    PHAsset *asset = _arrayDataSource[indexPath.row];
    [cell.selectBtn setSelected:NO];
    
    weakify(self);
    [[WMHPhotoTool sharePhotoTool] requestImageForAsset:asset size:CGSizeMake(CGRectGetWidth(cell.frame) * 2.5, CGRectGetHeight(cell.frame) * 2.5) resizeMode:PHImageRequestOptionsResizeModeExact completion:^(UIImage *image, NSDictionary *info) {
        [cell.showImage setImage:image];
        strongify(weakSelf);
        for (WMHPhotoModel *model in strongSelf.arraySelectPhotos) {
            if ([model.localIdentifier isEqualToString:asset.localIdentifier]) {
                [cell.selectBtn setSelected:YES];
                break;
            }
        }
    }];
    [cell.selectBtn setTag:indexPath.row];
    [cell.selectBtn addTarget:self action:@selector(cellBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self pushShowBigImgVCWithDataArray:_arrayDataSource selectIndex:indexPath.row];
}

- (void)pushShowBigImgVCWithDataArray:(NSArray<PHAsset *> *)dataArray selectIndex:(NSInteger)selectIndex
{
    WMHShowBigImageViewController *svc = [[WMHShowBigImageViewController alloc] init];
    svc.assets = dataArray;
    svc.selectIndex = selectIndex;
    svc.arraySelectPhotos = self.arraySelectPhotos.mutableCopy;
    svc.maxSelectCount = _maxSelectCount;
    svc.isSelectOriginalPhoto = self.isSelectOriginalPhoto;
    svc.assetCollection = self.assetCollection;
    weakify(self);
    [svc setOnSelectedPhotos:^(NSArray<WMHPhotoModel *> *selectedPhotos, BOOL isSelectOriginalPhoto) {
        strongify(weakSelf);
        strongSelf.isSelectOriginalPhoto = isSelectOriginalPhoto;
        [strongSelf.arraySelectPhotos removeAllObjects];
        [strongSelf.arraySelectPhotos addObjectsFromArray:selectedPhotos];
        [strongSelf.baseCollection reloadData];
        [strongSelf changeCompleteStatus];
        [strongSelf changeOriginalStatus];
    }];
    [svc setBtnDoneBlock:^(NSArray<WMHPhotoModel *> *selectedPhotos, BOOL isSelectOriginalPhoto) {
        strongify(weakSelf);
        strongSelf.isSelectOriginalPhoto = isSelectOriginalPhoto;
        [strongSelf.arraySelectPhotos removeAllObjects];
        [strongSelf.arraySelectPhotos addObjectsFromArray:selectedPhotos];
        [strongSelf completeBtnClick];
    }];
    [self.navigationController pushViewController:svc animated:YES];
}

#pragma mark - Lazy
- (UICollectionView *)baseCollection {
    if (!_baseCollection) {
        _baseCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight - kNavigationBarHeight - iPhone_X_BottomHeight - 49) collectionViewLayout:_baseLayout];
        [_baseCollection setDelegate:self];
        [_baseCollection setDataSource:self];
        [_baseCollection setBackgroundColor:[UIColor whiteColor]];
        [_baseCollection setShowsVerticalScrollIndicator:NO];
        [_baseCollection setShowsHorizontalScrollIndicator:NO];
        [_baseCollection registerNib:[UINib nibWithNibName:@"WMHThumbnailCell" bundle:nil] forCellWithReuseIdentifier:@"ThumbnailCell"];
    }
    return _baseCollection;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
