//
//  Todo.swift
//  My Todos
//
//  Created by Ana Carolina B. de Magalhães on 14/10/24.
//

import Foundation

struct Task: Identifiable, Hashable {
    let id = UUID()
    var title: String
    let date: Date
    var isCompleted: Bool
}

func createDate(year: Int, month: Int, day: Int, hour: Int, minute: Int) -> Date {
    var components = DateComponents()
    components.year = year
    components.month = month
    components.day = day
    components.hour = hour
    components.minute = minute
    components.timeZone = TimeZone.current
    
    let calendar = Calendar.current
    return calendar.date(from: components)!
}
