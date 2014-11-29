//
//  TwitterRequest.h
//  iProps
//
//  Created by Marek Buszman on 29.11.2014.
//  Copyright (c) 2014 Netguru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

typedef void (^onSuccessBlock)(NSArray *users);

@interface TwitterRequest : NSObject
+ (void)getWithURL:(NSURL *)url andParameters:(NSDictionary *)parameters andRequest:(void (^)(NSData *, NSHTTPURLResponse *, NSError *))requestHandler;
+ (void)loadTweetsWithHandler:(void (^)(NSData *, NSHTTPURLResponse *, NSError *))requestHandler;
+ (void)loadUsersOnComplete:(onSuccessBlock)onSuccess;

@end
