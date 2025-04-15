//
//  PersistenceProvider.swift
//  Tracer
//
//  Created by Cole Roberts on 4/15/25.
//

import Foundation
import SQLite

enum TableName: String {
    case events
}

protocol SQLEntity {
    static var tableName: TableName { get }
    func setters() -> [Setter]
}

protocol SQLMappableEntity: SQLEntity {
    init(_ row: Row)
}

struct EventRecord: SQLMappableEntity {
    static var tableName: TableName = .events

    let uuid: UUID
    let dateCreated: Date
    let name: String
    let path: String

    init(
        uuid: UUID = UUID(),
        dateCreated: Date = Date.now,
        name: String,
        path: String
    ) {
        self.uuid = uuid
        self.dateCreated = dateCreated
        self.name = name
        self.path = path
    }

    init(
        _ row: Row
    ) {
        self.uuid = row[Self.uuid]
        self.dateCreated = row[Self.dateCreated]
        self.name = row[Self.name]
        self.path = row[Self.path]
    }

    static let uuid = SQLite.Expression<UUID>("uuid")
    static let dateCreated = SQLite.Expression<Date>("date")
    static let name = SQLite.Expression<String>("name")
    static let path = SQLite.Expression<String>("path")

    func setters() -> [Setter] {
        [
            Self.uuid <- uuid,
            Self.dateCreated <- dateCreated,
            Self.name <- name,
            Self.path <- path
        ]
    }
}

final class PersistenceProvider {

    // MARK: - Private Properties

    private let db: Connection

    // MARK: - Init

    init(
        location: Connection.Location
    ) throws {
        self.db = try Connection(location)
    }

    func createTable<T: SQLEntity>(
        for type: T.Type,
        ifNotExists: Bool = false,
        _ builder: (T.Type, TableBuilder) -> Void
    ) throws {
        let table = Table(T.tableName.rawValue)
        let builder = table.create(ifNotExists: ifNotExists) { tableBuilder in
            builder(T.self, tableBuilder)
        }

        try db.run(builder)
    }

    func insert<T: SQLEntity>(
        _ items: [T]
    ) throws {
        for item in items {
            try insert(item)
        }
    }

    func insert<T: SQLEntity>(
        _ item: T
    ) throws -> Int64 {
        let table = Table(T.tableName.rawValue)
        let insertion = table.insert(item.setters())

        return try db.run(insertion)
    }

    func fetch<T: SQLMappableEntity>(
        _ type: T.Type
    ) throws -> [T] {
        let table = Table(T.tableName.rawValue)
        return try db.prepare(table).map(T.init)
    }
}
