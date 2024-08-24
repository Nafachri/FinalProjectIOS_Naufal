//
//  TimeStampsFormatter.swift
//  HistoryFeature
//
//  Created by Naufal Al-Fachri on 22/08/24.
//

import Foundation

public extension String {
  func convertDateFormat(from currentFormat: String, to newFormat: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = currentFormat
    let date = dateFormatter.date(from: self)
    dateFormatter.dateFormat = newFormat
    return dateFormatter.string(from: date ?? Date())
  }
}
