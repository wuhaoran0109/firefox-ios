
import Foundation
import UserNotifications
import Shared

/**
 * This exists because the Sync code is extension-safe, and thus doesn't get
 * direct access to UIApplication.sharedApplication, which it would need to
 * display a notification.
 * This will also likely be the extension point for wipes, resets, and
 * getting access to data sources during a sync.
 */

enum SentTabAction: String {
    case view = "TabSendViewAction"
    case bookmark = "TabSendBookmarkAction"
    case readingList = "TabSendReadingListAction"
    
    static let TabSendURLKey = "TabSendURL"
    static let TabSendTitleKey = "TabSendTitle"
    static let TabSendCategory = "TabSendCategory"
    
    static func registerActions() {
        let viewAction = UNNotificationAction(identifier: SentTabAction.view.rawValue, title: Strings.SentTabViewActionTitle, options: .foreground)
        let bookmarkAction = UNNotificationAction(identifier: SentTabAction.bookmark.rawValue, title: Strings.SentTabBookmarkActionTitle, options: .authenticationRequired)
        let readingListAction = UNNotificationAction(identifier: SentTabAction.readingList.rawValue, title: Strings.SentTabAddToReadingListActionTitle, options: .authenticationRequired)
        
        // Register ourselves to handle the notification category set by NotificationService for APNS notifications
        let sentTabCategory = UNNotificationCategory(identifier: "org.mozilla.ios.SentTab.placeholder", actions: [viewAction, bookmarkAction, readingListAction], intentIdentifiers: [], options: UNNotificationCategoryOptions(rawValue: 0))
        UNUserNotificationCenter.current().setNotificationCategories([sentTabCategory])
    }
}
