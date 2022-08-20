//
//  WantedList.swift
//  wantedAPI
//
//  Created by 逢坂 美芹 on 2022/08/13.
//

import Foundation

// MARK: - Model
struct Model: Codable {
    let total: Int
    let items: [Item]
    let page: Int
}

// MARK: - Item
struct Item: Codable {
    let rewardText: String?
    let publication: String
    let url: String
    let details: String?
    let gender: Gender?
    let rewardMax: Int
    let rewardMin: Int
    let ageRange: String?
    let title: String
    let images: [Image]
    let uid: String
    let path: String
}

// MARK: - Image
struct Image: Codable {
    let original: String
    let thumb, large: String
    let caption: String?
}

enum Gender: String, Codable {
    case female
    case male
}
