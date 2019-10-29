//
//  SettingsView.swift
//  projectglory
//
//  Created by James Williams on 26/09/2019.
//  Copyright © 2019 James Williams. All rights reserved.
//

import SwiftUI


struct SettingsTabView: View {
	@ObservedObject var settingsService: SettingsService = SettingsService()
		
	var body: some View {
		let timeOfReminders: Binding<Date> = Binding<Date>( get: { self.settingsService.reminderDate }, set: { newVal in self.settingsService.changeTime(newDate: newVal) })
		return NavigationView {
			VStack(alignment: .leading, spacing: 10) {
				Text("What days do you want to be reminded?")
					.fontWeight(.bold)
				HStack {
					ForEach(settingsService.daysOfWeekSettings, id: \.self) { (day: [DayOfWeek: Bool]) in
						Button(action: { self.settingsService.toggleDay(day: day.keys.first!) }) {
							Spacer()
							Text(day.keys.first!.toLabel())
								.foregroundColor(day.values.first! ? Color.white : Color("hc-main"))
								.fontWeight(.bold)
							Spacer()
						}
						.frame(height: 45)
						.background(day.values.first! ? Color("hc-main") : Color("background"))
					}
					.animation(.easeInOut(duration: 0.1))
				}
				.cornerRadius(6)
				.navigationBarTitle(Text("Settings ⚙️"))

				Spacer()
					.frame(height: 20)
				
				Text("What time do you want to be reminded?")
					.fontWeight(.bold)
				
				HStack {
					Spacer()
					DatePicker(selection: timeOfReminders, displayedComponents: .hourAndMinute) {
						Text("")
					}
					Spacer()
				}
				Spacer()
			}
			.padding(30)
		}
	}
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsTabView()
    }
}
