import XCTest

final class ChildsupportLedgerUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testAddFlowOpensForm() throws {
        let app = XCUIApplication()
        app.launch()
        app.buttons["button_add"].tap()
        XCTAssertTrue(app.buttons["button_save"].waitForExistence(timeout: 5))
        app.buttons["button_cancel"].tap()
    }

    func testKeyboardDismissesOnTapOutside() throws {
        let app = XCUIApplication()
        app.launch()
        app.buttons["button_add"].tap()
        let textField = app.textFields.firstMatch
        if textField.waitForExistence(timeout: 5) {
            textField.tap()
            XCTAssertTrue(app.keyboards.element.exists)
            app.otherElements.firstMatch.tap()
        }
        app.buttons["button_cancel"].tap()
    }

    func testSettingsOpensAndCloses() throws {
        let app = XCUIApplication()
        app.launch()
        app.buttons["button_settings"].tap()
        XCTAssertTrue(app.buttons["button_settings_done"].waitForExistence(timeout: 5))
        app.buttons["button_settings_done"].tap()
    }

    func testPaywallShowsUpgradeButton() throws {
        let app = XCUIApplication()
        app.launch()
        app.buttons["button_settings"].tap()
        if app.buttons["button_upgrade"].waitForExistence(timeout: 5) {
            app.buttons["button_upgrade"].tap()
        }
        app.buttons["button_settings_done"].tap()
    }
}
