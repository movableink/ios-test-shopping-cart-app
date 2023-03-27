//
//  ArrayExt.swift
//  Inkredible Retail
//
//  Created by Movable Ink on 9/9/22.
//

import Foundation

extension Array {
  func splitBy(subSize: Int) -> [[Element]] {
    stride(from: 0, to: self.count, by: subSize)
      .map { (startIndex) -> [Element] in
        let endIndex = (startIndex.advanced(by: subSize) > self.count) ? self.count-startIndex : subSize
        return Array(self[startIndex..<startIndex.advanced(by: endIndex)])
      }
  }
}
