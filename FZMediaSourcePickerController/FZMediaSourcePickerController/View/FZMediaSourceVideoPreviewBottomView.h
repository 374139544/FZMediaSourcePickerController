//
//  FZMediaSourceVideoPreviewBottomView.h
//  FZMediaSourcePickerController
//
//  Created by fengzhao on 2017/5/9.
//  Copyright © 2017年 personal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FZMediaSourceVideoPreviewBottomView : UIView

@property (nonatomic, copy) void(^editButtonClickBlock)();
@property (nonatomic, copy) void(^decideButtonClickBlock)();

@end
