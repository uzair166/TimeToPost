//
//  InstagramInteractor.swift
//  TimeToPost
//
//  Created by Uzair Ishaq on 14/04/2019.
//  Copyright © 2019 Uzair Ishaq. All rights reserved.
//

import Foundation
import UIKit

class HomeInteractor {
    
    // MARK: properties
    
    var presenter: InstagramPostPresentation?
    
    // MARK: object life cycle
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(HomeInteractor.loadPosts), name: AppConfiguration.DefaultNotifications.reload, object: nil)
    }
    
    // MARK: load posts
    
    @objc func loadPosts() {
        guard let username = ApppUserAccount().name else {
            loadEmptyPosts()
            return
        }
        loadStoredPosts()
        DataService.media(for: username){ (error) in
            if error == nil {
                self.loadStoredPosts()
            }
            
        }
    }
    
    func loadEmptyPosts() {
        presenter?.presentNoAccountSections()
    }
    
    func loadStoredPosts() {
        let bestEngagement = DataService.bestEngagement(with: 25)
        let lastWeeksPosted = DataService.latestWeeksPosts(weeks: 25)
        let mostCommented = DataService.mostCommented(with: 25)
        let bestEngagementDictionary: [String: Any] = ["sectionTitle": AppConfiguration.TableViewSections.zero, "items": bestEngagement]
        let mostCommentedDictionary: [String: Any] = ["sectionTitle": AppConfiguration.TableViewSections.one, "items": mostCommented]
        let lastWeeksPostedDictionary: [String: Any] = ["sectionTitle": AppConfiguration.TableViewSections.two, "items": lastWeeksPosted]
        presenter?.presentLoadedSections(with: [bestEngagementDictionary, mostCommentedDictionary, lastWeeksPostedDictionary])
    }
    
    func loadFetchPostsFailureAlert(error: Error){
        presenter?.presentAlertController(with: error.localizedDescription)
    }
}
