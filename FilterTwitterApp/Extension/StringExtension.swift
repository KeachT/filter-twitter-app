//
//  String+ExtractURL.swift
//  FilterTwitterApp
//
//  Copyright (c) 2021 Keach.T
//

import Foundation


extension String {
    
    // String型のインスタンスからURLを取り除くメソッド
    func removeURL(text: String) -> String {
        var input = text
        var urls: [String] = []
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count))

        for match in matches {
            guard let range = Range(match.range, in: input) else { continue }
            let url = input[range]
            urls.append(String(url))
        }
        urls.forEach{ url in
            input = input.replacingOccurrences(of: url, with: "")
        }
        
        return input
    }
}
