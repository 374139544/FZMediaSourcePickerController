//
//  FZMediaSourceAssetPickerMenuView.m
//  UIClassFactory
//
//  Created by fengzhao on 2017/5/4.
//  Copyright © 2017年 fengzhao. All rights reserved.
//

#import "FZMediaSourceAssetPickerMenuView.h"

@interface FZMediaSourceAssetPickerMenuView ()
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *previewButton;
@property (weak, nonatomic) IBOutlet UIButton *okButton;

@end
IB_DESIGNABLE
@implementation FZMediaSourceAssetPickerMenuView

- (instancetype)init
{
    return [[NSBundle mainBundle] loadNibNamed:@"FZMediaSourceAssetPickerMenuView" owner:self options:nil][0];
}

- (IBAction)editButtonClick
{
    if (_editButtonClickBlock)
    {
        _editButtonClickBlock(self);
    }
}

- (IBAction)perviewButtonClick
{
    if (_previewButtonClickBlock)
    {
        _previewButtonClickBlock(self);
    }
}

- (IBAction)okButtonClick
{
    if (_decideButtonClickBlock)
    {
        _decideButtonClickBlock(self);
    }
}

- (void)previewEnable:(BOOL)enable
{
    self.previewButton.enabled = enable;
}

- (void)editEnable:(BOOL)enable
{
    self.editButton.enabled = enable;
}

- (void)decideEnable:(BOOL)enable count:(NSUInteger)count
{
    if (count == 0)
    {
        enable = NO;
        
        [self editEnable:enable];
        [self previewEnable:enable];
    }
    
    self.okButton.enabled = enable;
    
    if (enable)
    {
        [self.okButton setTitle:[NSString stringWithFormat:@"%@(%lu)", NSLocalizedString(@"确定", nil), (unsigned long)count] forState:UIControlStateNormal];
    }
    else
    {
        [self.okButton setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
    }
}

@end
