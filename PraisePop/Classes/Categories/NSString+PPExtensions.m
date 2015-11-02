//
//  NSString+PPExtensions.m
//  
//
//  Created by Rudd Fawcett on 11/1/15.
//
//

#import "NSString+PPExtensions.h"

@implementation NSString (PPExtensions)

+ (NSString *)pp_addressString:(NSString *)name {
    return [NSString stringWithFormat:@"To %@,", name];
}

+ (NSString *)pp_dateString:(NSString *)date {
    return [NSString stringWithFormat:@"%@ ago", date];
}

@end
