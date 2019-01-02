//
//  PollContext.swift
//  App
//
//  Created by Cory Steers on 1/1/19.
//

import Foundation

struct PollContext: Codable {
    var ttl: String
    var option1: String
    var option2: String
    var votes1: Int
    var votes2: Int
}
