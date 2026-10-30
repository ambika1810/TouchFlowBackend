//
//  AddPostEngagementFields.swift
//  TouchFlowBackend
//
//  Created by Ambika Patil on 30/10/26.
//



import Fluent
import SQLKit
import FluentSQL

struct AddPostEngagementFields: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("posts")
            .field("likesCount", .int, .required, .sql(.default(0)))
            .field("commentsCount", .int, .required, .sql(.default(0)))
            .update()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("posts")
            .deleteField("likesCount")
            .deleteField("commentsCount")
            .update()
    }
}
