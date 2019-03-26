//
//  GPX_UITests.swift
//
//  Created by Dave Hersey, Paracoders, LLC on 3/24/19.
//

import XCTest

class GPX_UITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launch()
    }

    func testGPXStatueOfLiberty() {
        // Add an interruption handler to deal with the possible Location Services alert.
        addUIInterruptionMonitor(withDescription: "Location Services") { (alert) -> Bool in
            alert.buttons["Always Allow"].tap()
            return true
        }

        // Start location updates.
        app.navigationBars["GPX.LocationView"].buttons["Start updating"].tap()
        app.tap()

        // Verify that the Statue of Liberty location is found.
        let label = app.staticTexts["Statue of Liberty"]
        let exists = NSPredicate(format: "exists == 1")
        expectation(for: exists, evaluatedWith: label, handler: nil)
        waitForExpectations(timeout: 20, handler: nil)
    }
}
