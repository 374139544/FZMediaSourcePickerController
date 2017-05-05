//
//  FZMediaSourcePickerController.m
//  UIClassFactory
//
//  Created by fengzhao on 2017/4/20.
//  Copyright © 2017年 fengzhao. All rights reserved.
//

#import "FZMediaSourcePickerController.h"

#import "FZMediaSourceAlbumPickerViewController.h"

#import "FZMediaSourceAlbumNameInternationalizationService.h"
#import "FZMediaSourceThumbnailImageManager.h"

@interface FZMediaSourcePickerController ()

@end

@implementation FZMediaSourcePickerController

@synthesize delegate = _delegate;

- (instancetype)init
{
    FZMediaSourceAlbumPickerViewController *vc = [FZMediaSourceAlbumPickerViewController new];
    
    if (self = [super initWithRootViewController:vc])
    {
        
    }
    return self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Canale", nil) style:UIBarButtonItemStyleDone target:self action:@selector(onCancle)];
    
    [super pushViewController:viewController animated:animated];
}

- (void)onCancle
{
    [[FZMediaSourceThumbnailImageManager shareInstance] clearAllCache];
    [[FZMediaSourceAlbumNameInternationalizationService shareInstance] clear];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
