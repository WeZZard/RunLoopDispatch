//
//  _NSRunLoopTaskScheduler.m
//  RunLoopDispatch
//
//  Created by WeZZard on 04/03/2017.
//
//

#import "_NSRunLoopTaskScheduler.h"

#import "NSRunLoopTask.h"

#import <objc/runtime.h>

static void _NSRunLoopTaskSchedulerHandleRunLoopActivity(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info);

@interface _NSRunLoopTaskScheduler()
@property (nonatomic, unsafe_unretained, readonly) NSRunLoop * runLoop;
@property (nonatomic, strong) NSMutableArray<NSRunLoopTask *> * tasks;
@property (nonatomic, strong) NSString * modes;
@property (nonatomic, assign) CFRunLoopObserverContext context;
@property (nonatomic, assign) CFRunLoopObserverRef observer;
@end

@implementation _NSRunLoopTaskScheduler
- (instancetype)initWithRunLoop:(NSRunLoop *)runLoop modes:(NSRunLoopMode)modes
{
    self = [super init];
    if (self) {
        _runLoop = runLoop;
        
        _tasks = [[NSMutableArray alloc] init];
        
        _modes = modes;
        
        _context = (CFRunLoopObserverContext) {
            .version =  0,
            .info =  (__bridge void *)self,
            .retain = NULL,
            .release = NULL,
            .copyDescription = NULL,
        };
        
        CFRunLoopActivity requiredActivities = CFRunLoopActivityMakeWithTimings(NSRunLoopScheduleTimingAll);
        
        _observer = CFRunLoopObserverCreate(kCFAllocatorDefault, requiredActivities, true, 0, &_NSRunLoopTaskSchedulerHandleRunLoopActivity, &(_context));
        
        CFRunLoopAddObserver([runLoop getCFRunLoop], _observer, (__bridge CFStringRef)modes);
    }
    return self;
}

+ (__kindof _NSRunLoopTaskScheduler *)schedulerWithRunLoop:(NSRunLoop *)runLoop modes:(NSRunLoopMode)modes
{
    _NSRunLoopTaskScheduler * scheduler = [[_NSRunLoopTaskScheduler alloc] initWithRunLoop:runLoop modes:modes];
    return scheduler;
}

- (void)dealloc
{
    NSAssert(!CFRunLoopObserverIsValid(_observer), @"The observer should be invalidated before the scheduler was deallocated.");
}

- (void)scheduleTask:(NSRunLoopTask *)task
{
    [_tasks addObject:task];
}

- (void)invalidate
{
    CFRunLoopObserverInvalidate(_observer);
}

- (void)runTasksWithActivity:(CFRunLoopActivity)activity
{
    NSMutableIndexSet * indicesToRemove = [[NSMutableIndexSet alloc] init];
    
    [_tasks enumerateObjectsUsingBlock:^(NSRunLoopTask * eachTask, NSUInteger idx, BOOL * stop) {
        if (!eachTask.isExecuted) {
            if ((eachTask.expectedActivities & activity) != 0) {
                [eachTask execute];
            }
        }
        
        if (eachTask.isExecuted) {
            [indicesToRemove addIndex:idx];
        }
    }];
    
    [_tasks removeObjectsAtIndexes:indicesToRemove];
}
@end

void _NSRunLoopTaskSchedulerHandleRunLoopActivity(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    _NSRunLoopTaskScheduler * scheduler = (__bridge _NSRunLoopTaskScheduler *)info;
    
    [scheduler runTasksWithActivity:activity];
}
