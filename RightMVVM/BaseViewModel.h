//
// BaseViewModel
// Created by dlebedev on 23.02.14.
//
//  Copyright (c) 2014 http://artsy.net. All rights reserved.

#import <Foundation/Foundation.h>

#import <RVMViewModel.h>

typedef NS_ENUM(NSInteger , ViewModelState) {
    ViewModelStateNormal,
    ViewModelStateLoading,
    ViewModelStateError,
    ViewModelStateCustom
};

@interface BaseViewModel : RVMViewModel

@property (assign, nonatomic, readonly) ViewModelState state;

@property (strong, nonatomic, readonly) RACCommand *dataCommand;
@property (assign, nonatomic, readonly) BOOL hasRequiredData;
@end