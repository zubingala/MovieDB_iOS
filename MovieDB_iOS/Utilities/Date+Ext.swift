//
//  Date+Ext.swift
//  MovieDB_iOS
//
//  Created by Zubin Gala on 17/11/24.
//

import Foundation

extension Date {
  func stringValue(format: String) -> String? {
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
    formatter.dateFormat = format
    return formatter.string(from: self)
  }
}
