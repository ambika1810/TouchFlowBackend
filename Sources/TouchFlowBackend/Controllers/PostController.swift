
import Fluent
import Vapor

struct PostController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let posts = routes.grouped("posts")

        posts.get(use: self.index)
        posts.post(use: self.create)

        posts.group(":postID") { post in
            post.delete(use: self.delete)
        }
    }

    @Sendable
    func index(req: Request) async throws -> [PostDTO] {
        try await Post.query(on: req.db)
            .sort(\.$createdAt, .descending)
            .all()
            .map { $0.toDTO() }
    }

    @Sendable
    func create(req: Request) async throws -> PostDTO {
        let dto = try req.content.decode(PostDTO.self)

        let post = dto.toModel()
        post.createdAt = Date()

        try await post.save(on: req.db)

        return post.toDTO()
    }

    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let post = try await Post.find(
            req.parameters.get("postID"),
            on: req.db
        ) else {
            throw Abort(.notFound)
        }

        try await post.delete(on: req.db)

        return .noContent
    }
}
