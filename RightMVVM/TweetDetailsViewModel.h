//
// TweetDetailsViewModel
// Created by dlebedev on 23.02.14.
//
//  Copyright (c) 2014 http://artsy.net. All rights reserved.

#import <Foundation/Foundation.h>
#import "BaseViewModel.h"

@interface TweetDetailsViewModel : BaseViewModel

- (instancetype)initWithTweet:(NSDictionary *)dictionary;

@end