//
//  Poll.swift
//  App
//
//  Created by Cory Steers on 11/24/18.
//

import Foundation
import Vapor
import Fluent
import FluentSQLite

struct Poll: Parameter, Content, SQLiteUUIDModel, Migration {
    var id: UUID?
    var title: String
    var option1: String
    var option2: String
    var votes1: Int
    var votes2: Int

    init(_ id: UUID,_ title: String,_ option1: String,_ option2: String) {
        self.id = id
        self.title = title
        self.option1 = option1
        self.option2 = option2
        self.votes1 = 0
        self.votes2 = 0
    }

    static func resolveParameter(with id: String, for title: String, with option1: String, and option2: String, on container: Container) throws -> Poll {
        if let uuid = UUID(id) {
            return Poll(uuid, title, option1, option2)
        } else {
            throw Abort(.badRequest)
        }
    }
}
