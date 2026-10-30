

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

    init() { }

    init(
        id: UUID? = nil,
        title: String,
        caption: String? = nil,
        authorName: String? = nil,
        imageURL: String? = nil,
        createdAt: Date? = nil
    ) {
        self.id = id
        self.title = title
        self.caption = caption
        self.authorName = authorName
        self.imageURL = imageURL
        self.createdAt = createdAt
    }

    func toDTO() -> PostDTO {
        PostDTO(
            id: id,
            title: title,
            caption: caption,
            authorName: authorName,
            imageURL: imageURL,
            createdAt: createdAt
        )
    }
}
