//
//  PPMenuControllerCache.h
//  PraisePop
//
//  Created by Rudd Fawcett on 10/7/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  The timeline controller cache key.
 */
extern NSString * const kPPTimelineCacheKey;
/**
 *  The more controller cache key.
 */
extern NSString * const kPPMoreCacheKey;

@interface PPMenuControllerCache : NSObject

#pragma mark - Singleton

/**
 *  A menu cache singleton.
 *
 *  @return A new PPMenuControllerCache.
 */
+ (instancetype)sharedCache;

#pragma mark - Properties

/**
 *  The cache dictionary, keys and controllers.
 */
@property (strong, nonatomic) NSMutableDictionary *cache;

#pragma mark - Methods

/**
 *  Adds a controller to the cache, in order to prevent reloading, etc.
 *
 *  @param controller The controller object.
 *  @param key        The controller identifier.
 */
- (void)addControllerToCache:(UIViewController *)controller withKey:(NSString *)key;
/**
 *  Removes a controller from the cache.
 *
 *  @param key The controller identifier.
 */
- (void)removeControllerFromCache:(NSString *)key;

@end
