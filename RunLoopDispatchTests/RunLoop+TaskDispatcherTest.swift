//
//  NSRunLoop+TaskDispatcherTest.swift
//  RunLoopDispatch
//
//  Created by WeZZard on 10/22/15.
//
//

import XCTest

@testable
import RunLoopDispatch

private typealias TimingSymbols = RunLoop.ScheduleTimings

class RunLoop_TaskDispatcherTest: XCTestCase {
    private var timingSymbols: [TimingSymbols] = []
    
    func testDispatchInvokeTiming() {
        let expectation = self.expectation(
            description: "testDispatchInvokeTiming"
        )
        
        RunLoop.current.schedule(in: RunLoop.Mode.common, for: .idle) {
            self.timingSymbols.append(.idle)
        }
        
        RunLoop.current.schedule(in: RunLoop.Mode.common, for: .nextCycleBegan) {
            self.timingSymbols.append(.nextCycleBegan)
        }
        
        RunLoop.current.schedule(in: RunLoop.Mode.common, for: .currentCycleEnded) {
            self.timingSymbols.append(.currentCycleEnded)
            
            RunLoop.current.schedule(in: RunLoop.Mode.common, for: .nextCycleBegan) {
                if self.timingSymbols
                    == [.nextCycleBegan, .idle, .currentCycleEnded]
                {
                    expectation.fulfill()
                } else {
                    print(self.timingSymbols)
                }
            }
        }
        
        waitForExpectations(timeout: 1) { (error) -> Void in
            if let error = error {
                XCTFail("Dispatch invoke timing(\(self.timingSymbols)) test failed with error: \(error)")
            }
        }
    }
}
