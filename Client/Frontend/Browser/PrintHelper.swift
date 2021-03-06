/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import Foundation
import Shared
import WebKit

class PrintHelper: TabContentScript {
    fileprivate weak var tab: Tab?

    class func name() -> String {
        return "PrintHelper"
    }

    required init(tab: Tab) {
        self.tab = tab
        if let path = Bundle.main.path(forResource: "PrintHelper", ofType: "js"), let source = try? String(contentsOfFile: path, encoding: .utf8) {
            let userScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
            tab.webView!.configuration.userContentController.addUserScript(userScript)
        }
    }

    func scriptMessageHandlerName() -> String? {
        return "printHandler"
    }

    func userContentController(_ userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        if let tab = tab, let webView = tab.webView {
            let printController = UIPrintInteractionController.shared
            printController.printFormatter = webView.viewPrintFormatter()
            printController.present(animated: true, completionHandler: nil)
        }
    }
}
