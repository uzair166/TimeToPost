import Foundation
import ObjectMapper
import RealmSwift


class InstagramPost: Object, Mappable {
    @objc dynamic var id = ""
    @objc dynamic var code = ""
    @objc dynamic var type = ""
    @objc dynamic var imageUrl = ""
    @objc dynamic var createdTime = Date()
    @objc dynamic var weekday = 0
    @objc dynamic var hour = 0
    @objc dynamic var likesCount = 0
    @objc dynamic var commentsCount = 0
    @objc dynamic var engagementCount = 0 // comments + likes
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        code <- map["code"]
        imageUrl <- map["image_url"]
        createdTime <- (map["created_time"], DateTransform())
        weekday = Calendar.current.component(.weekday, from: createdTime)
        hour = Calendar.current.component(.hour, from: createdTime)
        likesCount <- map["likes_count"]
        commentsCount <- map["comments_count"]
        engagementCount <- map["engagement_count"]
    }
    
}
