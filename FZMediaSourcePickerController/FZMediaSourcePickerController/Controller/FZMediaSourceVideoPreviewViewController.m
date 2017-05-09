//
//  FZMediaSourceVideoPreviewViewController.m
//  UIClassFactory
//
//  Created by fengzhao on 2017/5/5.
//  Copyright © 2017年 fengzhao. All rights reserved.
//

#import "FZMediaSourceVideoPreviewViewController.h"

#import <Photos/Photos.h>

#import "FZMediaSourceVideoPreviewBottomView.h"

@interface FZMediaSourceVideoPreviewViewController ()

@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) FZMediaSourceVideoPreviewBottomView *bottomView;

@end

@implementation FZMediaSourceVideoPreviewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSParameterAssert(self.asset);
    
    self.view.backgroundColor = [UIColor blackColor];

    self.playerLayer = [AVPlayerLayer layer];
    [self.view.layer addSublayer:self.playerLayer];
    
    self.bottomView = [[FZMediaSourceVideoPreviewBottomView alloc] init];
    self.bottomView.editButtonClickBlock = ^{
        
    };
    self.bottomView.decideButtonClickBlock = ^{
        
    };
    [self.view addSubview:self.bottomView];
    
    [[PHImageManager defaultManager] requestAVAssetForVideo:self.asset options:nil resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
            AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
            self.playerLayer.player = player;
            
            __weak typeof(FZMediaSourceVideoPreviewViewController *)weakSelf = self;
            
            [[NSNotificationCenter defaultCenter] addObserverForName:AVPlayerItemDidPlayToEndTimeNotification object:playerItem queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
                
                [weakSelf.playerLayer.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
                    
                    [weakSelf touchesEnded:[NSSet set] withEvent:nil];
                }];
            }];
        });
    }];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.playerLayer.frame = self.view.bounds;
    self.bottomView.frame = CGRectMake(0, self.view.bounds.size.height - 44, self.view.bounds.size.width, 44);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.navigationController.navigationBarHidden)
    {
        [self.playerLayer.player pause];
    }
    else
    {
        [self.playerLayer.player play];
    }
    
    self.navigationController.navigationBarHidden = !self.navigationController.navigationBarHidden;
    self.bottomView.hidden = self.navigationController.navigationBarHidden;
    
    if ([[[NSBundle mainBundle]objectForInfoDictionaryKey:@"UIViewControllerBasedStatusBarAppearance"] boolValue])
    {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    else
    {
        [[UIApplication sharedApplication] setStatusBarHidden:self.navigationController.navigationBarHidden withAnimation:NO];
    }
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {}

- (BOOL)prefersStatusBarHidden
{
    return self.navigationController.navigationBarHidden;
}

- (void)dealloc
{
    [self.playerLayer removeFromSuperlayer];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
