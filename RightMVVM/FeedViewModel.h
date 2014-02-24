//
// FeedViewModel
// Created by dlebedev on 23.02.14.
//
//  Copyright (c) 2014 http://artsy.net. All rights reserved.

#import <Foundation/Foundation.h>

#import "BaseViewModel.h"
#import "TableViewViewModel.h"

@class TweetDetailsViewModel;

@interface FeedViewModel : BaseViewModel <TableViewViewModel>

@property (strong, nonatomic, readonly) RACCommand *fetchTimelineCommand;

@property (strong, nonatomic, readonly) RACSignal *viewModelDidUpdateSignal;

@property (copy, nonatomic, readonly) NSString *title;

- (BOOL)tweetAtIndexPathIsReplyOrRetweet:(NSIndexPath *)path;
- (TweetDetailsViewModel *)tweetViewModelForIndexPath:(NSIndexPath *)path;

@end