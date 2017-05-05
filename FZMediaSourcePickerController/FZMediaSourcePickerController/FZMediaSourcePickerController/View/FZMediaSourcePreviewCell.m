//
//  FZMediaSourcePreviewCell.m
//  UIClassFactory
//
//  Created by fengzhao on 2017/5/5.
//  Copyright © 2017年 fengzhao. All rights reserved.
//

#import "FZMediaSourcePreviewCell.h"

#import <Photos/Photos.h>

@interface FZMediaSourcePreviewCell ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, assign) CGFloat touchBeginX;

@end

@implementation FZMediaSourcePreviewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.imageView = [[UIImageView alloc] init];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
}

- (void)setAsset:(PHAsset *)asset
{
    _asset = asset;
    
    [[PHImageManager defaultManager] requestImageDataForAsset:_asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
       
        self.imageView.image = [UIImage imageWithData:imageData];
    }];
}

@end
