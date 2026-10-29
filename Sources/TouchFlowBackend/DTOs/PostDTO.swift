
import Fluent
import Vapor
import Foundation

struct PostDTO: Content {
    var id: UUID?
    var title: String

    func toModel() -> Post {
        Post(id: id, title: title)
    }
}
