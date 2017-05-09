//
//  FZMediaSourcePreviewViewController.m
//  UIClassFactory
//
//  Created by fengzhao on 2017/5/4.
//  Copyright © 2017年 fengzhao. All rights reserved.
//

#import "FZMediaSourcePreviewViewController.h"

#import "FZMediaSourcePreviewCell.h"

#import "FZMediaSourceAssetItem.h"

#import "UIImageView+PHAsset.h"

#define CellReuseIdentifier @"FZMediaSourcePreviewViewControllerCellReuseIdentifier"

@interface FZMediaSourcePreviewViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray <FZMediaSourceAssetItem *>*assets;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation FZMediaSourcePreviewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSParameterAssert(self.assets && self.assets.count > 0 && self.indexPath);
    
    self.view.backgroundColor = [UIColor blackColor];
    
    UIImage *rightItemImage = [UIImage imageNamed:@"common_item_selected"];
    
    UIButton *rightItemButton = [[UIButton alloc] init];
    rightItemButton.frame = (CGRect){0 , 0, rightItemImage.size};
    [rightItemButton setBackgroundImage:rightItemImage forState:UIControlStateSelected];
    [rightItemButton setBackgroundImage:[UIImage imageNamed:@"common_item_unselected"] forState:UIControlStateNormal];
    [rightItemButton addTarget:self action:@selector(onRightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemButton];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.pagingEnabled = YES;
    [self.collectionView registerClass:[FZMediaSourcePreviewCell class] forCellWithReuseIdentifier:CellReuseIdentifier];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
#warning 这两行代码需要找到更合适的地方
        [self.collectionView scrollToItemAtIndexPath:_indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        [self scrollViewDidScroll:self.collectionView];
    });
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.collectionView.frame = self.view.bounds;
    ((UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout).itemSize = self.view.bounds.size;
}

- (void)onRightButtonClick:(UIButton *)sender
{
    if (self.rightNavigationItemClickBlock)
    {
        self.rightNavigationItemClickBlock(sender, self.assets[[self.collectionView indexPathForCell:[[self.collectionView visibleCells] firstObject]].item]);
    }
}

- (void)setShowAssetItems:(NSArray <FZMediaSourceAssetItem *>*)assets withIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *array = [NSMutableArray array];
    
    NSObject *currentObj = [assets objectAtIndex:indexPath.row];
    
    for (int i = 0; i < assets.count; i++)
    {
        FZMediaSourceAssetItem *item = assets[i];
        
        if (PHAssetMediaTypeImage == item.asset.mediaType)
        {
            [array addObject:item];
        }
    }
    
    _assets = array;
    
    _indexPath = [NSIndexPath indexPathForRow:[array indexOfObject:currentObj] inSection:0];
    
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FZMediaSourcePreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    cell.asset = self.assets[indexPath.row].asset;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.navigationController.navigationBarHidden = !self.navigationController.navigationBarHidden;
    
    if ([[[NSBundle mainBundle]objectForInfoDictionaryKey:@"UIViewControllerBasedStatusBarAppearance"] boolValue])
    {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    else
    {
        [[UIApplication sharedApplication] setStatusBarHidden:self.navigationController.navigationBarHidden withAnimation:NO];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index = (scrollView.contentOffset.x + self.view.bounds.size.width / 2) / self.view.bounds.size.width;
    
    if (index >= self.assets.count)
    {
        return;
    }
    
    ((UIButton *)self.navigationItem.rightBarButtonItem.customView).selected = self.assets[index].selected;
}

- (BOOL)prefersStatusBarHidden
{
    return self.navigationController.navigationBarHidden;
}

- (void)dealloc
{

}

@end
