//
//  Translation.swift
//  LeBaluchon
//
//  Created by Daniel BENDEMAGH on 31/10/2018.
//  Copyright © 2018 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

struct Translation: Decodable {
    let data: Translations
}

struct Translations: Decodable {
    let translations: [TranslatedText]
}

struct TranslatedText: Decodable {
    let translatedText: String
}


