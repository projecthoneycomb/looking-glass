//
//  CompassView.swift
//  projectglory
//
//  Created by James Williams on 26/09/2019.
//  Copyright © 2019 James Williams. All rights reserved.
//

import SwiftUI

struct ReflectionTabView: View {
	@Environment(\.colorScheme) var colorScheme: ColorScheme
	
	@State private var selection = 0
	private var reflectionService = ReflectionService()
	
	@FetchRequest(fetchRequest: DiaryEntry.getLast7DaysOfEntries()) var last7Days: FetchedResults<DiaryEntry>
	
	var body: some View {
		let days: [Day] = reflectionService.generateDays(entries: last7Days)
		let direction = reflectionService.calculateDirection(entries: last7Days)
		let turbulance = reflectionService.calculateTurbulance(entries: last7Days)
		
		let calendar = Calendar.current
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "EEEE"
		let numberFormatter = NumberFormatter()
		numberFormatter.numberStyle = .ordinal
		numberFormatter.locale = Locale.current
		
		let firstDay = reflectionService.firstDate(entries: last7Days)
		let firstDayString = dateFormatter.string(from: firstDay)
		let firstDayComponents = calendar.component(.day, from: firstDay)
		let firstDayOrdinal = numberFormatter.string(for: firstDayComponents)!
		
		let lastDay = reflectionService.lastDate(entries: last7Days)
		let lastDayString = dateFormatter.string(from: lastDay)
		let lastDayComponents = calendar.component(.day, from: lastDay)
		let lastDayOrdinal = numberFormatter.string(for: lastDayComponents)!
		
		dateFormatter.dateFormat = "MMMM yyyy"
		let monthAndYear = dateFormatter.string(from: firstDay)
		
		return NavigationView {
			Group {
				if(self.last7Days.count < 7) {
					VStack(spacing: 20) {
						Spacer()
						Text("🔓")
							.font(.system(size: 50))
						Text("\(7 - self.last7Days.count) days left until reflection is unlocked")
							.font(.title)
							.fontWeight(.bold)
							.multilineTextAlignment(.center)
						Spacer()
					}
					.padding(30)
				}
				
				VStack {
					ZStack {
						DecorationView()
						HStack {
							Spacer()
							VStack(spacing: -2) {
								Text("\(firstDayString) \(firstDayOrdinal) -")
									.fontWeight(.bold)
								Text("\(lastDayString) \(lastDayOrdinal)")
									.fontWeight(.bold)
								Text("\(monthAndYear)")
								.fontWeight(.bold)
								.font(.body)
								.foregroundColor(.secondary)
							}
							.font(.title)
							Spacer()
						}
					}
					VStack(spacing: 10) {
						CardView(title: "How did this week go?") {
							VStack {
								WeekView(week: days.reversed())
							}
						}
						CardView(title: "Compass") {
							VStack(alignment: .center) {
								Text("\(direction)")
									.font(.largeTitle)
									.fontWeight(.bold)
									.foregroundColor(.secondary)
							}
						}
						CardView(title: "Turbulence") {
							VStack(alignment: .center) {
								Text("\(turbulance)")
									.font(.largeTitle)
									.fontWeight(.bold)
									.foregroundColor(.secondary)
							}
						}
					}
					.padding(.horizontal, 20)
					Spacer()
				}
				.background(colorScheme == .dark ? Color.black : Color("background"))
			}
			.navigationBarTitle(Text("Reflection"))
		}
	}
}

struct ReflectionTabView_Previews: PreviewProvider {
    static var previews: some View {
			Group {
				ReflectionTabView()
				ReflectionTabView()
					.previewDevice(.init(rawValue: "iPhone 11 Pro Max"))
			}
    }
}
