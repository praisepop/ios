//
//  PPMenuControllerCache.m
//  PraisePop
//
//  Created by Rudd Fawcett on 10/7/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import "PPMenuControllerCache.h"

@implementation PPMenuControllerCache

+ (instancetype)sharedCache {
    static PPMenuControllerCache *_sharedCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedCache = self.new;
        _sharedCache.cache = [NSMutableDictionary dictionary];
    });
    
    return _sharedCache;
}

- (void)addControllerToCache:(UIViewController *)controller withKey:(NSString *)key {
    [self.cache setObject:controller forKey:key];
}

@end
