//
//  AddUsernamePresenter.swift
//  TimeToPost
//
//  Created by Uzair Ishaq on 14/04/2019.
//  Copyright © 2019 Uzair Ishaq. All rights reserved.
//

import Foundation
import UIKit

class AddUsernamePresenter {
    //MARK: properties
     weak var viewController: AddUsernameDisplayLogic?
    
    //MARK: Add username presentation logic
    
    func presentAddUsername(){
        let leftBarButton = UIBarButtonItem()
        leftBarButton.title = "Account"
        let rightBarButton = UIBarButtonItem(title: "Done", style: .plain, target: viewController, action: #selector(AddUsernameViewController.doneTapped))
        self.viewController?.displayAddUsername(with: leftBarButton, rightBarButton: rightBarButton)
    }
    
    func presentLoadingIndicator() {
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        activityIndicator.color = UIColor.black
        activityIndicator.startAnimating()
        let leftBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: viewController, action: #selector(AddUsernameViewController.cancelTapped))
        let rightBarButton = UIBarButtonItem(customView: activityIndicator)
        viewController?.displayLoadingUsername(with: leftBarButton, rightBarButton: rightBarButton)
    }
    
    func presentUpdateUsername(username: String) {
        let leftBarButton = UIBarButtonItem()
        leftBarButton.title = "Account"
        let rightBarButton = UIBarButtonItem(title: "Done", style: .plain, target: viewController, action: #selector(AddUsernameViewController.doneTapped))
        self.viewController?.displayAddUsername(with: leftBarButton, rightBarButton: rightBarButton)
    }
    
    func presentStatisticsGenerated() {
        presentAddUsername()
        viewController?.displayAlert(title: AppConfiguration.Messages.reportsCompletedTitle, message: AppConfiguration.Messages.reportsCompletedMessage)
    }
    
    // MARK: Present Alert Controller
    
    func presentAlertController(title: String, message: String) {
        presentAddUsername()
        viewController?.displayAlert(title: title, message: message)
    }
    
}
