//
//  PPPost.h
//  PraisePop
//
//  Created by Rudd Fawcett on 10/4/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPPost : NSObject

- (id)initWithAttributes:(NSDictionary *)attributes;

@property (strong, nonatomic) NSString *body;

@end
