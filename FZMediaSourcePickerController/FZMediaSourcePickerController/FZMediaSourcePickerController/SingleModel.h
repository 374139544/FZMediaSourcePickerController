//
//  Header.h
//  数据同步存储
//
//  Created by fengzhao on 16/9/2.
//  Copyright © 2016年 fengzhao. All rights reserved.
//

#ifndef SingleModel_h
#define SingleModel_h

#define SingleModelInterface                            \
                                                        \
+ (instancetype)shareInstance;


#define SingleModelImplementation                       \
                                                        \
static id instance;                                     \
                                                        \
+ (instancetype)shareInstance                           \
{                                                       \
    return [[self alloc] init];                         \
}                                                       \
                                                        \
+ (instancetype)allocWithZone:(struct _NSZone *)zone    \
{                                                       \
    static dispatch_once_t onceToken;                   \
    dispatch_once(&onceToken, ^{                        \
        instance = [super allocWithZone:zone];          \
    });                                                 \
    return instance;                                    \
}                                                       \
                                                        \
- (id)copyWithZone:(NSZone *)zone                       \
{                                                       \
    return instance;                                    \
}                                                       \
                                                        \
- (id)mutableCopyWithZone:(NSZone *)zone                \
{                                                       \
    return instance;                                    \
}


#endif /* SingleModel_h */
