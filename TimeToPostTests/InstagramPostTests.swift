import Quick
import Nimble
import Result
import Alamofire
@testable
import TimeToPost
import ObjectMapper

class InstagramMediaTests: QuickSpec {
    override func spec() {
        it("create from JSON") {
            let id = "id-xyz"
            let code = "xyx"
            let imageUrl = ""
            let createdTime = Date()
            let likesCount = 4
            let commentsCount = 3
            let engagementCount = 7
            let json = ["id": id, "code": code, "image_url": imageUrl, "created_time": createdTime, "likes_count": likesCount, "comments_count": commentsCount, "engagement_count": engagementCount] as [String: Any]
            let post = InstagramPost(JSON: json)
            expect(post?.id) == id
            expect(post?.code) == code
            expect(post?.likesCount) == 4
            expect(post?.commentsCount) == 3
            expect(post?.engagementCount) == 4 + 3
        }
    }}
