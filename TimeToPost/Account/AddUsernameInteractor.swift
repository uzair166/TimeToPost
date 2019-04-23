//
//  AddUsernameInteractor.swift
//  TimeToPost
//
//  Created by Uzair Ishaq on 14/04/2019.
//  Copyright © 2019 Uzair Ishaq. All rights reserved.
//

import Foundation
import UIKit

class AddUsernameInteractor {
    
    var presenter: AddUsernamePresenter?
    
    // MARK: storing/ updating username
    
    func validateUsername(with username: String){
        presenter?.presentLoadingIndicator()
        if ApppUserAccount().name != username {
            //delete old data
            DataService.deleteAll()
        }
        
        DataService.media(for: username){ (error) in
            guard let error = error else {
                self.presenter?.presentStatisticsGenerated()
                NotificationCenter.default.post(name: AppConfiguration.DefaultNotifications.reload, object: nil)
                return
            }
            self.stopLoading(with: error)
            
        }
    }
    
    func LoadUsername() {
        guard let name = ApppUserAccount().name else {
            presenter?.presentAddUsername()
            return
        }
        presenter?.presentUpdateUsername(username: name)
    }
    
    func deleteUsername(){
        presenter?.presentAddUsername()
        DataService.deleteAll()
    }
    
    private func stopLoading(with message: String) {
        presenter?.presentAlertController(title: AppConfiguration.Messages.somethingWrongMessage, message: message)
    }
}
