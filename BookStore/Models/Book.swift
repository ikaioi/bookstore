//
//  Book.swift
//  BookStore
//
//  Created by Kaio Dantas on 09/10/20.
//

import Foundation

struct Book : Codable {
    let kind: String?
    let id: String?
    let etag: String?
    let selfLink: String?
    let volumeInfo: VolumeInfo?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        kind = try values.decodeIfPresent(String.self, forKey: .kind)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        etag = try values.decodeIfPresent(String.self, forKey: .etag)
        selfLink = try values.decodeIfPresent(String.self, forKey: .selfLink)
        volumeInfo = try values.decodeIfPresent(VolumeInfo.self, forKey: .volumeInfo)
    }
}


struct VolumeInfo : Codable {
    let title: String?
    let subtitle: String?
    let authors: [String]?
    let publisher: String?
    let description: String?
    let pageCount: Int?
    let imageLinks: ImageLinks?
    let infoLink: String?
    let previewLink: String?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        subtitle = try values.decodeIfPresent(String.self, forKey: .subtitle)
        authors = try values.decodeIfPresent([String].self, forKey: .authors)
        publisher = try values.decodeIfPresent(String.self, forKey: .publisher)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        pageCount = try values.decodeIfPresent(Int.self, forKey: .pageCount)
        imageLinks = try values.decodeIfPresent(ImageLinks.self, forKey: .imageLinks)
        infoLink = try values.decodeIfPresent(String.self, forKey: .infoLink)
        previewLink = try values.decodeIfPresent(String.self, forKey: .previewLink)
    }
}


struct ImageLinks : Codable {
    var smallThumbnail: String?
    var thumbnail: String?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        smallThumbnail = try values.decodeIfPresent(String.self, forKey: .smallThumbnail)
        thumbnail = try values.decodeIfPresent(String.self, forKey: .thumbnail)
    }
}





