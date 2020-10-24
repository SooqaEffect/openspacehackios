//
//  DataExtensions.swift
//  OpenApp
//
//  Created by Вячеслав Яшунин on 23.10.2020.
//

import Foundation

extension Data {
    mutating func appendStringData(_ string: String) {
    if let data = string.data(using: .utf8) {
      self.append(data)
    }
  }
}
