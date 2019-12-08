//
//  NotificationConfigurationView.swift
//  Project Glory
//
//  Created by James Williams on 30/10/2019.
//  Copyright © 2019 James Williams. All rights reserved.
//

import SwiftUI

struct NotificationConfigurationView: View {
	@ObservedObject var settingsService: SettingsService = SettingsService()
	var body: some View {
		self.settingsService.setDefaults()
		
		let timeOfReminders: Binding<Date> = Binding<Date>( get: { self.settingsService.reminderDate }, set: { newVal in self.settingsService.changeTime(newDate: newVal) })

		return VStack(spacing: 0) {
			HStack(spacing: 7) {
				ForEach(settingsService.daysOfWeekSettings, id: \.self) { (day: [DayOfWeek: Bool]) in
					Button(action: { self.settingsService.toggleDay(day: day.keys.first!) }) {
						Spacer()
						Text(day.keys.first!.toLabel())
							.foregroundColor(day.values.first! ? Color("hc-branded-text") : Color("hc-main"))
							.fontWeight(.bold)
							.padding(.vertical, 10)
						Spacer()
					}
					.background(day.values.first! ? Color("hc-branded-button") : Color("background"))
				}
				.cornerRadius(6)
				.animation(.easeInOut(duration: 0.1))
			}

			DatePicker("", selection: timeOfReminders, displayedComponents: .hourAndMinute)
		}
	}
}

struct NotificationConfigurationView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			NotificationConfigurationView()
			NotificationConfigurationView()
				.environment(\.colorScheme, .dark)
		}
	}
}
