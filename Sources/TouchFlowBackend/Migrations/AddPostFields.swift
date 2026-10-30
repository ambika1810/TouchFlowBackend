//
//  AddPostFields.swift
//  TouchFlowBackend
//
//  Created by Ambika Patil on 29/10/26.
//


import Fluent

struct AddPostFields: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("posts")
            .field("caption", .string)
            .field("authorName", .string)
            .field("imageURL", .string)
            .field("createdAt", .datetime)
            .update()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("posts")
            .deleteField("caption")
            .deleteField("authorName")
            .deleteField("imageURL")
            .deleteField("createdAt")
            .update()
    }
}
