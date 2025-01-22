// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Redux
import XCTest
import Common

@testable import Client

final class TabTrayStateTests: XCTestCase {
    func testInitialState() {
        let initialState = createSubject()
        
        XCTAssertEqual(initialState.isPrivateMode, false)
        XCTAssertEqual(initialState.selectedPanel, .tabs)
        XCTAssertEqual(initialState.hasSyncableAccount, false)
        XCTAssertEqual(initialState.shouldDismiss, false)
        XCTAssertEqual(initialState.shareURL, nil)
        XCTAssertEqual(initialState.normalTabsCount, "0")
        XCTAssertEqual(initialState.showCloseConfirmation, false)
    }
    
    func testDidLoadTabTrayAction() {
        let initialState = createSubject()
        let reducer = tabTrayReducer()

        let action = getTabTrayAction(for: .didLoadTabTray)
        let newState = reducer(initialState, action)

        XCTAssertEqual(newState.isPrivateMode, false)
        XCTAssertEqual(newState.selectedPanel, .tabs)
        XCTAssertEqual(newState.hasSyncableAccount, false)
        XCTAssertEqual(newState.shouldDismiss, false)
        XCTAssertEqual(newState.shareURL, nil)
        XCTAssertEqual(newState.normalTabsCount, "0")
        XCTAssertEqual(newState.showCloseConfirmation, false)
    }
    
    func testChangePanelAction() {
        let initialState = createSubject()
        let reducer = tabTrayReducer()

        let action = getTabTrayAction(for: .changePanel)
        let newState = reducer(initialState, action)

        XCTAssertEqual(newState.isPrivateMode, false)
        XCTAssertEqual(newState.selectedPanel, .tabs)
        XCTAssertEqual(newState.hasSyncableAccount, false)
        XCTAssertEqual(newState.shouldDismiss, false)
        XCTAssertEqual(newState.shareURL, nil)
        XCTAssertEqual(newState.normalTabsCount, "0")
        XCTAssertEqual(newState.showCloseConfirmation, false)
    }
    
    func testDismissTabTrayAction() {
        let initialState = createSubject()
        let reducer = tabTrayReducer()

        let action = getTabTrayAction(for: .dismissTabTray)
        let newState = reducer(initialState, action)

        XCTAssertEqual(newState.isPrivateMode, false)
        XCTAssertEqual(newState.selectedPanel, .tabs)
        XCTAssertEqual(newState.hasSyncableAccount, false)
        XCTAssertEqual(newState.shouldDismiss, true)
        XCTAssertEqual(newState.shareURL, nil)
        XCTAssertEqual(newState.normalTabsCount, "0")
        XCTAssertEqual(newState.showCloseConfirmation, false)
    }
    
    func testFirefoxAccountChangedAction() {
        let initialState = createSubject(panelType: .privateTabs)
        let reducer = tabTrayReducer()
        
        let action = getTabTrayAction(for: .firefoxAccountChanged)
        let newState = reducer(initialState, action)

        XCTAssertEqual(newState.isPrivateMode, true)
        XCTAssertEqual(newState.selectedPanel, .privateTabs)
        XCTAssertEqual(newState.hasSyncableAccount, false)
        XCTAssertEqual(newState.shouldDismiss, false)
        XCTAssertEqual(newState.shareURL, nil)
        XCTAssertEqual(newState.normalTabsCount, "0")
        XCTAssertEqual(newState.showCloseConfirmation, false)
    }
    
    func testTabTrayDidLoadAction() {
        let initialState = createSubject(panelType: .syncedTabs)
        let reducer = tabTrayReducer()
        
        let action = getTabTrayAction(for: .firefoxAccountChanged)
        let newState = reducer(initialState, action)

        XCTAssertEqual(newState.isPrivateMode, false)
        XCTAssertEqual(newState.selectedPanel, .syncedTabs)
        XCTAssertEqual(newState.hasSyncableAccount, false)
        XCTAssertEqual(newState.shouldDismiss, false)
        XCTAssertEqual(newState.shareURL, nil)
        XCTAssertEqual(newState.normalTabsCount, "0")
        XCTAssertEqual(newState.showCloseConfirmation, false)
    }
    
    func testDidLoadTabPanelAction() {
        let initialState = createSubject()
        let reducer = tabTrayReducer()
        
        let action = getTabPanelMiddleWareAction(for: .didLoadTabPanel)
        let newState = reducer(initialState, action)

        XCTAssertEqual(newState.isPrivateMode, false)
        XCTAssertEqual(newState.selectedPanel, .tabs)
        XCTAssertEqual(newState.hasSyncableAccount, false)
        XCTAssertEqual(newState.shouldDismiss, false)
        XCTAssertEqual(newState.shareURL, nil)
        XCTAssertEqual(newState.normalTabsCount, "0")
        XCTAssertEqual(newState.showCloseConfirmation, false)
    }

    func testDidChangeTabPanelAction() {
        let initialState = createSubject()
        let reducer = tabTrayReducer()
        
        let action = getTabPanelMiddleWareAction(for: .didChangeTabPanel)
        let newState = reducer(initialState, action)

        XCTAssertEqual(newState.isPrivateMode, false)
        XCTAssertEqual(newState.selectedPanel, .tabs)
        XCTAssertEqual(newState.hasSyncableAccount, false)
        XCTAssertEqual(newState.shouldDismiss, false)
        XCTAssertEqual(newState.shareURL, nil)
        XCTAssertEqual(newState.normalTabsCount, "0")
        XCTAssertEqual(newState.showCloseConfirmation, false)
    }
    
    func testDidRefreshTabsAction() {
        let initialState = createSubject()
        let reducer = tabTrayReducer()
        
        let action = getTabPanelMiddleWareAction(for: .refreshTabs)
        let newState = reducer(initialState, action)

        XCTAssertEqual(newState.isPrivateMode, false)
        XCTAssertEqual(newState.selectedPanel, .tabs)
        XCTAssertEqual(newState.hasSyncableAccount, false)
        XCTAssertEqual(newState.shouldDismiss, false)
        XCTAssertEqual(newState.shareURL, nil)
        XCTAssertEqual(newState.normalTabsCount, "0")
        XCTAssertEqual(newState.showCloseConfirmation, false)
    }
    
    func testRefreshInactiveTabsAction() {
        let initialState = createSubject()
        let reducer = tabTrayReducer()
        
        let action = getTabPanelMiddleWareAction(for: .refreshInactiveTabs)
        let newState = reducer(initialState, action)

        XCTAssertEqual(newState.isPrivateMode, false)
        XCTAssertEqual(newState.selectedPanel, .tabs)
        XCTAssertEqual(newState.hasSyncableAccount, false)
        XCTAssertEqual(newState.shouldDismiss, false)
        XCTAssertEqual(newState.shareURL, nil)
        XCTAssertEqual(newState.normalTabsCount, "0")
        XCTAssertEqual(newState.showCloseConfirmation, false)
    }
    
    func testShowToastAction() {
        let initialState = createSubject()
        let reducer = tabTrayReducer()
        
        let action = getTabPanelMiddleWareAction(for: .showToast)
        let newState = reducer(initialState, action)

        XCTAssertEqual(newState.isPrivateMode, false)
        XCTAssertEqual(newState.selectedPanel, .tabs)
        XCTAssertEqual(newState.hasSyncableAccount, false)
        XCTAssertEqual(newState.shouldDismiss, false)
        XCTAssertEqual(newState.shareURL, nil)
        XCTAssertEqual(newState.normalTabsCount, "0")
        XCTAssertEqual(newState.showCloseConfirmation, false)
    }
    
    func testCloseAllTabsAction() {
        let initialState = createSubject()
        let reducer = tabTrayReducer()
        
        let action = getTabPanelViewAction(for: .closeAllTabs)
        let newState = reducer(initialState, action)

        XCTAssertEqual(newState.isPrivateMode, false)
        XCTAssertEqual(newState.selectedPanel, .tabs)
        XCTAssertEqual(newState.hasSyncableAccount, false)
        XCTAssertEqual(newState.shouldDismiss, false)
        XCTAssertEqual(newState.shareURL, nil)
        XCTAssertEqual(newState.normalTabsCount, "0")
        XCTAssertEqual(newState.showCloseConfirmation, true)
    }
    
    func testShowShareSheetAction() {
        let initialState = createSubject()
        let reducer = tabTrayReducer()
        
        let action = getTabPanelViewAction(for: .showShareSheet)
        let newState = reducer(initialState, action)

        XCTAssertEqual(newState.isPrivateMode, false)
        XCTAssertEqual(newState.selectedPanel, .tabs)
        XCTAssertEqual(newState.hasSyncableAccount, false)
        XCTAssertEqual(newState.shouldDismiss, false)
        XCTAssertEqual(newState.shareURL, nil)
        XCTAssertEqual(newState.normalTabsCount, "0")
        XCTAssertEqual(newState.showCloseConfirmation, false)
    }
    
    func testTabPanelDidLoadAction() {
        let initialState = createSubject()
        let reducer = tabTrayReducer()
        
        let action = getTabPanelViewAction(for: .tabPanelDidLoad)
        let newState = reducer(initialState, action)

        XCTAssertEqual(newState.isPrivateMode, false)
        XCTAssertEqual(newState.selectedPanel, .tabs)
        XCTAssertEqual(newState.hasSyncableAccount, false)
        XCTAssertEqual(newState.shouldDismiss, false)
        XCTAssertEqual(newState.shareURL, nil)
        XCTAssertEqual(newState.normalTabsCount, "0")
        XCTAssertEqual(newState.showCloseConfirmation, false)
    }
    
    //test for unimplemented TabPanelViewActionType
    func testCloseTabAction() {
        let initialState = createSubject()
        let reducer = tabTrayReducer()
        
        let action = getTabPanelViewAction(for: .closeTab)
        let newState = reducer(initialState, action)

        XCTAssertEqual(newState.isPrivateMode, false)
        XCTAssertEqual(newState.selectedPanel, .tabs)
        XCTAssertEqual(newState.hasSyncableAccount, false)
        XCTAssertEqual(newState.shouldDismiss, false)
        XCTAssertEqual(newState.shareURL, nil)
        XCTAssertEqual(newState.normalTabsCount, "0")
        XCTAssertEqual(newState.showCloseConfirmation, false)
    }
    
    func testDefaultState() {
        let initialState = createSubject()
        let reducer = tabTrayReducer()
        
        let unknownAction = getUnknownAction()
        let newState = reducer(initialState, unknownAction)
        
        XCTAssertEqual(newState, initialState, "State should remain unchanged when an unknown action is passed")
        XCTAssertEqual(initialState.isPrivateMode, newState.isPrivateMode)
        XCTAssertEqual(initialState.selectedPanel, newState.selectedPanel)
        XCTAssertEqual(initialState.hasSyncableAccount, newState.hasSyncableAccount)
        XCTAssertEqual(initialState.shouldDismiss, newState.shouldDismiss)
        XCTAssertEqual(initialState.shareURL, newState.shareURL)
        XCTAssertEqual(initialState.normalTabsCount, newState.normalTabsCount)
        XCTAssertEqual(initialState.showCloseConfirmation, newState.showCloseConfirmation)
    }

    // MARK: - Private
    private func createSubject(panelType:TabTrayPanelType = .tabs) -> TabTrayState {
        return TabTrayState(windowUUID: .XCTestDefaultUUID, panelType: panelType)
    }

    private func tabTrayReducer() -> Reducer<TabTrayState> {
        return TabTrayState.reducer
    }

    private func getTabTrayAction(for actionType: TabTrayActionType) -> TabTrayAction {
        return  TabTrayAction(windowUUID: .XCTestDefaultUUID, actionType: actionType)
    }
    
    private func getTabPanelMiddleWareAction(for actionType: TabPanelMiddlewareActionType) -> TabPanelMiddlewareAction {
        return  TabPanelMiddlewareAction(windowUUID: .XCTestDefaultUUID, actionType: actionType)
    }
    
    private func getTabPanelViewAction(for actionType: TabPanelViewActionType) -> TabPanelViewAction {
        return  TabPanelViewAction(panelType: .tabs, windowUUID: .XCTestDefaultUUID, actionType: actionType)
    }
    
    private func getUnknownAction() -> UnknownMockAction {
        return  UnknownMockAction(windowUUID: .XCTestDefaultUUID, actionType: MockActionType())
    }
    
    private class UnknownMockAction: Action {
        override init(windowUUID: WindowUUID, actionType: ActionType) {
             super.init(windowUUID: windowUUID,
                        actionType: actionType)
        }
    }
    
    private struct MockActionType: ActionType {
        let description = "Unknown Action"
    }
}

