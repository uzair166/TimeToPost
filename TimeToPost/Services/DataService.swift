import Foundation
import RealmSwift

enum Weekday: Int {
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
}

class DataService {
    
    
    //make api call to fetch media for a specific user
    static func media(for username: String, completion: @escaping (_ error: String?) -> Void){
        InstagramProvider.request(.userMedia(username)) { result in
            do {
                let response = try result.get()
                let value: [String: Any] = try response.mapNSArray()
                guard let items = value["data"] as? [[String: Any]], items.isEmpty == false else {
                    completion(AppConfiguration.Messages.privateAccountMessage)
                    return
                }
                ApppUserAccount().name = username
                importInstagramPosts(instagramPosts: items, completion: {
                    completion(nil)
                })
            } catch {
                completion(error.localizedDescription)
            }
            
        }
    }
    
    
    //write all the instgaram media to database
    
    static func importInstagramPosts(instagramPosts: [[String: Any]], completion: @escaping () -> Void) {
        DispatchQueue.global().async {
            guard let realm = try? Realm() else { return }
            realm.beginWrite()
            for media in instagramPosts {
                guard let instagramPost = InstagramPost(JSON: media) else {
                    continue
                }
                realm.add(instagramPost, update: true)
            }
            try? realm.commitWrite()
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    
    //function to return the top n post with the most likes
    static func mostLiked (with limit: Int) -> [InstagramPost] {
        guard let realm = try? Realm() else {return []}
        let posts = realm.objects(InstagramPost.self).sorted(byKeyPath: "likesCount", ascending: false)
        if posts.count > limit {
            return Array(posts[0...limit])
        }
        return Array(posts)
    }
    
    static func mostCommented (with limit: Int) -> [InstagramPost] {
        guard let realm = try? Realm() else {return []}
        let posts = realm.objects(InstagramPost.self).sorted(byKeyPath: "commentsCount", ascending: false)
        if posts.count > limit {
            return Array(posts[0...limit])
        }
        return Array(posts)
    }
    
    //get n posts with best engagement
    static func bestEngagement(with limit: Int) -> [InstagramPost] {
        guard let realm = try? Realm() else { return [] }
        let posts = realm.objects(InstagramPost.self).sorted(byKeyPath: "engagementCount", ascending: false)
        if posts.count > limit {
            return Array(posts[0...limit])
        }
        return Array(posts)
    }
    
    // get all the posts which were uploaded in the last n weeks
    static func latestWeeksPosts (weeks: Int) -> [InstagramPost] {
        guard let realm = try? Realm() else { return [] }
        guard let fromDate = Calendar.current.date(byAdding: .day, value: -1*(7*weeks), to: Date()) else { return []}
        let predicate = NSPredicate(format: "createdTime > %@", fromDate as NSDate)
        let posts = realm.objects(InstagramPost.self).sorted(byKeyPath: "createdTime", ascending: false).filter(predicate)
        return Array(posts)
    }
    

    
    
    //get oldest posts stored locally
    static func instagramMediaIndex() -> (offset: String?, count: Int) {
        guard let realm = try? Realm() else { return (nil, 0) }
        let entries = realm.objects(InstagramPost.self).sorted(byKeyPath: "createdTime", ascending: true)
        if entries.isEmpty == false {
            guard let offset = entries[0]["id"] as? String else { return (nil, 0) }
            let count = entries.count
            return (offset, count)
        } else {
            return (nil, 0)
        }
    }
    
    // get weekday
    static func weekday() -> String {
        guard let realm = try? Realm() else { return "" }
        var predicateArray = [NSPredicate]()
        var groupByArray = [[InstagramPost]]()
        var summedEngagementArray = [(Int, Int)]()
        
        for weekday in 1...7 {
            let predicate = NSPredicate(format: "weekday == %d", weekday)
            predicateArray.append(predicate)
        }
        for weekday in predicateArray.indices {
            let posts = Array(realm.objects(InstagramPost.self).filter(predicateArray[weekday]))
            groupByArray.append(posts)
        }
        for weekday in groupByArray.indices {
            let array = groupByArray[weekday]
            summedEngagementArray.append(DataService.sumEngagement(for: array, day: weekday))
        }
        
        summedEngagementArray = summedEngagementArray.sorted(by: {$0.0 > $1.0})
        switch summedEngagementArray[0].1 {
        case Weekday.sunday.rawValue:
            return NSLocalizedString("Sunday.", comment: "")
        case Weekday.monday.rawValue:
            return NSLocalizedString("Monday.", comment: "")
        case Weekday.tuesday.rawValue:
            return NSLocalizedString("Tuesday.", comment: "")
        case Weekday.wednesday.rawValue:
            return NSLocalizedString("Wednesday.", comment: "")
        case Weekday.thursday.rawValue:
            return NSLocalizedString("Thursday.", comment: "")
        case Weekday.friday.rawValue:
            return NSLocalizedString("Friday.", comment: "")
        case Weekday.saturday.rawValue:
            return NSLocalizedString("Saturday.", comment: "")
        default:
            return NSLocalizedString("Weekday.", comment: "")
        }
    }
    
    
    
    //get hour
    static func hour() -> String {
        guard let realm = try? Realm() else { return "" }
        var predicateArray = [NSPredicate]()
        var groupByArray = [[InstagramPost]]()
        var summedEngagementArray = [(Int, Int)]()
        
        for hour in 0...23 {
            let predicate = NSPredicate(format: "hour == %d", hour)
            predicateArray.append(predicate)
        }
        for hour in predicateArray.indices {
            let posts = Array(realm.objects(InstagramPost.self).filter(predicateArray[hour]))
            groupByArray.append(posts)
        }
        for hour in groupByArray.indices {
            let array = groupByArray[hour]
            summedEngagementArray.append(DataService.sumEngagementHour(for: array, hour: hour))
        }
        summedEngagementArray = summedEngagementArray.sorted(by: {$0.0 > $1.0})
        let from = String(summedEngagementArray[0].1) + ":00"
        var to = String(summedEngagementArray[0].1 + 1) + ":00"
        
        if summedEngagementArray[0].1 == 23 {
            to = "00:00"
        }
        return NSLocalizedString(from+" to "+to , comment: "")
    }

    
    
    static func sumEngagement(for array: [InstagramPost], day: Int) -> (Int, Int){
        var sum = 0
        for media in array {
            sum += media.engagementCount
        }
        return (sum, day+1)
    }
    
    static func sumEngagementHour(for array: [InstagramPost], hour: Int) -> (Int, Int){
        var sum = 0
        for media in array {
            sum += media.engagementCount
        }
        return (sum, hour)
    }
    
    
    static func deleteAll(){
        ApppUserAccount().name = nil
        guard let realm = try? Realm() else { return }
        try? realm.write {
            realm.deleteAll()
        }
        NotificationCenter.default.post(name: AppConfiguration.DefaultNotifications.reload, object: nil)
    }
    
    
    
}
