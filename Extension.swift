//
//  Extension.swift
//  WeatherApp
//
//  Created by yeonBlue on 2021/04/07.
//

import Foundation

extension Date {
    func shortDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        return dateFormatter.string(from: self)
    }
}
