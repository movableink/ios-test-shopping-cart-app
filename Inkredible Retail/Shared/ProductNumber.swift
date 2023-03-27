//
//  ProductNumber.swift
//  Inkredible Retail
//
//  Created by Movable Ink on 9/9/22.
//

import Foundation

func productNumber(url: URL) -> Int? {
    let path = url.path
//    "\\/p\\/cp\\/([a-zA-Z0-9]+)\.\w{3}\?.*mi_u=([^&]*)"
    let pattern = "products/(\\d+)"
    let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
    guard let match = regex?.firstMatch(in: path, options: [], range: NSRange(location: 0, length: path.utf16.count)) else { return nil }
    guard let productRange = Range(match.range(at: 1), in: path) else { return nil }
    return Int(path[productRange])
}

func matches(string: String, pattern: String) -> [String] {
    let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
    
    let matches = regex?.matches(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count)) ?? []
    return matches.compactMap { Range($0.range(at: 1), in: string) }.map { String(pattern[$0]) }
}
