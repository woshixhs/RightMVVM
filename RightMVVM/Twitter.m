//
// Twitter
// Created by dlebedev on 23.02.14.
//
//  Copyright (c) 2014 http://artsy.net. All rights reserved.

#import "Twitter.h"

#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface Twitter ()
@end

@implementation Twitter

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (RACSignal *)fetchTimeline {
    RACReplaySubject *subject = [RACReplaySubject subject];

    ACAccountStore *account = [[ACAccountStore alloc] init];

    ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];

    [account requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        if (granted){
            NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
            if ([arrayOfAccounts count] > 0) {
                ACAccount *twitterAccount = [arrayOfAccounts lastObject];
                NSURL *requestAPI = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/user_timeline.json"];

                SLRequest *posts = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                      requestMethod:SLRequestMethodGET
                                                                URL:requestAPI
                                                         parameters:nil];
                posts.account = twitterAccount;

                [posts performRequestWithHandler:^(NSData *response, NSHTTPURLResponse *urlResponse, NSError *error) {
                    NSArray *tweets = [NSJSONSerialization JSONObjectWithData:response
                                                                      options:NSJSONReadingMutableLeaves
                                                                        error:nil];
                    if (tweets.count) {
                        [subject sendNext:tweets];
                        [subject sendCompleted];
                    } else {

                    }

                }];
            }

        } else {
            NSLog(@"%@", [error description]);
            [subject sendError:error];
        }

    }];
    return [subject deliverOn:[RACScheduler mainThreadScheduler]];
}


@end