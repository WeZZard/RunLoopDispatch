[![Build Status](https://travis-ci.com/WeZZard/Log.svg?branch=master)](https://travis-ci.com/WeZZard/RunLoopDispatch)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

[中文](./使用說明.md)

RunLoopDispatch is an Objective-C/Swift framework enables you to dispatch
tasks at the pace of run loop.

## Usages

Swift

```swift
import RunLoopDispatch

// Dispatch a closure in common mode when current run loop cycle ended.
RunLoop.main.schedule(in: .common, for: .currentCycleEnded) {
    print("Hello, world!")
}

// Dispatch a closure in a series of modes when run loop is idle.
RunLoop.main.schedule(in: .default, .eventTracking, for: .idle) {
    print("Hello, world!")
}

// Dispatch a closure in an array of modes when run loop is idle.
RunLoop.main.schedule(in: [.default, .eventTracking], for: .idle) {
    print("Hello, world!")
}
```

Objective-C

```objectivec
@import RunLoopDispatch;

// Dispatch a closure in common mode when current run loop cycle ended.
[[NSRunLoop mainRunLoop] scheduleBlock: ^() {
        NSLog(@"Hello, world!");
    }
    forTimings: NSRunLoopScheduleTimingNextCycleEnded
    inMode: NSRunLoopCommonModes
];

// Dispatch a closure in a series of modes when run loop is idle.
[[NSRunLoop mainRunLoop] scheduleBlock: ^() {
        NSLog(@"Hello, world!");
    }
    forTimings: NSRunLoopScheduleTimingIdle
    inModes: NSDefaultRunLoopMode, UITrackingRunLoopMode, nil
];

// Dispatch a closure in an array of modes when run loop is idle.
[[NSRunLoop mainRunLoop] scheduleBlock: ^() {
        NSLog(@"Hello, world!");
    }
    forTimings: NSRunLoopScheduleTimingIdle
    inSetOfModes: [NSSet setWithArray: @[NSDefaultRunLoopMode, UITrackingRunLoopMode]]
];
```

## License

MIT
