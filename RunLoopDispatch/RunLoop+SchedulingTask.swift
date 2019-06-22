//
//  RunLoop+SchedulingTask.swift
//  RunLoopDispatch
//
//  Created by WeZZard on 10/22/15.
//
//

import Foundation

// MARK: - RunLoop

extension RunLoop {
    public typealias ScheduleTimings = RunLoopScheduleTimings
    
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
        for timings: ScheduleTimings = .anyTime,
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
        for timings: ScheduleTimings = .anyTime,
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
        for timings: ScheduleTimings = .anyTime,
        _ closure: @escaping RunLoopTaskClosure
        ) where Modes.Iterator.Element == RunLoop.Mode
    {
        __scheduleBlock(closure, for: timings, inSetOfModes: Set(modes))
    }
}

// MARK: - RunLoopScheduleTimings

extension RunLoopScheduleTimings {
    /// Represents the timing when the next run loop cycle began.
    ///
    /// - Note: This value equals to `.beforeWaiting`.
    ///
    public static let nextCycleBegan: RunLoopScheduleTimings = __NSRunLoopScheduleTimingNextCycleBegan
    
    /// Represents the timing when the next run loop is idle.
    ///
    /// - Note: This value equals to `.beforeWaiting`.
    ///
    public static let idle: RunLoopScheduleTimings = __NSRunLoopScheduleTimingIdle
    
    /// Represents the timing when the current run loop is ended.
    ///
    /// - Note: This value equals to `.beforeWaiting`.
    ///
    public static let currentCycleEnded: RunLoopScheduleTimings = __NSRunLoopScheduleTimingCurrentCycleEnded
    
    /// A convenience for `.all` schedule timings.
    ///
    public static let anyTime: RunLoopScheduleTimings = .all
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
