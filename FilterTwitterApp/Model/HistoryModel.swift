//
//  HistoryModel.swift
//  FilterTwitterApp
//
//  Copyright (c) 2021 Keach.T
//

// schemaVersion: 1
// schemaVersionの変更ごとにマイグレーションが必要

import Foundation
import RealmSwift

class HistoryModel: Object {

    @objc dynamic var createDate: Date = Date()
    @objc dynamic var searchWord: String?
    var HistorySearchedTweet = List<HistorySearchedTweets>()
}

class HistorySearchedTweets: Object {
    
    @objc dynamic var tweetText: String?
    @objc dynamic var linkURL: String?
    @objc dynamic var mediaURL: String?
    @objc dynamic var mediaImageData: Data?
}
