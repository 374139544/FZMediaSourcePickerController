//
//  FZMediaSourceAlbumPickerViewCell.m
//  UIClassFactory
//
//  Created by fengzhao on 2017/4/20.
//  Copyright © 2017年 fengzhao. All rights reserved.
//

#import "FZMediaSourceAlbumPickerViewCell.h"

#import <Photos/Photos.h>

#import "FZMediaSourceAlbum.h"

#import "FZMediaSourceAlbumNameInternationalizationService.h"

@interface FZMediaSourceAlbumPickerViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation FZMediaSourceAlbumPickerViewCell

- (void)setAlbum:(FZMediaSourceAlbum *)album
{
    _album = album;
    
    self.leftImageView.image = album.image;
    self.nameLabel.text = [[FZMediaSourceAlbumNameInternationalizationService shareInstance] getInternationalizationStringWithText:_album.album.localizedTitle];
    self.countLabel.text = [NSString stringWithFormat:@"(%lu)", (unsigned long)album.count];
}

@end
