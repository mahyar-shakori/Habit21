//
//  QuotesResponse.swift
//  Habit21
//
//  Created by Mahyar on 4/19/23.
//

import Foundation
struct QuotesResponse : Codable {
	let quote : String?
	let author : String?
	let category : String?

	enum CodingKeys: String, CodingKey {

		case quote = "quote"
		case author = "author"
		case category = "category"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		quote = try values.decodeIfPresent(String.self, forKey: .quote)
		author = try values.decodeIfPresent(String.self, forKey: .author)
		category = try values.decodeIfPresent(String.self, forKey: .category)
	}
}
