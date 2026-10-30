
import NIOSSL
import Fluent
import FluentPostgresDriver
import Vapor

func configure(_ app: Application) async throws {
    guard
        let hostname = Environment.get("DATABASE_HOST"),
        let username = Environment.get("DATABASE_USERNAME"),
        let password = Environment.get("DATABASE_PASSWORD"),
        let database = Environment.get("DATABASE_NAME")
    else {
        throw Abort(
            .internalServerError,
            reason: "Database environment variables are not configured."
        )
    }

    let port = Environment.get("DATABASE_PORT").flatMap(Int.init) ?? 5432

    var tlsConfiguration = TLSConfiguration.makeClientConfiguration()
    let certificatePath = Environment.get("DATABASE_CA_CERT_PATH")
        ?? "prod-ca-2021.crt"

    tlsConfiguration.trustRoots = .file(certificatePath)
    tlsConfiguration.certificateVerification = .fullVerification

    app.databases.use(
        DatabaseConfigurationFactory.postgres(
            configuration: .init(
                hostname: hostname,
                port: port,
                username: username,
                password: password,
                database: database,
                tls: .require(
                    try .init(configuration: tlsConfiguration)
                )
            )
        ),
        as: .psql
    )

    app.migrations.add(CreatePost())
    app.migrations.add(AddPostFields())
    
    try routes(app)
}
