//
//  NSRunLoop+SchedulingTasks.m
//  RunLoopDispatch
//
//  Created by WeZZard on 04/03/2017.
//
//

@import ObjectiveC;

#import "NSRunLoop+SchedulingTasks.h"

#import "NSRunLoopTask.h"
#import "_NSRunLoopTaskScheduler.h"

NSRunLoopScheduleTimings const NSRunLoopScheduleTimingNextCycleBegan = NSRunLoopScheduleTimingBeforeTimers;
NSRunLoopScheduleTimings const NSRunLoopScheduleTimingIdle = NSRunLoopScheduleTimingBeforeWaiting;
NSRunLoopScheduleTimings const NSRunLoopScheduleTimingCurrentCycleEnded = NSRunLoopScheduleTimingAfterWaiting;

typedef void NSRunLoopDealloc (__unsafe_unretained NSRunLoop * self, SEL _cmd);

static NSRunLoopDealloc * kNSRunLoopDeallocOriginal = NULL;

static NSRunLoopDealloc NSRunLoopDeallocSwizzled;

@interface NSRunLoop (TaskSchedulersAccessor)
@property (nonatomic, strong) NSMutableDictionary<NSRunLoopMode, _NSRunLoopTaskScheduler *> * _runLoopDispatch_schedulers;
@end

@implementation NSRunLoop (TaskSchedulersAccessor)
- (NSMutableDictionary<NSRunLoopMode, _NSRunLoopTaskScheduler *> *)_runLoopDispatch_schedulers
{
    NSMutableDictionary * existedSchedulers = objc_getAssociatedObject(self, @selector(_runLoopDispatch_schedulers));
    
    if (existedSchedulers != nil) {
        return existedSchedulers;
    } else {
        NSMutableDictionary * empty = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, @selector(_runLoopDispatch_schedulers), empty, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return empty;
    }
}

- (void)set_runLoopDispatch_schedulers:(NSMutableDictionary<NSRunLoopMode, _NSRunLoopTaskScheduler *> *)_runLoopDispatch_schedulers
{
    objc_setAssociatedObject(self, @selector(_runLoopDispatch_schedulers), _runLoopDispatch_schedulers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end

@implementation NSRunLoop (SchedulingTasks)
+ (void)load
{
    SEL deallocSelector = NSSelectorFromString(@"dealloc");
    kNSRunLoopDeallocOriginal = (NSRunLoopDealloc *)class_getMethodImplementation(self, deallocSelector);
    class_replaceMethod(self, deallocSelector, (IMP)&NSRunLoopDeallocSwizzled, "@:");
}

- (void)scheduleBlock:(NSRunLoopTaskBlock)block
           forTimings:(NSRunLoopScheduleTimings)timings
               inMode:(NSRunLoopMode)modes
{
    NSSet * setOfModes = [[NSSet alloc] initWithObjects:modes, nil];
    
    [self scheduleBlock:block forTimings:timings inSetOfModes:setOfModes];
}

- (void)scheduleBlock:(NSRunLoopTaskBlock)block
           forTimings:(NSRunLoopScheduleTimings)timings
              inModes:(NSRunLoopMode)modes, ... NS_REQUIRES_NIL_TERMINATION
{
    NSMutableSet * setOfModes = [NSMutableSet set];
    NSRunLoopMode eachMode;
    va_list argumentList;
    if (modes) {
        [setOfModes addObject:modes];
        va_start(argumentList, modes);
        while ((eachMode = va_arg(argumentList, id))) {
            [setOfModes addObject:eachMode];
        }
        va_end(argumentList);
    }
    
    [self scheduleBlock:block forTimings:timings inSetOfModes:[setOfModes copy]];
}

- (void)scheduleBlock:(NSRunLoopTaskBlock)block
           forTimings:(NSRunLoopScheduleTimings)timings
         inSetOfModes:(NSSet<NSRunLoopMode> *)setOfModes
{
    NSRunLoopTask * task = [NSRunLoopTask taskWithTimings:timings block:block];
    
    [setOfModes enumerateObjectsUsingBlock:^(NSRunLoopMode mode, BOOL * stop) {
        _NSRunLoopTaskScheduler * scheduler = self._runLoopDispatch_schedulers[mode];
        if (scheduler != nil) {
            [scheduler scheduleTask:task];
        } else {
            _NSRunLoopTaskScheduler * scheduler = [_NSRunLoopTaskScheduler schedulerWithRunLoop:self modes:mode];
            self._runLoopDispatch_schedulers[mode] = scheduler;
            [scheduler scheduleTask:task];
        }
    }];
}

- (void)scheduleBlock:(NSRunLoopTaskBlock)block
{
    NSSet * setOfModes = [NSSet setWithObjects:NSDefaultRunLoopMode, nil];
    
    [self scheduleBlock:block
             forTimings:NSRunLoopScheduleTimingAll
           inSetOfModes:setOfModes];
}

- (void)scheduleBlock:(NSRunLoopTaskBlock)block
              inModes:(NSRunLoopMode)modes
{
    NSSet * setOfModes = [NSSet setWithObjects:modes, nil];
    
    [self scheduleBlock:block inSetOfModes:setOfModes];
}

- (void)scheduleBlock:(NSRunLoopTaskBlock)block
    inSequenceOfModes:(NSRunLoopMode)modes, ... NS_REQUIRES_NIL_TERMINATION
{
    NSMutableSet * setOfModes = [NSMutableSet set];
    NSRunLoopMode eachMode;
    va_list argumentList;
    if (modes) {
        [setOfModes addObject:modes];
        va_start(argumentList, modes);
        while ((eachMode = va_arg(argumentList, id))) {
            [setOfModes addObject:eachMode];
        }
        va_end(argumentList);
    }
    
    [self scheduleBlock:block inSetOfModes:[setOfModes copy]];
}

- (void)scheduleBlock:(NSRunLoopTaskBlock)block
         inSetOfModes:(NSSet<NSRunLoopMode> *)setOfModes
{
    [self scheduleBlock:block
             forTimings:NSRunLoopScheduleTimingAll
           inSetOfModes:setOfModes];
}

- (void)scheduleBlock:(NSRunLoopTaskBlock)block
           forTimings:(NSRunLoopScheduleTimings)timings
{
    NSSet * setOfModes = [NSSet setWithObjects:NSDefaultRunLoopMode, nil];
    
    [self scheduleBlock:block forTimings:timings inSetOfModes:setOfModes];
}
@end

void NSRunLoopDeallocSwizzled(__unsafe_unretained NSRunLoop * self, SEL _cmd) {
    [self._runLoopDispatch_schedulers enumerateKeysAndObjectsUsingBlock:^(NSRunLoopMode mode, _NSRunLoopTaskScheduler * scheduler, BOOL * stop) {
        [scheduler invalidate];
    }];
    
    (* kNSRunLoopDeallocOriginal)(self, _cmd);
}

NSString * NSStringFromNSRunLoopScheduleTimings(NSRunLoopScheduleTimings timings) {
    NSMutableString * description = [[NSMutableString alloc] init];
    
    [description appendString:@"<NSRunLoopScheduleTimings:"];
    
    NSMutableArray * descriptions = [[NSMutableArray alloc] init];
    if ((timings & NSRunLoopScheduleTimingNextCycleBegan) != 0) {
        [descriptions addObject:@"Next Cycle Began"];
    }
    if ((timings & NSRunLoopScheduleTimingIdle) != 0) {
        [descriptions addObject:@"Idel"];
    }
    if ((timings & NSRunLoopScheduleTimingCurrentCycleEnded) != 0) {
        [descriptions addObject:@"Current Cycle Ended"];
    }
    if (descriptions.count == 0) {
        [description appendString:@" Empty"];
    } else {
        [description appendString:@" "];
        [description appendString:[descriptions componentsJoinedByString:@", "]];
    }
    
    [description appendString:@">"];
    
    return description;
}
