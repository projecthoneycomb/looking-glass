//
//  DiaryService.swift
//  Project Glory
//
//  Created by James Williams on 27/09/2019.
//  Copyright © 2019 James Williams. All rights reserved.
//

import Foundation
import SwiftUI

struct Month: Identifiable {
	var id: Int
	var name: String
	var weeks: [Week]
}

struct Week: Identifiable {
	var id: String
	var weekOfYear: Int
	var days: [Day]
}

struct Day: Identifiable {
	var id: String
	var dayOfWeek: Int
	var attribute: Attribute?
	var entry: DiaryEntry?
}


class DiaryService: ObservableObject {
	@Published var formattedEntries: [Month] = []
	
	init() {}

	func formatDiaryData(entries: FetchedResults<DiaryEntry>) -> [Month] {
		guard let startingEntry = entries.first else {
			return generateBaseDateData(startingDay: Date(), entries: entries)
		}
		return generateBaseDateData(startingDay: startingEntry.createdAt, entries: entries)
	}
	
	func generateBaseDateData(startingDay: Date, entries: FetchedResults<DiaryEntry>) -> [Month] {
		
		let calendar = Calendar(identifier: .iso8601)
		let today = calendar.startOfDay(for: Date())
		let startingMonthId = calendar.component(.month, from: startingDay)
		let startingDayId = calendar.ordinality(of: .day, in: .year, for: startingDay)!
		let currentMonthId = calendar.component(.month, from: today)
		let currentDayId = calendar.ordinality(of: .day, in: .year, for: today)!
		let monthsOfYear = startingMonthId...currentMonthId
		var months = monthsOfYear.map { monthId -> Month in
			var dateComponents = DateComponents()
			dateComponents.month = monthId
			dateComponents.year = 2019
			let firstDayOfMonth = calendar.date(from: dateComponents)!
			let daysOfMonth = calendar.range(of: .day, in: .month, for: firstDayOfMonth)!
			let datesOfMonth = daysOfMonth.compactMap { calendar.date(byAdding: .day, value: $0 - 1, to: firstDayOfMonth) }
			let groupedByWeek = Dictionary(grouping: datesOfMonth) { day in
				calendar.component(.weekOfMonth, from: day)
			}
			
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "LLLL"
			let monthName = dateFormatter.string(from: firstDayOfMonth)
			var month = Month(id: monthId, name: monthName, weeks: [])
			
			for(week, dates) in groupedByWeek {
				let days: [Day] = dates.compactMap { date -> Day in
					let dayInYearId = calendar.ordinality(of: .day, in: .year, for: date)!
					let dayId = calendar.component(.weekday, from: date)
					let dateFormatter = DateFormatter()
					dateFormatter.dateFormat = "EEEE"
					let dayName = dateFormatter.string(from: date)
					if (dayInYearId > currentDayId || dayInYearId < startingDayId) {
						return Day(id: "\(dayId)", dayOfWeek: dayId)
					}
					
					if let entry: DiaryEntry = entries.first(where: { (entry: DiaryEntry) in
						return calendar.isDate(entry.createdAt, inSameDayAs: date)
					}) {
						return Day(id: "\(dayName)-hasAttri", dayOfWeek: dayId, attribute: Attribute.init(rawValue: entry.attribute), entry: entry)
					}
					
					return Day(id: "\(dayName)-noAttri", dayOfWeek: dayId, attribute: .noInput)
				}
				
				month.weeks.append(Week(id: UUID().uuidString, weekOfYear: week, days: days))
			}
			
			month.weeks.sort { $0.weekOfYear < $1.weekOfYear }
			return month
		}
		
		months.sort { $0.id > $1.id }
		return months

	}
}
