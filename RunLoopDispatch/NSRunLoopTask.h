//
//  NSRunLoopTask.h
//  RunLoopDispatch
//
//  Created by WeZZard on 04/03/2017.
//
//

@import Foundation;

#import <RunLoopDispatch/NSRunLoop+SchedulingTasks.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_STATIC_INLINE CFRunLoopActivity CFRunLoopActivityMakeWithTimings(NSRunLoopScheduleTimings timings);

@interface NSRunLoopTask : NSObject
@property (nonatomic, readonly) CFRunLoopActivity expectedActivities;
@property (nonatomic, readonly, getter=isExecuted) BOOL executed;

- (instancetype)initWithTimings:(NSRunLoopScheduleTimings)timings block:(NSRunLoopTaskBlock)block;

+ (__kindof NSRunLoopTask *)taskWithTimings:(NSRunLoopScheduleTimings)timings block:(NSRunLoopTaskBlock)block;

- (void)execute;
@end

CFRunLoopActivity CFRunLoopActivityMakeWithTimings(NSRunLoopScheduleTimings timings) {
    CFRunLoopActivity activities = 0;
    
    if ((timings & NSRunLoopScheduleTimingNextCycleBegan) != 0) {
        activities |= kCFRunLoopBeforeTimers;
    }
    
    if ((timings & NSRunLoopScheduleTimingIdle) != 0) {
        activities |= kCFRunLoopBeforeWaiting;
    }
    
    if ((timings & NSRunLoopScheduleTimingCurrentCycleEnded) != 0) {
        activities |= kCFRunLoopAfterWaiting;
    }
    
    return activities;
}

NS_ASSUME_NONNULL_END
