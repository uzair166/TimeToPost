import Foundation

class AppConfiguration {
    
    // MARK: AppConfiguration TableViewSections
    
    struct TableViewSections{
        static let zero = NSLocalizedString("Highest Engagment", comment: "")
        static let one = NSLocalizedString("Most Commented", comment: "")
        static let two = NSLocalizedString("Recently Posted", comment: "")
    }
    
    // MARK: AppConfiguration TableViewCellIDs
    
    struct TableViewCellIDs{
        static let cell = "cellID"
    }
    
    struct DefaultNotifications {
        static let reload = Notification.Name(rawValue: "reload")
    }
    
    // MARK: AppConfiguration Messages
    
    struct Messages {
        static let okButton = NSLocalizedString("OK", comment: "")
        static let doneButton = NSLocalizedString("Done", comment: "")
        static let cancelButton = NSLocalizedString("Cancel", comment: "")
        static let deleteAllButton = NSLocalizedString("Delete All", comment: "")
        static let somethingWrongMessage = NSLocalizedString("Something happened that wasnt supposed to happen :(", comment: "")
        static let privateAccountMessage = NSLocalizedString("It is not possible to calculate the best time to post for private accounts", comment: "")
        static let reportsCompletedTitle = NSLocalizedString("Success", comment: "")
        static let reportsCompletedMessage = NSLocalizedString("Please go back to the home screen to view the best time to post", comment: "")
        static let deleteReportsTitle = NSLocalizedString("Delete Account", comment: "")
        static let deleteReportsMessage = NSLocalizedString("Remove my account and delete all the reports", comment: "")
    }
}
