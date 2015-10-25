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

+ (UIViewController *)controllerWithIdentifier:(NSString *)identifier;

+ (NSString *)userToken;

+ (void)destorySession;

+ (void)saveToken:(NSString *)token email:(NSString *)email;

+ (PPUser *)currentUser;
+ (void)saveUserAccount:(PPUser *)user;

+ (void)saveOrganizations:(NSArray *)organizations;

+ (NSString *)parentOrganizationID;

@end
