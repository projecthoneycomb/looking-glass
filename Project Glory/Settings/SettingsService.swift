//
//  SettingsService.swift
//  Project Glory
//
//  Created by James Williams on 04/10/2019.
//  Copyright © 2019 James Williams. All rights reserved.
//

import Foundation
import UserNotifications

enum DayOfWeek: Int, CaseIterable {
	case monday = 2
	case tuesday = 3
	case wednesday = 4
	case thursday = 5
	case friday = 6
	case saturday = 7
	case sunday = 1
	
	func toLabel() -> String {
		switch self {
		case .monday:
			return "M"
		case .tuesday:
			return "T"
		case .wednesday:
			return "W"
		case .thursday:
			return "T"
		case .friday:
			return "F"
		case .saturday:
			return "S"
		case .sunday:
			return "S"
		}
	}
}

class SettingsService: ObservableObject {
	@Published var authStatus: UNAuthorizationStatus = .notDetermined
	@Published var daysOfWeekSettings: [[DayOfWeek: Bool]] = []
	
	@Published var reminderDate: Date = Date()
	
	init() {
		let center = UNUserNotificationCenter.current()
		center.getNotificationSettings { (settings) in
			DispatchQueue.main.async {
				self.authStatus = settings.authorizationStatus
			}
		}
		
		publishSettings()
		publishTime()
	}
	
	func publishTime() {
		let defaults = UserDefaults.standard
		let calendar = Calendar.current
		var dateComponents = DateComponents()
		dateComponents.hour = defaults.integer(forKey: "ReminderHour")
		dateComponents.minute = defaults.integer(forKey: "ReminderMin")
		self.reminderDate = calendar.date(from: dateComponents)!
	}
	
	func publishSettings() {
		let defaults = UserDefaults.standard
		self.daysOfWeekSettings = DayOfWeek.allCases.map { day in
			return [day: defaults.bool(forKey: "DayOfWeek-\(day.rawValue)")]
		}
	}
	
	func toggleDay(day: DayOfWeek) {
		let defaults = UserDefaults.standard
		let current = defaults.bool(forKey: "DayOfWeek-\(day.rawValue)")
		defaults.set(!current, forKey: "DayOfWeek-\(day.rawValue)")
		
		if(!current) {
			scheduleNotificationFor(day: day, hour: 16, minute: 20)
		}
		
		publishSettings()
		scheduleNotifications()
	}
	
	func changeTime(newDate: Date) {
		let defaults = UserDefaults.standard
		let calendar = Calendar.current
		let dateComponents = calendar.dateComponents([.hour, .minute], from: newDate)
		defaults.set(dateComponents.hour, forKey: "ReminderHour")
		defaults.set(dateComponents.minute, forKey: "ReminderMin")
		publishTime()
		scheduleNotifications()
	}
	
	func scheduleNotifications() {
		let defaults = UserDefaults.standard
		let center = UNUserNotificationCenter.current()
		center.removeAllPendingNotificationRequests()
		let turnedOnDays = daysOfWeekSettings.filter { $0.values.first! }
		turnedOnDays.forEach { obj in
			let day = obj.keys.first!
			scheduleNotificationFor(day: day, hour: defaults.integer(forKey: "ReminderHour"), minute: defaults.integer(forKey: "ReminderMin"))
		}
	}
	
	func scheduleNotificationFor(day: DayOfWeek, hour: Int, minute: Int) {
		let center = UNUserNotificationCenter.current()
		let identifier = "HCDailyNotificationForDay-\(day.rawValue)"

		let content = UNMutableNotificationContent()
		content.title = "How has your day gone?"
		content.body = "No matter how it went, capturing how you felt is important in giving you perspective and clarity."
		content.sound = UNNotificationSound.default
		
		var components = DateComponents()
		components.hour = hour
		components.minute = minute
		components.weekday = day.rawValue
		components.timeZone = .current
		
		let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
		
		let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
		center.add(request, withCompletionHandler: { (error) in
			if let error = error {
				print(error)
			}
		})
	}
}
