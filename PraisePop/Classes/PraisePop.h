//
//  PraisePop.h
//  PraisePop
//
//  Created by Rudd Fawcett on 10/5/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

@class PPOrganization;
@class PPUser;

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PraisePop : NSObject

+ (NSDateFormatter *)dateFormatter;

+ (void)saveUserAccount:(PPUser *)user;
+ (void)saveOrganizations:(NSArray *)organizations;
+ (void)saveToken:(NSString *)token email:(NSString *)email;

+ (NSString *)userToken;

+ (PPUser *)currentUser;

+ (PPOrganization *)parentOrganization;
+ (PPOrganization *)childOrganization;

+ (void)destorySession;

@end
