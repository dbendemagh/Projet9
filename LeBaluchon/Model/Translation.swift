//
//  Translation.swift
//  LeBaluchon
//
//  Created by Daniel BENDEMAGH on 31/10/2018.
//  Copyright © 2018 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

// MARK: - Google Translation Json

// Translation
struct Translation: Decodable {
    let data: Translations
}

struct Translations: Decodable {
    let translations: [TranslatedText]
}

struct TranslatedText: Decodable {
    let translatedText: String
}

// Language list
struct LanguagesList: Decodable {
    let data: Languages
}

struct Languages: Decodable {
    let languages: [Language]
}

// Decodable struct Language also used for Languages Array
// language property is renamed : code
// Example : code = "fr", name = "French"
struct Language: Decodable {
    var code: String
    var name: String
    
    private enum CodingKeys: String, CodingKey {
        case code = "language"
        case name
    }
}
