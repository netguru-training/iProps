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
          if (granted == YES) {
              NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
              
              if ([arrayOfAccounts count] > 0) {
                  ACAccount *twitterAccount = [arrayOfAccounts lastObject];
                  
                  SLRequest *postRequest = [SLRequest
                                            requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodGET
                                            URL:url parameters:parameters];
                  postRequest.account = twitterAccount;
                  
                  [postRequest performRequestWithHandler:requestHandler];
              }
              
          } else {
              NSLog(@"No access");
          }
      }];
}

+ (void)loadUsersOnComplete:(onSuccessBlock)onSuccess
{
    NSURL *url = [[NSURL alloc] initWithString:@"https://api.twitter.com/1.1/friends/list.json"];
    NSDictionary *params = @{ @"screen_name": @"netguru" };
    
    [self.class getWithURL:url andParameters:params andRequest:^(NSData *data, NSHTTPURLResponse *responseUrl, NSError *error) {
        NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        //NSString *name = parsedObject[@"users"][0][@"screen_name"];
        //NSString *fulllName = parsedObject[@"users"][0][@"name"];
        
        UserModel *user = [MTLJSONAdapter modelOfClass:UserModel.class fromJSONDictionary:parsedObject[@"users"][0] error:&error];
        onSuccess(@[user]);
    }];
}

+ (void)loadTweetsWithHandler:(void (^)(NSData *, NSHTTPURLResponse *, NSError *))requestHandler
{
    NSURL *url = [[NSURL alloc] initWithString:@"https://api.twitter.com/1.1/search/tweets.json"];
    NSDictionary *params = @{ @"q": @"#netguru" };
    
    [self.class getWithURL:url andParameters:params andRequest:requestHandler];
}

@end
