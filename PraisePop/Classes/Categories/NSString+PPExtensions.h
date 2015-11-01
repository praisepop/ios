//
//  NSString+PPExtensions.h
//  
//
//  Created by Rudd Fawcett on 11/1/15.
//
//

#import <Foundation/Foundation.h>

@interface NSString (PPExtensions)

/**
 *  Returns a formatted address string.
 *
 *  @param name The addressee.
 *
 *  @return The address string.
 */
+ (NSString *)pp_addressString:(NSString *)name;
/**
 *  Returns a formatted short date string.
 *
 *  @param date The date string.
 *
 *  @return The formatted string.
 */
+ (NSString *)pp_dateString:(NSString *)date;

@end
