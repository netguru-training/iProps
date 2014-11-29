//
//  TwitterRequest.m
//  iProps
//
//  Created by Marek Buszman on 29.11.2014.
//  Copyright (c) 2014 Netguru. All rights reserved.
//

#import "TwitterRequest.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@implementation TwitterRequest

+ (void)getWithURL:(NSURL *)url andParameters:(NSDictionary *)parameters andRequest:(void (^)(NSData *, NSHTTPURLResponse *, NSError *))requestHandler
{
    ACAccountStore *account = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];

    [account requestAccessToAccountsWithType:accountType options:nil
    completion:^(BOOL granted, NSError *error){
        if (granted == YES)
        {
            NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
        
        if ([arrayOfAccounts count] > 0)
        {
            ACAccount *twitterAccount = [arrayOfAccounts lastObject];
          
            SLRequest *postRequest = [SLRequest
                                      requestForServiceType:SLServiceTypeTwitter
                                      requestMethod:SLRequestMethodGET
                                      URL:url parameters:parameters];
            postRequest.account = twitterAccount;
          
            [postRequest performRequestWithHandler:requestHandler];
        } else {
          NSLog(@"No access");
        }
      }
    }];
}

@end
