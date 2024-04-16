//
//  RemoteProduct.swift
//  wishList
//
//  Created by 문기웅 on 4/15/24.
//

import Foundation

struct RemoteProduct: Decodable {
    let id: Int
    let title: String
    let description: String
    let price: Double
    let thumbnail: URL
}
