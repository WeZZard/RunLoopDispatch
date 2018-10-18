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
    NSRunLoopScheduleTimingNextCycleBegan       = 1 << 0,
    NSRunLoopScheduleTimingIdle                 = 1 << 1,
    NSRunLoopScheduleTimingCurrentCycleEnded    = 1 << 2,
    
    NSRunLoopScheduleTimingAll                  = 0b111,
} NS_SWIFT_NAME(RunLoopScheduleTimings);

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
