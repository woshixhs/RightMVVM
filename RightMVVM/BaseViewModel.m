//
// BaseViewModel
// Created by dlebedev on 23.02.14.
//
//  Copyright (c) 2014 http://artsy.net. All rights reserved.

#import "BaseViewModel.h"

@interface BaseViewModel ()

@property (strong, nonatomic) RACSignal *loadingSignal;
@property (strong, nonatomic) RACSignal *completedSignal;
@property (strong, nonatomic) RACSignal *errorSignal;

@end

@implementation BaseViewModel

#pragma mark - Abstract

- (id)init {
    self = [super init];
    if (!self) return nil;

    RAC(self, state) = [RACSignal
            merge:@[
                    self.loadingSignal,
                    self.completedSignal,
                    self.errorSignal
                   ]];

    return self;
}

- (BOOL)hasRequiredData {
    return YES;
}

- (RACCommand *)dataCommand {
    [NSException raise:NSGenericException
                format:@"%@ should be overriden", NSStringFromSelector(_cmd)];
    return nil;
}

#pragma mark - State

- (RACSignal *)loadingSignal {
    if (!_loadingSignal) {
        _loadingSignal = [self.dataCommand.executionSignals
                map:^id(RACSignal *subscribeSignal) {
                    return @(ViewModelStateLoading);
                }];
    }
    return _loadingSignal;
}

- (RACSignal *)completedSignal {
    if (!_completedSignal) {
        @weakify(self);
        _completedSignal = [self.dataCommand.executionSignals
                flattenMap:^RACStream *(RACSignal *subscribeSignal) {
                    return [[[subscribeSignal materialize]
                            filter:^BOOL(RACEvent *event) {
                                return event.eventType == RACEventTypeCompleted;
                            }]
                map:^id(id _) {
                    @strongify(self);
                    return [self hasRequiredData] ? @(ViewModelStateNormal) : @(ViewModelStateError);
                }];
            }];
    }
    return _completedSignal;
}

- (RACSignal *)errorSignal {
    if (!_errorSignal) {
        @weakify(self);
        _errorSignal = [self.dataCommand.errors
                map:^id(NSError *error) {
                    @strongify(self);
                    return [self hasRequiredData] ? @(ViewModelStateNormal) : @(ViewModelStateError);
                }];
    }
    return _errorSignal;
}
@end