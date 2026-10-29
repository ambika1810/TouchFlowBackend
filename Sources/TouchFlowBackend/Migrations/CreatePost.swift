
import Fluent

struct CreatePost: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("posts")
            .id()
            .field("title", .string, .required)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("posts").delete()
    }
}
