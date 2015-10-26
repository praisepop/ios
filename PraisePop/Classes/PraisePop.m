//
//  PraisePop.m
//  PraisePop
//
//  Created by Rudd Fawcett on 10/5/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import "PraisePop.h"

#import "PPUser.h"

#import "PPOrganization.h"

#import <SSKeychain/SSKeychain.h>

@implementation PraisePop

static NSString * const kPraisePopTokenKey = @"PRAISE_POP_TOKEN_KEY";
static NSString * const kPraisePopAccountKey = @"PRAISE_POP_ACCOUNT_KEY";
static NSString * const kPraisePopOrganizationsKey = @"PRAISE_POP_ORGANIZATIONS_KEY";
static NSString * const kPraisePopService = @"PraisePop";

+ (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *_sharedDateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDateFormatter = NSDateFormatter.new;
    });
    
    return _sharedDateFormatter;
}

+ (UIViewController *)controllerWithIdentifier:(NSString *)identifier {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:NSBundle.mainBundle];
    
    return [storyboard instantiateViewControllerWithIdentifier:identifier];
}

+ (void)saveToken:(NSString *)token email:(NSString *)email {
    [SSKeychain setPassword:token forService:kPraisePopService account:email];
}

+ (NSString *)userToken {
    return [SSKeychain passwordForService:kPraisePopService account:PraisePop.currentUser.email];
}

+ (void)destorySession {
    [SSKeychain deletePasswordForService:kPraisePopService account:PraisePop.currentUser.email];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dictionary = [defaults dictionaryRepresentation];
    for (id key in dictionary) {
        [defaults removeObjectForKey:key];
    }
    
    [defaults synchronize];
}

+ (void)saveOrganizations:(NSArray *)organizations {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:organizations];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:kPraisePopOrganizationsKey];
    [defaults synchronize];
}

+ (void)saveUserAccount:(PPUser *)user {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:user];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:kPraisePopAccountKey];
    [defaults synchronize];
}

+ (PPUser *)currentUser {
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([currentDefaults objectForKey:kPraisePopAccountKey]) {
        NSData *savedOrganizations = [currentDefaults objectForKey:kPraisePopAccountKey];
        PPUser *user = [NSKeyedUnarchiver unarchiveObjectWithData:savedOrganizations];
        
        return user;
    }
    
    return nil;
}

+ (PPOrganization *)parentOrganization {
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    NSData *savedOrganizations = [currentDefaults objectForKey:kPraisePopOrganizationsKey];
    NSArray *organizations = [NSKeyedUnarchiver unarchiveObjectWithData:savedOrganizations];
    
    for (PPOrganization *organization in organizations) {
        if (organization.parent) {
            return organization;
        }
    }
    
    return nil;
}

@end
