//
//  UserModel.h
//  iProps
//
//  Created by netguru on 29/11/14.
//  Copyright (c) 2014 Netguru. All rights reserved.
//

#ifndef iProps_UserModel_h
#define iProps_UserModel_h

#endif

#import <MTLModel.h>
#import <MTLJSONAdapter.h>

@interface UserModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString *twitterUsername;
@property (nonatomic, copy, readonly) NSString *fullName;
@property (nonatomic, copy, readonly) NSURL *profileImageUrl;

@end