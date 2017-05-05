//
//  FZMediaSourceAlbumName InternationalizationService.m
//  UIClassFactory
//
//  Created by fengzhao on 2017/5/4.
//  Copyright © 2017年 fengzhao. All rights reserved.
//

#import "FZMediaSourceAlbumNameInternationalizationService.h"

@interface FZMediaSourceAlbumNameInternationalizationService ()

@property (nonatomic, strong) NSMutableDictionary *configDict;

@end

@implementation FZMediaSourceAlbumNameInternationalizationService

SingleModelImplementation

- (NSString *)getInternationalizationStringWithText:(NSString *)text
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    
    NSString *resultString = self.configDict[text][[languages objectAtIndex:0]];
    
    if (!resultString)
    {
        resultString = text;
    }
    
    return resultString;
}

- (NSMutableDictionary *)configDict
{
    if (!_configDict)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"FZAlbumLocalizedString" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:path]];
        _configDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    }
    return _configDict;
}

- (void)clear
{
    self.configDict = nil;
}

@end
