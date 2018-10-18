//
//  NSRunLoopTask.m
//  RunLoopDispatch
//
//  Created by WeZZard on 04/03/2017.
//
//

#import "NSRunLoopTask.h"

@interface NSRunLoopTask()
@property (nonatomic, readonly, strong) NSRunLoopTaskBlock block;
@end

@implementation NSRunLoopTask
- (instancetype)initWithTimings:(NSRunLoopScheduleTimings)timings block:(NSRunLoopTaskBlock)block
{
    self = [super init];
    if (self) {
        _expectedActivities = CFRunLoopActivityMakeWithTimings(timings);
        _executed = NO;
        _block = block;
    }
    return self;
}

+ (__kindof NSRunLoopTask *)taskWithTimings:(NSRunLoopScheduleTimings)timings block:(NSRunLoopTaskBlock)block
{
    NSRunLoopTask * task = [[NSRunLoopTask alloc] initWithTimings:timings block:block];
    
    return task;
}

- (void)execute
{
    _block();
    _executed = YES;
}
@end
