// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation
import Redux
import Common
import WebKit

struct PasswordGeneratorAction: Action {
    let windowUUID: WindowUUID
    let actionType: ActionType

    // Used in the middlwares
    let currentFrame: WKFrameInfo?

    // Used in some reducers
    let password: String?

    let origin: String?

    init(windowUUID: WindowUUID,
         actionType: any ActionType,
         currentFrame: WKFrameInfo? = nil,
         password: String? = nil,
         origin: String? = nil) {
        self.windowUUID = windowUUID
        self.actionType = actionType
        self.currentFrame = currentFrame
        self.password = password
        self.origin = origin
    }
}

enum PasswordGeneratorActionType: ActionType {
    // User Actions
    case showPasswordGenerator
    case userTappedRefreshPassword
    case userTappedUsePassword
    case clearGeneratedPasswordForSite
    case hidePassword
    case showPassword

    // Middleware Actions
    case updateGeneratedPassword
}
