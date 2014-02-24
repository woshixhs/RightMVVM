//
// Twitter
// Created by dlebedev on 23.02.14.
//
//  Copyright (c) 2014 http://artsy.net. All rights reserved.

#import <Foundation/Foundation.h>

@class RACSignal;

@interface Twitter : NSObject

- (RACSignal *)fetchTimeline;

+ (instancetype)sharedInstance;

@end