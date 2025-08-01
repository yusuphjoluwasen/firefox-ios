// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import XCTest

let getEndPoint = "http://restmail.net/mail/test-256a5b5b18"
let postEndPoint = "https://api-accounts.stage.mozaws.net/v1/recovery_email/verify_code"
let deleteEndPoint = "http://restmail.net/mail/test-256a5b5b18@restmail.net"

let userMail = "test-256a5b5b18@restmail.net"
let password = "nPuPEcoj"

class SyncUITests: BaseTestCase {
    //  https://mozilla.testrail.io/index.php?/cases/view/2448597
    func testSyncUIFromBrowserTabMenu() {
        // Check menu available from HomeScreenPanel
        waitForTabsButton()
        navigator.nowAt(NewTabScreen)
        navigator.goto(BrowserTabMenu)
        mozWaitForElementToExist(app.buttons[AccessibilityIdentifiers.Toolbar.settingsMenuButton])
        navigator.goto(Intro_FxASignin)
        navigator.performAction(Action.OpenEmailToSignIn)
        verifyFxASigninScreen()
    }

    private func verifyFxASigninScreen() {
        mozWaitForElementToExist(app.navigationBars[AccessibilityIdentifiers.Settings.FirefoxAccount.fxaNavigationBar])
        if #available(iOS 17, *) {
            mozWaitForElementToExist(
                app.webViews.textFields[AccessibilityIdentifiers.Settings.FirefoxAccount.emailTextField])
        } else {
            mozWaitForElementToExist(app.staticTexts[AccessibilityIdentifiers.Settings.FirefoxAccount.emailTextField])
        }

        // Verify the placeholdervalues here for the textFields
        let mailPlaceholder = "Enter your email"
        var defaultMailPlaceholder: String
        if #available(iOS 17, *) {
            defaultMailPlaceholder = app.webViews.textFields["Enter your email"].label
            XCTAssertEqual(
                mailPlaceholder,
                defaultMailPlaceholder,
                "The mail placeholder does not show the correct value"
            ) } else {
                mozWaitForElementToExist(app.staticTexts[mailPlaceholder])
            }
        mozWaitForElementToExist(app.webViews.buttons[AccessibilityIdentifiers.Settings.FirefoxAccount.continueButton])
    }

    // https://mozilla.testrail.io/index.php?/cases/view/2448874
    func testTypeOnGivenFields() {
        waitForTabsButton()
        navigator.nowAt(NewTabScreen)
        navigator.goto(FxASigninScreen)
        mozWaitForElementToExist(
            app.navigationBars[AccessibilityIdentifiers.Settings.FirefoxAccount.fxaNavigationBar],
            timeout: TIMEOUT_LONG
        )

        // Tap Sign in without any value in email Password focus on Email
        mozWaitForElementToExist(
            app.webViews.buttons[AccessibilityIdentifiers.Settings.FirefoxAccount.continueButton]
        )
        navigator.performAction(Action.FxATapOnContinueButton)
        mozWaitForElementToExist(app.webViews.staticTexts["Valid email required"])

        // Enter only email, wrong and correct and tap sign in
        userState.fxaUsername = "foo1bar2baz3@gmail.com"
        navigator.performAction(Action.FxATypeEmail)
        app.buttons["Done"].tapIfExists()
        navigator.performAction(Action.FxATapOnContinueButton)

        // Enter invalid (too short, it should be at least 8 chars) and incorrect password
        app.secureTextFields.element(boundBy: 1).waitAndTap()
        userState.fxaPassword = "foo"
        mozWaitForElementToExist(app.secureTextFields.element(boundBy: 0))
        navigator.performAction(Action.FxATypePasswordNewAccount)
        mozWaitForElementToExist(app.webViews.staticTexts["At least 8 characters"])
        XCTAssertEqual(app.webViews.images.element(boundBy: 0).label,
                       "failed",
                       "The password validation image should be failed")

        // Enter valid but incorrect, it does not exists, password
        userState.fxaPassword = "atleasteight"
        navigator.performAction(Action.FxATypePasswordNewAccount)
        // Switching to the next text field is required to determine if the message still appears or not
        app.buttons["Done"].tapIfExists()
        app.webViews.secureTextFields.element(boundBy: 0).waitAndTap()
        mozWaitForElementToExist(app.webViews.staticTexts["At least 8 characters"])
        XCTAssertEqual(app.webViews.images.element(boundBy: 0).label,
                       "passed",
                       "The password validation image should be passed")
    }

    // https://mozilla.testrail.io/index.php?/cases/view/2449603
    func testCreateAnAccountLink() {
        navigator.nowAt(NewTabScreen)
        navigator.goto(FxASigninScreen)
        mozWaitForElementToExist(app.webViews.firstMatch, timeout: TIMEOUT_LONG)
        if #available(iOS 17, *) {
            mozWaitForElementToExist(
                app.webViews.textFields[AccessibilityIdentifiers.Settings.FirefoxAccount.emailTextField],
                timeout: TIMEOUT_LONG
            )
        } else {
            mozWaitForElementToExist(
                app.staticTexts[AccessibilityIdentifiers.Settings.FirefoxAccount.emailTextField],
                timeout: TIMEOUT_LONG
            )
        }
        userState.fxaUsername = "foo1bar2@gmail.com"
        navigator.performAction(Action.FxATypeEmail)
        app.buttons["Done"].tapIfExists()
        navigator.performAction(Action.FxATapOnContinueButton)
        mozWaitForElementToExist(app.webViews.buttons["Create account"])
    }

    // https://mozilla.testrail.io/index.php?/cases/view/2449604
    func testShowPassword() {
        // The aim of this test is to check if the option to show password is shown when user starts typing
        // and disappears when no password is typed
        waitForTabsButton()
        navigator.nowAt(NewTabScreen)
        navigator.goto(FxASigninScreen)
        if #available(iOS 17, *) {
            mozWaitForElementToExist(
                app.webViews.textFields[AccessibilityIdentifiers.Settings.FirefoxAccount.emailTextField])
        } else {
            mozWaitForElementToExist(app.staticTexts[AccessibilityIdentifiers.Settings.FirefoxAccount.emailTextField])
        }
        // Typing on Email should not show Show (password) option
        userState.fxaUsername = "iosmztest@gmail.com"
        navigator.performAction(Action.FxATypeEmail)
        app.buttons["Done"].tapIfExists()
        navigator.performAction(Action.FxATapOnContinueButton)
        // Typing on Password should show Show (password) option
        userState.fxaPassword = "f"
        mozWaitForElementToExist(app.secureTextFields.element(boundBy: 1))
        navigator.performAction(Action.FxATypePasswordNewAccount)
        let passMessage = "Your password is currently hidden."
        mozWaitForElementToExist(app.webViews.switches[passMessage])
        // Remove the password typed, Show (password) option should not be shown
        app.secureTextFields.element(boundBy: 1).waitAndTap()
        app.keyboards.keys["delete"].waitAndTap()
        mozWaitForElementToNotExist(app.webViews.staticTexts[passMessage])
    }

    // https://mozilla.testrail.io/index.php?/cases/view/2449605
    func testQRPairing() {
        waitForTabsButton()
        navigator.nowAt(NewTabScreen)
        navigator.goto(Intro_FxASignin)
        // QR does not work on sim but checking that the button works, no crash
        navigator.performAction(Action.OpenEmailToQR)
        waitForElementsToExist(
            [
                app.navigationBars[AccessibilityIdentifiers.Settings.FirefoxAccount.fxaNavigationBar],
                app.buttons["Ready to Scan"],
                app.buttons["Use Email Instead"]]
        )
        app.navigationBars[AccessibilityIdentifiers.Settings.FirefoxAccount.fxaNavigationBar].buttons["Close"].waitAndTap()
        mozWaitForElementToExist(app.collectionViews.links[AccessibilityIdentifiers.FirefoxHomepage.TopSites.itemCell])
    }
}
