//
//  GPX_Tests.swift
//
//  Created by Dave Hersey, Paracoders, LLC on 3/24/19.
//

import XCTest
@testable import GPX

class MockLocationViewControllerDelegate: LocationViewControllerDelegate {
    let destination: String
    let completion: () -> Void

    init(destination: String, completion: @escaping () -> Void) {
        self.destination = destination
        self.completion = completion
    }

    func newLocationName(_ name: String) {
        if name == destination { completion() }
    }
}

class GPX_Tests: XCTestCase {
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    
    func testGPXSpaceNeedle() {
        let potentialLocVC = storyboard.instantiateViewController(withIdentifier: "LocationViewController") as? LocationViewController
        guard let locVC = potentialLocVC else {
            XCTFail("Could not load LocationViewController")
            return
        }
        
        // Start location updates and verify that the Space Needle location is found.
        let spaceNeedleExpectation = expectation(description: "Location matches embedded GPX file (Space Needle)")
        let mockDelegate = MockLocationViewControllerDelegate(destination: "Space Needle") { spaceNeedleExpectation.fulfill() }
        locVC.locNameDelegate = mockDelegate
        locVC.toggleLocationUpdates()
        waitForExpectations(timeout: 20)
    }
}
