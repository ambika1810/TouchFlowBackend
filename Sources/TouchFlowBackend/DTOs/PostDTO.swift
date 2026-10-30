
import Fluent
import Vapor
import Foundation

struct PostDTO: Content {
    var id: UUID?
    var title: String
    var caption: String?
    var authorName: String?
    var imageURL: String?
    var createdAt: Date?
    var likesCount: Int?
    var commentsCount: Int?

    func toModel() -> Post {
        Post(
            id: id,
            title: title,
            caption: caption,
            authorName: authorName,
            imageURL: imageURL,
            createdAt: createdAt,
            likesCount: 0,
            commentsCount: 0
        )
    }
}

