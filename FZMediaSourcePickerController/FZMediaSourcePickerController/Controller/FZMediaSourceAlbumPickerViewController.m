//
//  FZMediaSourceAlbumPickerViewController.m
//  UIClassFactory
//
//  Created by fengzhao on 2017/4/20.
//  Copyright © 2017年 fengzhao. All rights reserved.
//

#import "FZMediaSourceAlbumPickerViewController.h"

#import "FZMediaSourcePickerController.h"

#import "FZMediaSourceAlbumPickerViewCell.h"

#import "FZMediaSourceAlbum.h"

#import "FZMediaSourceUtil.h"
#import "FZMediaSourceAlbumService.h"

#import "FZMediaSourceAssetPickerViewController.h"

#define CellReuseIdentifier @"FZMediaSourceAlbumPickerViewControllerCellReuseIdentifier"

@interface FZMediaSourceAlbumPickerViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray <FZMediaSourceAlbum *>*dataList;

@property (nonatomic, assign) BOOL isReappear;

@end

@implementation FZMediaSourceAlbumPickerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableView registerNib:[UINib nibWithNibName:@"FZMediaSourceAlbumPickerViewCell" bundle:nil] forCellReuseIdentifier:CellReuseIdentifier];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    
    [self.view addSubview:self.tableView];
    
    [FZMediaSourceAlbumService loadAlbumsWithType:((FZMediaSourcePickerController *)self.navigationController).type thumbnailImageSize:CGSizeMake(100, 100) completionHandler:^(NSArray<FZMediaSourceAlbum *> *albums) {
        
        self.dataList = albums;
        [self.tableView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.isReappear)
    {
        self.isReappear = YES;
        
        FZMediaSourcePickerController *navC = (FZMediaSourcePickerController *)self.navigationController;
        
        if (!navC.defaultAlbumName || [navC.defaultAlbumName isEqualToString:@""])
        {
            return;
        }
        
        if (![FZMediaSourceUtil fetchAlbumWithName:navC.defaultAlbumName])
        {
            return;
        }
        
        FZMediaSourceAlbum *album = [FZMediaSourceAlbum new];
        
        album.album = [FZMediaSourceUtil fetchAlbumWithName:navC.defaultAlbumName];
        
        FZMediaSourceAssetPickerViewController *vc = [FZMediaSourceAssetPickerViewController new];
        vc.album = album;
    
        [navC pushViewController:vc animated:NO];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.tableView.frame = self.view.bounds;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FZMediaSourceAlbumPickerViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellReuseIdentifier];
    cell.album = self.dataList[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FZMediaSourceAssetPickerViewController *vc = [FZMediaSourceAssetPickerViewController new];
    vc.album = self.dataList[indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
