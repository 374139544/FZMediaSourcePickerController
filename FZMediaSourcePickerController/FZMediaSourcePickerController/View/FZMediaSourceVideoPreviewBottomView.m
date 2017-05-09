//
//  FZMediaSourceVideoPreviewBottomView.m
//  FZMediaSourcePickerController
//
//  Created by fengzhao on 2017/5/9.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "FZMediaSourceVideoPreviewBottomView.h"

@implementation FZMediaSourceVideoPreviewBottomView

- (instancetype)init
{
    return [[NSBundle mainBundle] loadNibNamed:@"FZMediaSourceVideoPreviewBottomView" owner:nil options:nil][0];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {}

- (IBAction)editButtonClick
{
    if (_editButtonClickBlock)
    {
        _editButtonClickBlock();
    }
}

- (IBAction)decideButtonClick
{
    if (_decideButtonClickBlock)
    {
        _decideButtonClickBlock();
    }
}

@end
