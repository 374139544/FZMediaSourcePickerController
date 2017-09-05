//
//  FZMediaSourceAssetPickerViewCell.m
//  UIClassFactory
//
//  Created by fengzhao on 2017/4/21.
//  Copyright © 2017年 fengzhao. All rights reserved.
//

#import <Photos/Photos.h>

#import "FZMediaSourceAssetPickerViewCell.h"

#import "FZMediaSourceAssetItem.h"

#import "UIImageView+FZPHAsset.h"

@interface FZMediaSourceAssetPickerViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIImageView *videoIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *videoDurationLabel;
@property (weak, nonatomic) IBOutlet UIView *whiteView;

@end

@implementation FZMediaSourceAssetPickerViewCell

- (void)setAssetItem:(FZMediaSourceAssetItem *)assetItem
{
    _assetItem = assetItem;
    
    self.videoIconImageView.hidden = (PHAssetMediaTypeImage == _assetItem.asset.mediaType);
    self.videoDurationLabel.hidden = (PHAssetMediaTypeImage == _assetItem.asset.mediaType);
    self.selectButton.hidden = !_assetItem.isSelected && !_assetItem.canSelect;
    self.whiteView.hidden = self.assetItem.canSelect;
    
    self.selectButton.selected = _assetItem.isSelected;
    
    [self.backgroundImageView fz_setThumbnailImageWithPHAsset:_assetItem.asset thumbnailImageSize:CGSizeMake(100, 100)];
    self.videoDurationLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)_assetItem.asset.duration / 60, (int)_assetItem.asset.duration % 60];
}

- (IBAction)selectButtonClick:(UIButton *)sender
{
    if (self.selectButtonClickBlock)
    {
        self.selectButtonClickBlock(self);
    }
}

@end
