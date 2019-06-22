//
//  NSRunLoop+SchedulingTasks.h
//  RunLoopDispatch
//
//  Created by WeZZard on 04/03/2017.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, NSRunLoopScheduleTimings) {
    NSRunLoopScheduleTimingEntry                = 1 << 0,
    NSRunLoopScheduleTimingBeforeTimers         = 1 << 1,
    NSRunLoopScheduleTimingBeforeSources        = 1 << 2,
    NSRunLoopScheduleTimingBeforeWaiting        = 1 << 3,
    NSRunLoopScheduleTimingAfterWaiting         = 1 << 4,
    NSRunLoopScheduleTimingExit                 = 1 << 5,
    
    NSRunLoopScheduleTimingAll                  = 0b111,
} NS_SWIFT_NAME(RunLoopScheduleTimings);

/** Represents the timing when the next run loop cycle began.
 
 @note This value equals to `NSRunLoopScheduleTimingBeforeTimers`.
 */
FOUNDATION_EXPORT NSRunLoopScheduleTimings const NSRunLoopScheduleTimingNextCycleBegan NS_REFINED_FOR_SWIFT;

/** Represents the timing when the next run loop is idle.
 
 @note This value equals to `NSRunLoopScheduleTimingBeforeWaiting`.
 */
FOUNDATION_EXPORT NSRunLoopScheduleTimings const NSRunLoopScheduleTimingIdle NS_REFINED_FOR_SWIFT;

/** Represents the timing when the current run loop is ended.
 
 @note This value equals to `NSRunLoopScheduleTimingAfterWaiting`.
 */
FOUNDATION_EXPORT NSRunLoopScheduleTimings const NSRunLoopScheduleTimingCurrentCycleEnded NS_REFINED_FOR_SWIFT;

FOUNDATION_EXTERN NSString * NSStringFromNSRunLoopScheduleTimings(NSRunLoopScheduleTimings timings)
NS_REFINED_FOR_SWIFT;

typedef void(^NSRunLoopTaskBlock)(void) NS_SWIFT_NAME(RunLoopTaskClosure);

@interface NSRunLoop (SchedulingTasks)
/*!
 \brief Schedule a task on the run-loop in specified modes for specified time.
 This method is not thread safe.
 
 \param block The task.
 
 \param timings The timings to execute the task.
 
 \param modes The allowed run-loop modes for executing the task.
 */
- (void)scheduleBlock:(NSRunLoopTaskBlock)block
           forTimings:(NSRunLoopScheduleTimings)timings
               inMode:(NSRunLoopMode)modes
NS_REFINED_FOR_SWIFT;

/*!
 \brief Schedule a task on the run-loop in specified modes for specified time.
 This method is not thread safe.
 
 \param block The task.
 
 \param timings The timings to execute the task.
 
 \param modes The allowed run-loop modes for executing the task.
 */
- (void)scheduleBlock:(NSRunLoopTaskBlock)block
           forTimings:(NSRunLoopScheduleTimings)timings
              inModes:(NSRunLoopMode)modes, ... NS_REQUIRES_NIL_TERMINATION
NS_REFINED_FOR_SWIFT;

/*!
 \brief Schedule a task on the run-loop in specified modes for specified time.
 This method is not thread safe.
 
 \param block The task.
 
 \param timings The timings to execute the task.
 
 \param setOfModes The allowed run-loop modes for executing the task.
 */
- (void)scheduleBlock:(NSRunLoopTaskBlock)block
           forTimings:(NSRunLoopScheduleTimings)timings
         inSetOfModes:(NSSet<NSRunLoopMode> *)setOfModes
NS_REFINED_FOR_SWIFT;

/*!
 \brief Schedule a task on the run-loop in `NSDefaultRunLoopMode` for
 `NSRunLoopScheduleTimingAll`. This method is not thread safe.
 
 \param block The task.
 */
- (void)scheduleBlock:(NSRunLoopTaskBlock)block NS_REFINED_FOR_SWIFT;

/*!
 \brief Schedule a task on the run-loop in in specified modes for
 `NSRunLoopScheduleTimingAll`. This method is not thread safe.
 
 \param block The task.
 
 \param modes The allowed run-loop modes for executing the task.
 */
- (void)scheduleBlock:(NSRunLoopTaskBlock)block
              inModes:(NSRunLoopMode)modes
NS_REFINED_FOR_SWIFT;

/*!
 \brief Schedule a task on the run-loop in in specified modes for
 `NSRunLoopScheduleTimingAll`. This method is not thread safe.
 
 \param block The task.
 
 \param modes The allowed run-loop modes for executing the task.
 */
- (void)scheduleBlock:(NSRunLoopTaskBlock)block
    inSequenceOfModes:(NSRunLoopMode)modes, ... NS_REQUIRES_NIL_TERMINATION
NS_REFINED_FOR_SWIFT;

/*!
 \brief Schedule a task on the run-loop in specified modes for
 `NSRunLoopScheduleTimingAll`. This method is not thread safe.
 
 \param block The task.
 
 \param setOfModes The allowed run-loop modes for executing the task.
 */
- (void)scheduleBlock:(NSRunLoopTaskBlock)block
         inSetOfModes:(NSSet<NSRunLoopMode> *)setOfModes
NS_REFINED_FOR_SWIFT;

/*!
 \brief Schedule a task on the run-loop in `NSDefaultRunLoopMode` for specified
 timings. This method is not thread safe.
 
 \param block The task.
 */
- (void)scheduleBlock:(NSRunLoopTaskBlock)block
           forTimings:(NSRunLoopScheduleTimings)timings
NS_REFINED_FOR_SWIFT;
@end

NS_ASSUME_NONNULL_END
