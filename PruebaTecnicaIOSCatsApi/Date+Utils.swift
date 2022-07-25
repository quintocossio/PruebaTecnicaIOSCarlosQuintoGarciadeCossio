//
//  Date+Utils.swift
//  PruebaTecnicaIOSCatsApi
//
//  Created by Quinto Cossio on 25/07/2022.
//

import Foundation

extension Date {
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        return formatter
    }
    
    var dateString: String {
        let dateFormatter = Date.dateFormatter
        dateFormatter.dateFormat = "HH:mm E, d MMM y"
        return dateFormatter.string(from: self)
    }
}
