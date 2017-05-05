//
//  FZMediaSourceAssetPickerViewController.m
//  UIClassFactory
//
//  Created by fengzhao on 2017/4/21.
//  Copyright © 2017年 fengzhao. All rights reserved.
//

#import "FZMediaSourceAssetPickerViewController.h"

#import "FZMediaSourcePickerController.h"
#import "FZMediaSourcePreviewViewController.h"
#import "FZMediaSourceVideoPreviewViewController.h"

#import "FZMediaSourceAssetPickerViewCell.h"
#import "FZMediaSourceAssetPickerMenuView.h"

#import "FZMediaSourceAlbum.h"
#import "FZMediaSourceAssetItem.h"

#import "FZMediaSourceAssetService.h"
#import "FZMediaSourceUtil.h"

#define CellReuseIdentifier @"FZMediaSourceAssetPickerViewControllerCellReuseIdentifier"

#define ItemMargin      5.0f
#define NumberOfColumn  4

@interface FZMediaSourceAssetPickerViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) FZMediaSourceAssetPickerMenuView *menuView;
@property (nonatomic, strong) NSArray <FZMediaSourceAssetItem *>*dataList;

@property (nonatomic, assign) NSUInteger selectedVideoCount;
@property (nonatomic, assign) NSUInteger selectedImageCount;

@end

@implementation FZMediaSourceAssetPickerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    __weak typeof(FZMediaSourceAssetPickerViewController *)weakSelf = self;
    FZMediaSourcePickerController *navC = (FZMediaSourcePickerController *)self.navigationController;
    
    CGFloat itemW = (self.view.bounds.size.width - 2 * ItemMargin - (NumberOfColumn - 1) * ItemMargin) / NumberOfColumn;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = ItemMargin;
    layout.minimumInteritemSpacing = ItemMargin;
    layout.itemSize = CGSizeMake(itemW, itemW);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"FZMediaSourceAssetPickerViewCell" bundle:nil] forCellWithReuseIdentifier:CellReuseIdentifier];
    
    [self.view addSubview:self.collectionView];
    
    self.menuView = [[FZMediaSourceAssetPickerMenuView alloc] init];
    self.menuView.editButtonClickBlock = ^(FZMediaSourceAssetPickerMenuView *menuView) {
        
    };
    self.menuView.previewButtonClickBlock = ^(FZMediaSourceAssetPickerMenuView *menuView) {
        
        NSMutableArray *array = [NSMutableArray array];
        
        for (int i = 0; i < self.dataList.count; i++)
        {
            if (weakSelf.dataList[i].selected)
            {
                [array addObject:weakSelf.dataList[i]];
            }
        }
        
        FZMediaSourcePreviewViewController *previewVC = [weakSelf createPreview];
        
        [previewVC setShowAssetItems:array withIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        
        [weakSelf.navigationController pushViewController:previewVC animated:YES];
    };
    self.menuView.decideButtonClickBlock = ^(FZMediaSourceAssetPickerMenuView *menuView) {
        
        if ([navC.delegate respondsToSelector:@selector(mediaSourcePickerController:didFinishPickingAsset:)])
        {
            NSMutableArray *resultList = [NSMutableArray array];
            
            for (int i = 0; i < weakSelf.dataList.count; i ++)
            {
                if (weakSelf.dataList[i].selected)
                {
                    [resultList addObject:weakSelf.dataList[i].asset];
                }
            }
            
            [navC.delegate mediaSourcePickerController:navC didFinishPickingAsset:resultList];
        }
    };
    
    [self.view addSubview:self.menuView];
    
    [FZMediaSourceAssetService loadAssetsWithAlbum:self.album.album type:navC.type thumbnailImageSize:CGSizeMake(30, 30) completionHandler:^(NSArray<FZMediaSourceAssetItem *> *dataList) {
       
        weakSelf.dataList = dataList;
        [weakSelf.collectionView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    for (FZMediaSourceAssetPickerViewCell *cell in self.collectionView.visibleCells)
    {
        cell.assetItem = cell.assetItem;
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.collectionView.frame = CGRectMake(ItemMargin, 0, self.view.bounds.size.width - 2 * ItemMargin, self.view.bounds.size.height - 44);
    
    self.menuView.frame = CGRectMake(0, CGRectGetMaxY(self.collectionView.frame), self.view.bounds.size.width, 44);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(FZMediaSourceAssetPickerViewController *)weakSelf = self;
    
    FZMediaSourceAssetPickerViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    cell.assetItem = self.dataList[indexPath.row];
    cell.selectButtonClickBlock = ^(FZMediaSourceAssetPickerViewCell *cell) {
      
        if (!cell.assetItem.canSelect)
        {
            return;
        }
        
        if (cell.assetItem.isSelected)
        {
            [weakSelf willDeselectItem:cell.assetItem];
        }
        else
        {
            [weakSelf willSelectItem:cell.assetItem];
        }
        
        [self changeSelectEnable];
        
        [weakSelf.menuView editEnable:weakSelf.selectedVideoCount == 0 && weakSelf.selectedImageCount == 1];
        [weakSelf.menuView previewEnable:weakSelf.selectedImageCount > 0 && weakSelf.selectedVideoCount == 0];
        [weakSelf.menuView decideEnable:weakSelf.selectedImageCount + weakSelf.selectedVideoCount > 0 count:weakSelf.selectedImageCount + weakSelf.selectedVideoCount];
        
        cell.assetItem = cell.assetItem;
    };
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc = nil;
    
    if (PHAssetMediaTypeVideo == self.dataList[indexPath.row].asset.mediaType)
    {
        vc = [[FZMediaSourceVideoPreviewViewController alloc] init];
        ((FZMediaSourceVideoPreviewViewController *)vc).asset = self.dataList[indexPath.row].asset;
    }
    else
    {
        FZMediaSourcePreviewViewController *previewVC = [self createPreview];
        [previewVC setShowAssetItems:self.dataList withIndexPath:indexPath];
        vc = previewVC;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)willSelectItem:(FZMediaSourceAssetItem *)item
{
    BOOL success = NO;
    
    FZMediaSourcePickerController *navC = (FZMediaSourcePickerController *)self.navigationController;
    
    if (self.selectedVideoCount + self.selectedImageCount >= navC.maxSelectedCount)
    {
        success =  NO;
    }
    else if (PHAssetMediaTypeImage == item.asset.mediaType && self.selectedImageCount >= navC.maxImageSelectedCount)
    {
        success =  NO;
    }
    else if (PHAssetMediaTypeVideo == item.asset.mediaType && self.selectedVideoCount >= navC.maxVideoSelectedCount)
    {
        success =  NO;
    }
    else
    {
        success = YES;
        
        item.selected = YES;
        
        if (PHAssetMediaTypeVideo == item.asset.mediaType)
        {
            self.selectedVideoCount++;
        }
        else if (PHAssetMediaTypeImage == item.asset.mediaType)
        {
            self.selectedImageCount++;
        }
    }
    
    if (!success)
    {
        [self showAlertViewWithTitle:@"" cancleTitle:@""];
    }
    
    return success;
}

- (void)willDeselectItem:(FZMediaSourceAssetItem *)item
{
    item.selected = NO;
    
    if (PHAssetMediaTypeVideo == item.asset.mediaType)
    {
        self.selectedVideoCount--;
    }
    else if (PHAssetMediaTypeImage == item.asset.mediaType)
    {
        self.selectedImageCount--;
    }
}

- (void)changeSelectEnable
{
    FZMediaSourcePickerController *navC = (FZMediaSourcePickerController *)self.navigationController;
    
    if (self.selectedImageCount + self.selectedVideoCount >= navC.maxSelectedCount)
    {
        for (int i = 0; i < self.dataList.count; i ++)
        {
            self.dataList[i].canSelect = self.dataList[i].selected;
        }
        
        for (int i = 0; i < self.collectionView.visibleCells.count; i ++)
        {
            FZMediaSourceAssetPickerViewCell *cell = (FZMediaSourceAssetPickerViewCell *)self.collectionView.visibleCells[i];
            cell.assetItem = cell.assetItem;
        }
    }
    else if (self.selectedImageCount >= navC.maxImageSelectedCount)
    {
        for (int i = 0; i < self.dataList.count; i++)
        {
            self.dataList[i].canSelect = self.dataList[i].selected || self.dataList[i].asset.mediaType == PHAssetMediaTypeVideo;
        }
        for (int i = 0; i < self.collectionView.visibleCells.count; i ++)
        {
            FZMediaSourceAssetPickerViewCell *cell = (FZMediaSourceAssetPickerViewCell *)self.collectionView.visibleCells[i];
            cell.assetItem = cell.assetItem;
        }
    }
    else if (self.selectedVideoCount >= navC.maxVideoSelectedCount)
    {
        for (int i = 0; i < self.dataList.count; i++)
        {
            self.dataList[i].canSelect = self.dataList[i].selected || self.dataList[i].asset.mediaType == PHAssetMediaTypeImage;
        }
        for (int i = 0; i < self.collectionView.visibleCells.count; i ++)
        {
            FZMediaSourceAssetPickerViewCell *cell = (FZMediaSourceAssetPickerViewCell *)self.collectionView.visibleCells[i];
            cell.assetItem = cell.assetItem;
        }
    }
    else
    {
        for (int i = 0; i < self.dataList.count; i++)
        {
            self.dataList[i].canSelect = YES;
        }
        for (int i = 0; i < self.collectionView.visibleCells.count; i ++)
        {
            FZMediaSourceAssetPickerViewCell *cell = (FZMediaSourceAssetPickerViewCell *)self.collectionView.visibleCells[i];
            cell.assetItem = cell.assetItem;
        }
    }
}

- (void)showAlertViewWithTitle:(NSString *)title cancleTitle:(NSString *)cancleTitle
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:title preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:cancleTitle style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (FZMediaSourcePreviewViewController *)createPreview
{
    __weak typeof(FZMediaSourceAssetPickerViewController *)weakSelf = self;

    FZMediaSourcePreviewViewController *preview = [[FZMediaSourcePreviewViewController alloc] init];
    
    preview.rightNavigationItemClickBlock = ^BOOL(UIButton *sender, FZMediaSourceAssetItem *currentItem) {
        
        if (sender.selected)
        {
            [weakSelf willDeselectItem:currentItem];
        }
        else
        {
            BOOL success = [weakSelf willSelectItem:currentItem];
            
            if (!success)
            {
                return NO;
            }
        }
        
        sender.selected = currentItem.selected;
        
        return YES;
    };

    return preview;
}

@end
