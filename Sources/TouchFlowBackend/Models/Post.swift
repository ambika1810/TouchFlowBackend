
import Fluent
import Foundation

final class Post: Model, @unchecked Sendable {
    static let schema = "posts"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    init() { }

    init(id: UUID? = nil, title: String) {
        self.id = id
        self.title = title
    }

    func toDTO() -> PostDTO {
        PostDTO(
            id: id,
            title: title
        )
    }
}
