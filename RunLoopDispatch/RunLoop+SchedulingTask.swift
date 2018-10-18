//
//  RunLoop+SchedulingTask.swift
//  RunLoopDispatch
//
//  Created by WeZZard on 10/22/15.
//
//

import Foundation

extension RunLoop {
    public typealias Timings = RunLoopScheduleTimings
    
    /// Schedule a task on the run-loop in specified modes for specified time.
    /// This function is not thread safe.
    ///
    /// - Parameter mode: The allowed run-loop modes for executing the task.
    /// `.defaultRunLoopMode` by default.
    ///
    /// - Parameter timings: The timings to execute the task. `.anyTime` by
    /// default.
    ///
    /// - Parameter closure: The task.
    ///
    public func schedule(
        in modes: RunLoop.Mode = RunLoop.Mode.default,
        for timings: Timings = .anyTime,
        _ closure: @escaping RunLoopTaskClosure
        )
    {
        __scheduleBlock(closure, for: timings, inSetOfModes: [modes])
    }
    
    /// Schedule a task on the run-loop in specified modes for specified time.
    /// This function is not thread safe.
    ///
    /// - Parameter mode: The allowed run-loop modes for executing the task.
    /// `.defaultRunLoopMode` by default.
    ///
    /// - Parameter timings: The timings to execute the task. `.anyTime` by
    /// default.
    ///
    /// - Parameter closure: The task.
    ///
    public func schedule(
        in modes: RunLoop.Mode...,
        for timings: Timings = .anyTime,
        _ closure: @escaping RunLoopTaskClosure
        )
    {
        __scheduleBlock(closure, for: timings, inSetOfModes: Set(modes))
    }
    
    /// Schedule a task on the run-loop in specified modes for specified time.
    /// This function is not thread safe.
    ///
    /// - Parameter mode: The allowed run-loop modes for executing the task.
    /// `.defaultRunLoopMode` by default.
    ///
    /// - Parameter timings: The timings to execute the task. `.anyTime` by
    /// default.
    ///
    /// - Parameter closure: The task.
    ///
    public func schedule<Modes: Sequence>(
        in modes: Modes,
        for timings: Timings = .anyTime,
        _ closure: @escaping RunLoopTaskClosure
        ) where Modes.Iterator.Element == RunLoop.Mode
    {
        __scheduleBlock(closure, for: timings, inSetOfModes: Set(modes))
    }
}

extension RunLoopScheduleTimings: CustomStringConvertible,
    CustomDebugStringConvertible
{
    public var description: String {
        return __NSStringFromNSRunLoopScheduleTimings(self)
    }
    
    public var debugDescription: String {
        return __NSStringFromNSRunLoopScheduleTimings(self)
    }
}

extension RunLoopScheduleTimings {
    public static let anyTime: RunLoopScheduleTimings = all
}
