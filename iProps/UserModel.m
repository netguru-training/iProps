//
//  UserModel.m
//  iProps
//
//  Created by netguru on 29/11/14.
//  Copyright (c) 2014 Netguru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@implementation UserModel : MTLModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"twitterUsername": @"???",
             @"fullName": @"???",
             @"profileImageUrl":@"???",
             };
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self == nil) return nil;
    
    return self;
}

@end