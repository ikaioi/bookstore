//
//  BookResults.swift
//  BookStore
//
//  Created by Kaio Dantas on 09/10/20.
//

import Foundation


struct BooksResults : Codable{
    let kind: String
    let totalItems: Int
    let items : [Book]
    
    
    init(data: Data) throws {
        self = try JSONDecoder().decode(BooksResults.self, from: data)
    }
}

