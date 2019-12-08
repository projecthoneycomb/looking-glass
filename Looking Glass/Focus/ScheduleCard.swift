//
//  ScheduleCard.swift
//  Project Glory
//
//  Created by James Williams on 20/11/2019.
//  Copyright © 2019 James Williams. All rights reserved.
//

import SwiftUI

struct Schedule: Identifiable {
	let id: String
	let name: String
	let description: String
	let workingPeriod: Int
	let breakPeriod: Int
}

struct ScheduleCard: View {
	@Environment(\.colorScheme) var colorScheme: ColorScheme
	
	var schedule: Schedule
	var darkGradient: Gradient = Gradient(colors: [Color("background"), Color("background").opacity(0.01)])
	var lightGradient: Gradient = Gradient(colors: [Color.black, Color.black.opacity(0.01)])
	var body: some View {
		VStack {
			HStack {
				Spacer()
				VStack(alignment: .trailing) {
					Text("\(schedule.workingPeriod) minutes working")
						.fontWeight(.bold)
					Text(schedule.breakPeriod == .max ? "Extended break" : "\(schedule.breakPeriod) minutes break")
				}
				.font(.footnote)
			}
			.padding()
			.background(LinearGradient(gradient: colorScheme == .dark ? darkGradient : lightGradient, startPoint: .top, endPoint: .bottom))
			
			Spacer()
				.frame(height: 30)
			
			HStack {
				VStack(alignment: .leading) {
					Text("\(schedule.name)")
						.font(.title)
						.fontWeight(.bold)
					Text("\(schedule.description)")
						.font(.footnote)
				}
				Spacer()
			}
			.padding()
			.background(LinearGradient(gradient: colorScheme == .dark ? darkGradient : lightGradient, startPoint: .bottom, endPoint: .top))
		}
		.foregroundColor(.white)
		.background(
			Image(schedule.id)
			.renderingMode(.original)
			.resizable()
			.aspectRatio(contentMode: .fill)
			.background(colorScheme == .dark ? Color("background") : Color.black)
			
		)
		.cornerRadius(6)
	}
}

struct ScheduleCard_Previews: PreviewProvider {
    static var previews: some View {
			let schedules: [Schedule] = [
				Schedule(id: "pomodoro", name: "Pomodoro", description: "A classic technique to break down tasks into easily manageable chunks.", workingPeriod: 25, breakPeriod: 5),
				Schedule(id: "desktime", name: "Desktime", description: "A lesson like structure that follows almost an hour of focus with a meaningful break.", workingPeriod: 52, breakPeriod: 18),
				Schedule(id: "marathon", name: "Marathon", description: "A one shot marathon to complete a task all in one with total focus.", workingPeriod: 90, breakPeriod: .max)
			]
			
			return Group {
				ScheduleCard(schedule: schedules.first!)
					.previewLayout(.sizeThatFits)
				
				ScheduleCard(schedule: schedules.first!)
					.environment(\.colorScheme, .dark)
					.previewLayout(.sizeThatFits)
				
				ScrollView {
					VStack(alignment: .center, spacing: 20) {
						ForEach(schedules) { schedule in
							ScheduleCard(schedule: schedule)
						}
					}
				}
				.padding(30)
				
				ScrollView {
					VStack(alignment: .center, spacing: 20) {
						ForEach(schedules) { schedule in
							ScheduleCard(schedule: schedule)
						}
					}
				}
				.padding(30)
				.background(Color.black)
				.environment(\.colorScheme, .dark)
			}
    }
}
