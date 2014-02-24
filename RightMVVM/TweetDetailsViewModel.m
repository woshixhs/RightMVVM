//
// TweetDetailsViewModel
// Created by dlebedev on 23.02.14.
//
//  Copyright (c) 2014 http://artsy.net. All rights reserved.

#import "TweetDetailsViewModel.h"

@interface TweetDetailsViewModel ()

@property (strong, nonatomic) NSDictionary *model;

@end

@implementation TweetDetailsViewModel

- (instancetype)initWithTweet:(NSDictionary *)tweet {
    self = [super init];
    if (!self) return nil;

    self.model = tweet;
    return self;
}

@end