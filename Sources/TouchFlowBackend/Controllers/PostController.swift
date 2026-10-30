
import Fluent
import Vapor

struct PostController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let posts = routes.grouped("posts")

        posts.get(use: self.index)
        posts.post(use: self.create)

        posts.group(":postID") { post in
            post.delete(use: self.delete)
            post.post("like", use: self.like)
        }
        posts.group(":postID") { post in
            post.delete(use: self.delete)
            post.post("like", use: self.like)
            post.post("unlike", use: self.unlike)
        }
        posts.group(":postID") { post in
            post.get(use: self.getPost)
            post.delete(use: self.delete)
            post.post("like", use: self.like)
            post.post("unlike", use: self.unlike)
        }
    }


    @Sendable
    func index(req: Request) async throws -> [PostDTO] {
        let limit = min(max(req.query[Int.self, at: "limit"] ?? 10, 1), 50)
        let offset = max(req.query[Int.self, at: "offset"] ?? 0, 0)

        return try await Post.query(on: req.db)
            .sort(\.$createdAt, .descending)
            .range(offset..<(offset + limit))
            .all()
            .map { $0.toDTO() }
    }


    
    @Sendable
    func getPost(req: Request) async throws -> PostDTO {
        guard let post = try await Post.find(
            req.parameters.get("postID"),
            on: req.db
        ) else {
            throw Abort(.notFound, reason: "Post not found")
        }

        return post.toDTO()
    }

 
    @Sendable
    func create(req: Request) async throws -> PostDTO {
        let dto = try req.content.decode(PostDTO.self)

        let post = dto.toModel()
        post.createdAt = Date()
        post.likesCount = 0
        post.commentsCount = 0

        try await post.save(on: req.db)

        return post.toDTO()
    }

    @Sendable
    func like(req: Request) async throws -> PostDTO {
        guard let post = try await Post.find(
            req.parameters.get("postID"),
            on: req.db
        ) else {
            throw Abort(.notFound, reason: "Post not found")
        }

        post.likesCount += 1

        try await post.save(on: req.db)

        return post.toDTO()
    }
    
    
    @Sendable
    func unlike(req: Request) async throws -> PostDTO {
        guard let post = try await Post.find(
            req.parameters.get("postID"),
            on: req.db
        ) else {
            throw Abort(.notFound, reason: "Post not found")
        }

        if post.likesCount > 0 {
            post.likesCount -= 1
        }

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
