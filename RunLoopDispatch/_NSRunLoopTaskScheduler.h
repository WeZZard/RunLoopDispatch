//
//  _NSRunLoopTaskScheduler.h
//  RunLoopDispatch
//
//  Created by WeZZard on 04/03/2017.
//
//

@import Foundation;

#import <RunLoopDispatch/NSRunLoop+SchedulingTasks.h>

NS_ASSUME_NONNULL_BEGIN

@class NSRunLoopTask;

@interface _NSRunLoopTaskScheduler : NSObject
- (instancetype)initWithRunLoop:(NSRunLoop *)runLoop modes:(NSRunLoopMode)modes;

+ (__kindof _NSRunLoopTaskScheduler *)schedulerWithRunLoop:(NSRunLoop *)runLoop modes:(NSRunLoopMode)modes;

- (void)scheduleTask:(NSRunLoopTask *)task;

- (void)invalidate;
@end

NS_ASSUME_NONNULL_END
