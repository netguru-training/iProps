//
//  TweetModel.h
//  iProps
//
//  Created by Marek Buszman on 29.11.2014.
//  Copyright (c) 2014 Netguru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle.h>

@interface TweetModel : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic, readwrite) NSString *name;
@property (strong, nonatomic, readwrite) NSString *text;

@end
