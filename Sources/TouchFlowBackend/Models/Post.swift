

import Fluent
import Foundation

final class Post: Model, @unchecked Sendable {
    static let schema = "posts"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    @OptionalField(key: "caption")
    var caption: String?

    @OptionalField(key: "authorName")
    var authorName: String?

    @OptionalField(key: "imageURL")
    var imageURL: String?

    @OptionalField(key: "createdAt")
    var createdAt: Date?

    @Field(key: "likesCount")
    var likesCount: Int

    @Field(key: "commentsCount")
    var commentsCount: Int
    
    init() { }
    init(
        id: UUID? = nil,
        title: String,
        caption: String? = nil,
        authorName: String? = nil,
        imageURL: String? = nil,
        createdAt: Date? = nil,
        likesCount: Int = 0,
        commentsCount: Int = 0
    ) {
        self.id = id
        self.title = title
        self.caption = caption
        self.authorName = authorName
        self.imageURL = imageURL
        self.createdAt = createdAt
        self.likesCount = likesCount
        self.commentsCount = commentsCount
    }
    
    func toDTO() -> PostDTO {
        PostDTO(
            id: id,
            title: title,
            caption: caption,
            authorName: authorName,
            imageURL: imageURL,
            createdAt: createdAt,
            likesCount: likesCount,
            commentsCount: commentsCount
        )
    }
}
