//
//  FZMediaSourceAlbumNameInternationalizationService.h
//  UIClassFactory
//
//  Created by fengzhao on 2017/5/4.
//  Copyright © 2017年 fengzhao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SingleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FZMediaSourceAlbumNameInternationalizationService : NSObject

SingleModelInterface

- (NSString *)getInternationalizationStringWithText:(NSString *)text;

- (void)clear;

@end

NS_ASSUME_NONNULL_END
