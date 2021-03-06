//
//  PraisePop.m
//  PraisePop
//
//  Created by Rudd Fawcett on 10/5/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import <Parse/Parse.h>
#import <Instabug/Instabug.h>
#import <SSKeychain/SSKeychain.h>

#import "PPUser.h"
#import "PPOrganization.h"
#import "PPAuthentication.h"

#import "PraisePop.h"

@interface PraisePop ()

@property (nonatomic) NSArray *animationImages;

@property (nonatomic) NSString *userToken;

@end

@implementation PraisePop

static NSString * const kPraisePopTokenKey = @"PRAISE_POP_TOKEN";
static NSString * const kPraisePopAccountKey = @"PRAISE_POP_ACCOUNT";
static NSString * const kPraisePopPasswordKey = @"PRAISE_POP_ACCOUNT_PASSWORD";
static NSString * const kPraisePopEmailKey = @"PRAISE_POP_ACCOUNT_EMAIL";
static NSString * const kPraisePopOrganizationsKey = @"PRAISE_POP_ORGANIZATIONS_KEY";
static NSString * const kPraisePopService = @"PraisePop";

+ (instancetype)shared {
    static PraisePop *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = PraisePop.new;
        [_shared animationImages];
    });
    
    return _shared;
}

+ (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *_sharedDateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDateFormatter = NSDateFormatter.new;
        _sharedDateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
    });
    
    return _sharedDateFormatter;
}

- (NSArray *)animationImages {
    return !_animationImages ? _animationImages = ({
        NSMutableArray *images = NSMutableArray.array;
        
        for (int i = 0; i < 44; i ++) {
            [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"pop-%d", i]]];
        }
        
        images;
    }) : _animationImages;
}

+ (BOOL)save:(PPAuthentication *)authentication {
    BOOL saveToken = [[PraisePop shared] saveToken:authentication.token email:authentication.user.email];
    
    if (!saveToken) {
        return NO;
    }
    
    [PraisePop saveOrganizations:authentication.user.organizations];
    [PraisePop saveUserAccount:authentication.user];
    
    [Instabug setDefaultEmail:authentication.user.email];
    [Instabug setWillShowEmailField:NO];
    [Instabug setUserData:authentication.user._id];
    
    return YES;
}

- (BOOL)saveToken:(NSString *)token email:(NSString *)email {
    BOOL result = [SSKeychain setPassword:token forService:kPraisePopService account:kPraisePopTokenKey];
    
    if (result) {
        _userToken = token;
    }
    
    return result;
}

+ (void)savePassword:(NSString *)password email:(NSString *)email {
    [SSKeychain setPassword:password forService:kPraisePopService account:email];
}

- (NSString *)userToken {
    return !_userToken  ? _userToken = ({
        NSString *result = [SSKeychain passwordForService:kPraisePopService account:kPraisePopTokenKey];
        if (result.length == 0) {
            result = @"";
        }
        
        result;
    }) : _userToken;
}

+ (void)destorySession {
    [Instabug setDefaultEmail:nil];
    [Instabug setWillShowEmailField:YES];
    [Instabug setUserData:nil];
    
    [SSKeychain deletePasswordForService:kPraisePopService account:kPraisePopTokenKey];
    [SSKeychain deletePasswordForService:kPraisePopService account:PraisePop.currentUser.email];
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    currentInstallation.channels = [NSArray array];
    [currentInstallation saveEventually];
    
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

+ (PPOrganization *)childOrganization {
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    NSData *savedOrganizations = [currentDefaults objectForKey:kPraisePopOrganizationsKey];
    NSArray *organizations = [NSKeyedUnarchiver unarchiveObjectWithData:savedOrganizations];
    
    for (PPOrganization *organization in organizations) {
        if (!organization.parent) {
            return organization;
        }
    }
    
    return nil;
}

@end
