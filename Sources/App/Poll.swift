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

struct Poll: Content, SQLiteUUIDModel, Migration {
    var id: UUID?
    var title: String
    var option1: String
    var option2: String
    var votes1: Int
    var votes2: Int
}
