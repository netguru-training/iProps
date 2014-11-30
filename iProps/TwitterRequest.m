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
#import "UserModel.h"
#import "TweetModel.h"

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

NSInteger alphabeticUsersSort(id user1, id user2, void *context)
{
    NSString *a = ((UserModel*)user1).twitterUsername;
    NSString *b = ((UserModel*)user2).twitterUsername;
    
    return [a localizedCaseInsensitiveCompare:b];
}

+ (void)loadUsersOnComplete:(onSuccessBlock)onSuccess
{
    NSURL *url = [[NSURL alloc] initWithString:@"https://api.twitter.com/1.1/friends/list.json"];
    NSDictionary *params = @{ @"screen_name": @"netguru", @"count": @"200" };
    
    [self.class getWithURL:url andParameters:params andRequest:^(NSData *data, NSHTTPURLResponse *responseUrl, NSError *error) {
        NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        NSMutableArray *users = [NSMutableArray array];
        
        for (NSDictionary *userData in parsedObject[@"users"]) {
            [users addObject:[MTLJSONAdapter modelOfClass:UserModel.class fromJSONDictionary:userData error:&error]];
        }
        
        onSuccess([users sortedArrayUsingFunction:alphabeticUsersSort context:nil]);
    }];
}

+ (void)loadTweetsWithHandler:(void (^)(NSArray *))requestHandler
{
    NSURL *url = [[NSURL alloc] initWithString:@"https://api.twitter.com/1.1/search/tweets.json"];
    NSDictionary *params = @{ @"q": @"netguru", @"count": @"200" };
    
    [self.class getWithURL:url andParameters:params andRequest:^(NSData *data, NSHTTPURLResponse *responseUrl, NSError *error) {
        
        NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSMutableArray *tweets = [NSMutableArray array];
        
        for (NSDictionary *tweetData in parsedObject[@"statuses"]) {
            [tweets addObject:[MTLJSONAdapter modelOfClass:[TweetModel class] fromJSONDictionary:tweetData error:nil]];
        }
        requestHandler([tweets copy]);
    }];
}

@end
