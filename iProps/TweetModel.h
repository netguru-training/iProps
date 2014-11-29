//
//  TweetModel.h
//  iProps
//
//  Created by Marek Buszman on 29.11.2014.
//  Copyright (c) 2014 Netguru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle.h>
#import "UserModel.h"

@interface TweetModel : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic, readonly) NSString *text;
@property (strong, nonatomic, readonly) UserModel *user;

@end
