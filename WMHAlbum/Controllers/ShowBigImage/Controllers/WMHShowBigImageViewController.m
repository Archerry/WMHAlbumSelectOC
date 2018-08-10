//
//  WMHShowBigImageViewController.m
//  WMHAlbum
//
//  Created by 王闽航 on 2018/8/9.
//  Copyright © 2018年 9JIBidding. All rights reserved.
//

#import "WMHShowBigImageViewController.h"
#import "WMHShowBigImageCell.h"

@interface WMHShowBigImageViewController ()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic, strong) UICollectionView *baseCollection;
@property(nonatomic, strong) UICollectionViewFlowLayout *baseLayout;
@property(nonatomic, strong) NSMutableArray<PHAsset *> *arrayDataSource;
@property(nonatomic, assign) NSInteger currentIndex;
@property(nonatomic, strong) UIView *upView;
@property(nonatomic, strong) UIView *bottomView;
@property(nonatomic, strong) UIButton *selectBtn;
@property(nonatomic, strong) UIButton *commitBtn;
@property(nonatomic, strong) UIButton *completeBtn;
@property(nonatomic, strong) UILabel *inCircleLbl;
@property(nonatomic, strong) UIButton *originalBtn;
@property(nonatomic, strong) UILabel *photoBytesLbl;
@end

@implementation WMHShowBigImageViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    _arrayDataSource = [[NSMutableArray alloc] init];
    [_arrayDataSource addObjectsFromArray:self.assets];
    _currentIndex = self.selectIndex + 1;
    [self initCollectionFlowLayOut];
    [self configureUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [_baseCollection setContentOffset:CGPointMake(self.selectIndex * kScreenWidth, 0)];
}

- (void)viewWillDisappear:(BOOL)animated {
    [_upView removeFromSuperview];
    [_bottomView removeFromSuperview];
}

#pragma mark - Configure
- (void)initCollectionFlowLayOut {
    _baseLayout = [[UICollectionViewFlowLayout alloc] init];
    _baseLayout.itemSize = self.view.bounds.size;
    _baseLayout.minimumLineSpacing = 0;
    _baseLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _baseLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

- (void)configureUI {
    [self.view addSubview:self.baseCollection];
    [self createUpAndBottomView];
}

- (void)createUpAndBottomView {
    _upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    [_upView setBackgroundColor:[UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.6]];
    [[UIApplication sharedApplication].keyWindow addSubview:_upView];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [_upView addSubview:backBtn];
    
    _selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 64, 0, 64, 64)];
    [_selectBtn setImageEdgeInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
    [_selectBtn.imageView setContentMode:UIViewContentModeScaleAspectFill];
    [_selectBtn setImage:[UIImage imageNamed:@"ico_check_nomal"] forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:@"ico_check_select"] forState:UIControlStateSelected];
    [_selectBtn addTarget:self action:@selector(clickSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_upView addSubview:_selectBtn];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 49, kScreenWidth, 49)];
    [_bottomView setBackgroundColor:[UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.7]];
    [[UIApplication sharedApplication].keyWindow addSubview:_bottomView];
    
    UIView *originalView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 50, 0, 100, 49)];
    [originalView setBackgroundColor:[UIColor clearColor]];
    [_bottomView addSubview:originalView];
    
    UILabel *outCircleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 14.5, 20, 20)];
    [outCircleLbl setClipsToBounds:YES];
    [outCircleLbl.layer setCornerRadius:CGRectGetHeight(outCircleLbl.frame) / 2];
    [outCircleLbl setBackgroundColor:[UIColor whiteColor]];
    [originalView addSubview:outCircleLbl];
    
    _inCircleLbl = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 16, 16)];
    [_inCircleLbl setClipsToBounds:YES];
    [_inCircleLbl.layer setCornerRadius:CGRectGetHeight(_inCircleLbl.frame) / 2];
    [_inCircleLbl setBackgroundColor:CH_RGBColor(98, 170, 246, 1.0)];
    [outCircleLbl addSubview:_inCircleLbl];
    
    UILabel *originalLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [originalLbl setText:@"原图"];
    [originalLbl setFont:[UIFont systemFontOfSize:14]];
    [originalLbl setTextColor:[UIColor whiteColor]];
    [originalLbl sizeToFit];
    [originalLbl setFrame:CGRectMake(CGRectGetMaxX(outCircleLbl.frame) + 5, 0, originalLbl.frame.size.width, 49)];
    [originalView setFrame:CGRectMake((kScreenWidth - CGRectGetMaxX(originalLbl.frame)) / 2, 0, CGRectGetMaxX(originalLbl.frame), 49)];
    [originalView addSubview:originalLbl];
    
    _originalBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(originalView.frame), CGRectGetHeight(originalView.frame))];
    [_originalBtn setBackgroundColor:[UIColor clearColor]];
    [_originalBtn addTarget:self action:@selector(clickOriginalBtn:) forControlEvents:UIControlEventTouchUpInside];
    [originalView addSubview:_originalBtn];
    
    _photoBytesLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(originalView.frame), (49 - 20) / 2, 80, 20)];
    [_photoBytesLbl setTextColor:[UIColor whiteColor]];
    [_photoBytesLbl setTextAlignment:NSTextAlignmentLeft];
    [_photoBytesLbl setFont:[UIFont systemFontOfSize:14]];
    [_bottomView addSubview:_photoBytesLbl];
    
    UIView *completeView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth - 100, 0, 100, 49)];
    [completeView setBackgroundColor:[UIColor clearColor]];
    [_bottomView addSubview:completeView];
    
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
- (void)clickBack {
    if (self.onSelectedPhotos) {
        self.onSelectedPhotos(self.arraySelectPhotos, self.isSelectOriginalPhoto);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showUpAndDownView {
    [UIView animateWithDuration:0.3 animations:^{
        [self.upView setFrame:CGRectMake(0, 0, kScreenHeight, 50)];
        [self.bottomView setFrame:CGRectMake(0, kScreenHeight - 50, kScreenWidth, 50)];
    }];
}

- (void)hideUpAndDownView {
    [UIView animateWithDuration:0.3 animations:^{
        [self.upView setFrame:CGRectMake(0, -50, kScreenHeight, 50)];
        [self.bottomView setFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 50)];
    }];
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
        [_completeBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_completeBtn setUserInteractionEnabled:NO];
        [_completeBtn setBackgroundColor:CH_RGBColor(220, 220, 220, 1.0)];
    }
}

- (void) changeOriginalStatus {
    if (self.isSelectOriginalPhoto == YES) {
        [_originalBtn setSelected:YES];
        [_inCircleLbl setBackgroundColor:CH_RGBColor(98, 170, 246, 1.0)];
        [_photoBytesLbl setHidden:NO];
        PHAsset *asset = _arrayDataSource[_currentIndex - 1];
        [[WMHPhotoTool sharePhotoTool] getCurrentPhotoBytesWithAsset:asset completion:^(NSString *photosBytes) {
            [self.photoBytesLbl setText:[NSString stringWithFormat:@"(%@)",photosBytes]];
        }];
    }else{
        [_originalBtn setSelected:NO];
        [_photoBytesLbl setHidden:YES];
        [_inCircleLbl setBackgroundColor:[UIColor blackColor]];
    }
}

- (void)clickSelectBtn:(UIButton *)sender {
    if (_arraySelectPhotos.count >= self.maxSelectCount) {
        NSLog(@"最多选择%ld张图片",self.maxSelectCount);
        if (sender.isSelected == YES) {
            
        }else{
            return;
        }
    }
    
    PHAsset *asset = _arrayDataSource[_currentIndex - 1];
    
    if (![self isHaveCurrentPageImage]) {
        [sender.layer addAnimation:GetBtnStatusChangedAnimation() forKey:nil];
        WMHPhotoModel *model = [[WMHPhotoModel alloc] init];
        [model setAsset:asset];
        [model setLocalIdentifier:asset.localIdentifier];
        [model setAlbumId:self.assetCollection.localIdentifier];
        [_arraySelectPhotos addObject:model];
    }else{
        [self removeCurrentPageImage];
    }
    
    [self changeCompleteStatus];
    [sender setSelected:!sender.selected];
}

- (void)completeBtnClick {
    if (self.btnDoneBlock) {
        self.btnDoneBlock(self.arraySelectPhotos, self.isSelectOriginalPhoto);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)changeBtnStatus {
    if ([self isHaveCurrentPageImage]) {
        _selectBtn.selected = YES;
    } else {
        _selectBtn.selected = NO;
    }
}

- (BOOL)isHaveCurrentPageImage
{
    PHAsset *asset = _arrayDataSource[self.currentIndex - 1];
    for (WMHPhotoModel *model in _arraySelectPhotos) {
        if ([model.localIdentifier isEqualToString:asset.localIdentifier]) {
            return YES;
        }
    }
    return NO;
}

- (void)removeCurrentPageImage
{
    PHAsset *asset = _arrayDataSource[_currentIndex - 1];
    for (WMHPhotoModel *model in _arraySelectPhotos) {
        if ([model.localIdentifier isEqualToString:asset.localIdentifier]) {
            [_arraySelectPhotos removeObject:model];
            break;
        }
    }
}

#pragma mark - UICollectionDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _arrayDataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WMHShowBigImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShowBigImageCell" forIndexPath:indexPath];
    PHAsset *asset = _arrayDataSource[indexPath.row];
    [cell setAsset:asset];
    
    weakify(self);
    [cell setSingleTapCallBack:^{
        strongify(weakSelf);
        if (CGRectGetMinY(strongSelf.upView.frame) < 0) {
            [strongSelf showUpAndDownView];
        }else{
            [strongSelf hideUpAndDownView];
        }
    }];
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == (UIScrollView *)_baseCollection) {
        //改变导航标题
        CGFloat page = scrollView.contentOffset.x / kScreenWidth;
        NSString *str = [NSString stringWithFormat:@"%.0f", page];
        _currentIndex = str.integerValue + 1;
        self.title = [NSString stringWithFormat:@"%ld/%ld", _currentIndex, _arrayDataSource.count];
        if (_isSelectOriginalPhoto == YES) {
            PHAsset *asset = _arrayDataSource[_currentIndex - 1];
            [[WMHPhotoTool sharePhotoTool] getCurrentPhotoBytesWithAsset:asset completion:^(NSString *photosBytes) {
                [self.photoBytesLbl setText:[NSString stringWithFormat:@"(%@)",photosBytes]];
            }];
        }
        [self changeBtnStatus];
    }
}

#pragma mark - Lazy
- (UICollectionView *)baseCollection {
    if (!_baseCollection) {
        _baseCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:_baseLayout];
        [_baseCollection setDelegate:self];
        [_baseCollection setDataSource:self];
        [_baseCollection setPagingEnabled:YES];
        [_baseCollection setShowsVerticalScrollIndicator:NO];
        [_baseCollection setShowsHorizontalScrollIndicator:NO];
        [_baseCollection setBackgroundColor:[UIColor blackColor]];
        [_baseCollection registerClass:[WMHShowBigImageCell class] forCellWithReuseIdentifier:@"ShowBigImageCell"];
        if (@available(iOS 11.0, *)) {
            self.baseCollection.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _baseCollection;
}

#pragma mark - Refactor
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
