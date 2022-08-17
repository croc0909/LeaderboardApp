//
//  MusicModel.swift
//  LeaderboardApp
//
//  Created by AndyLin on 2022/8/17.
//

import Foundation

// 第一層
struct SearchResponse: Decodable {
    let feed: Feed
}

// 第二層
struct Feed: Decodable {
    let title: String
    let results: [Item] // 資料集
}

// 第三層
struct Item: Decodable {
    let artistName: String? // 歌手名稱
    let name: String // 歌曲名稱
    let releaseDate: String? // 發布時間
    let artworkUrl100: URL?  // 圖片
    let url: URL? //
}
