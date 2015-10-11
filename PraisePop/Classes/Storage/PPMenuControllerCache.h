//
//  PPMenuControllerCache.h
//  PraisePop
//
//  Created by Rudd Fawcett on 10/7/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kPPTimelineCacheKey;
extern NSString * const kPPMoreCacheKey;

@interface PPMenuControllerCache : NSObject

+ (instancetype)sharedCache;

- (void)addControllerToCache:(UIViewController *)controller withKey:(NSString *)key;

- (void)removeControllerFromCache:(NSString *)key;

@property (strong, nonatomic) NSMutableDictionary *cache;

@end
