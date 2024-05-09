//
//  Source.swift
//  AppCentChallange-2024
//
//  Created by Mertcan Kırcı on 8.05.2024.
//

import Foundation

struct Source: Codable, Hashable {
    let uuid = UUID()
    
    private enum CodingKeys: String, CodingKey { case id, name }
    
    var id: String?
    var name: String?
}

extension Source {
    static func ==(lhs: Source, rhs: Source) -> Bool {
        return lhs.uuid == rhs.uuid
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}


