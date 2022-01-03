import Foundation
import XCTest

extension XCTestCase {
    func validateMemoryLeak(_ instance: AnyObject) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Warning: the instance should be nil. Potencial memory leak")
        }
    }
}

