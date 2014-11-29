//
//  TweetModel.m
//  iProps
//
//  Created by Marek Buszman on 29.11.2014.
//  Copyright (c) 2014 Netguru. All rights reserved.
//

#import "TweetModel.h"

@implementation TweetModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"name": @"display_name",
        @"text": @"text"
    };
}


@end
