//
//  FZMediaSourcePreviewCell.m
//  UIClassFactory
//
//  Created by fengzhao on 2017/5/5.
//  Copyright © 2017年 fengzhao. All rights reserved.
//

#import "FZMediaSourcePreviewCell.h"

#import <Photos/Photos.h>

#import "UIImageView+PHAsset.h"

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
    
    [self.imageView fz_setImageWithPHAsset:_asset];
}

@end
