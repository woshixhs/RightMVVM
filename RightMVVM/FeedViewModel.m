//
// FeedViewModel
// Created by dlebedev on 23.02.14.
//
//  Copyright (c) 2014 http://artsy.net. All rights reserved.

#import "FeedViewModel.h"
#import "Twitter.h"
#import "TweetDetailsViewModel.h"

@interface FeedViewModel ()

@property (strong, nonatomic) NSArray *model;
@property (strong, nonatomic, readwrite) RACCommand *fetchTimelineCommand;
@end

@implementation FeedViewModel

#pragma mark - Public

- (id)init {
    self = [super init];
    if (!self) return nil;

    @weakify(self);
    [self.didBecomeActiveSignal subscribeNext:^(id _) {
        @strongify(self);
        [self.fetchTimelineCommand execute:nil];
    }];

    _viewModelDidUpdateSignal = RACObserve(self, model);

    _title = NSLocalizedString(@"Feed", nil).uppercaseString;
    return self;
}

- (BOOL)tweetAtIndexPathIsReplyOrRetweet:(NSIndexPath *)path {
    return [self rowForIndexPath:path][@"in_reply_to_user_id"] != [NSNull null];
}


- (TweetDetailsViewModel *)tweetViewModelForIndexPath:(NSIndexPath *)path {
    NSDictionary *tweet = [self rowForIndexPath:path];
    TweetDetailsViewModel *vm = [[TweetDetailsViewModel alloc] initWithTweet:tweet];
    return vm;
}

- (RACCommand *)fetchTimelineCommand {
    if (!_fetchTimelineCommand) {
        _fetchTimelineCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @weakify(self);
            return [[[Twitter sharedInstance] fetchTimeline] doNext:^(NSArray *tweets) {
                @strongify(self);
                self.model = tweets;
            }];
        }];
    }
    return _fetchTimelineCommand;
}

- (BOOL)hasRequiredData {
    return self.model.count > 0;
}

#pragma mark - Overrides

- (RACCommand *)dataCommand {
    return [self fetchTimelineCommand];
}

#pragma mark - <TableViewViewModel>

- (NSUInteger)numberOfRowsInSection:(NSInteger)section {
    return self.model.count;
}


- (NSUInteger)numberOfSections {
    return 1;
}


- (id)rowForIndexPath:(NSIndexPath *)indexPath {
    return self.model[(NSUInteger)indexPath.row];
}


@end