//
//  ViewController.m
//  UIClassFactory
//
//  Created by fengzhao on 16/10/16.
//  Copyright © 2016年 fengzhao. All rights reserved.
//

#import "ViewController.h"
#import "FZMediaSourcePickerController.h"
#import "FPSDisplay.h"

@interface ViewController () <FZMediaSourcePickerControllerDelegate>


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [FPSDisplay shareFPSDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    FZMediaSourcePickerController *vc = [[FZMediaSourcePickerController alloc] init];
    vc.maxSelectedCount = 3;
    vc.maxImageSelectedCount = 2;
    vc.maxVideoSelectedCount = 2;
    vc.type = FZMediaSourceTypeAll;
    vc.defaultAlbumName = @"ninth";
    vc.delegate = self;
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)mediaSourcePickerController:(FZMediaSourcePickerController *)picker didFinishPickingAsset:(NSArray<PHAsset *> *)assets
{

}

- (void)mediaSourcePickerControllerDidCancle:(FZMediaSourcePickerController *)picker
{

}

@end
