//
//  HomePresenter.swift
//  TimeToPost
//
//  Created by Uzair Ishaq on 14/04/2019.
//  Copyright © 2019 Uzair Ishaq. All rights reserved.
//

import Foundation
import UIKit

struct InstagramPostSection{
    let sectionTitle: String
    let instagramPostViews: [InstagramPostView]
}

struct InstagramPostView {
    let likes: String
    let comments: String
    let imageURL: String
}

protocol InstagramPostPresentation {
    func presentLoadedSections(with items: [[String: Any]])
    func presentNoAccountSections()
    func presentAlertController(with message: String)
}

class HomePresenter: InstagramPostPresentation {
    
    // MARK: properties
    
    weak var viewController: HomeViewDisplayLogic?
    
    // MARK: present fetched posts
    
    func presentLoadedSections(with items: [[String : Any]]) {
        var instagramPostSections = [InstagramPostSection]()
        for section in items {
            guard let sectionTitle = section["sectionTitle"] as? String,
            let instagramPosts = section["items"] as? [InstagramPost] else { return }
            var instagramPostViews = [InstagramPostView]()
            for item in instagramPosts {
                let itemView = InstagramPostView(likes: NSLocalizedString("Likes: ", comment: "")+"\(item.likesCount.formattedWithPoint)", comments: NSLocalizedString("Comments: ", comment: "")+"\(item.commentsCount.formattedWithPoint)", imageURL: item.imageUrl)
                instagramPostViews.append(itemView)
            }
            let instagramPostSection = InstagramPostSection(sectionTitle: sectionTitle, instagramPostViews: instagramPostViews)
            instagramPostSections.append(instagramPostSection)
        }
        let weekday = DataService.weekday()
        let hour = DataService.hour()
        viewController?.displayFetchedPosts(instagramPostSections: instagramPostSections, hour: hour, weekday: weekday)
    }
    
    func presentNoAccountSections() {
        let instagramPostSections = createPlaceHolderSections()
        viewController?.displayFetchedPosts(instagramPostSections: instagramPostSections, hour: NSLocalizedString("Hour.", comment: ""), weekday: NSLocalizedString("Someday.", comment: ""))
    }
    
    private func createPlaceHolderSections() -> [InstagramPostSection]{
        let item = InstagramPostView(likes: NSLocalizedString("Likes", comment: ""), comments: NSLocalizedString("Comments", comment: ""), imageURL: "")
        let items = Array(repeating: item, count: 3)
        let instagramItemsSection_0 = InstagramPostSection(sectionTitle: AppConfiguration.TableViewSections.zero, instagramPostViews: items)
        let instagramItemsSection_1 = InstagramPostSection(sectionTitle: AppConfiguration.TableViewSections.one, instagramPostViews: items)
        let instagramItemsSection_2 = InstagramPostSection(sectionTitle: AppConfiguration.TableViewSections.two, instagramPostViews: items)
        return [instagramItemsSection_0, instagramItemsSection_1, instagramItemsSection_2]
    }
    
    func presentAlertController(with message: String) {
        viewController?.diplayFetchMediaFailureAlert(title: AppConfiguration.Messages.somethingWrongMessage, message: message)
    }
    
    
}
