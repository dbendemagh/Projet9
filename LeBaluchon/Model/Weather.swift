//
//  Weather.swift
//  LeBaluchon
//
//  Created by Daniel BENDEMAGH on 06/11/2018.
//  Copyright © 2018 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

struct Weather: Decodable {
    let query: Query
}

struct Query: Decodable {
    let count: Int
    let created: String
    let lang: String
    let results: Results
}

struct Results: Decodable {
    let channel: [Channel]
}

struct Channel: Decodable {
    let location: Location
    let item: Item
}

struct Location: Decodable {
    let city: String
    let country: String
}

struct Item: Decodable {
    let condition: Condition
}

struct Condition: Decodable {
    let code, date, temp, text: String
}
