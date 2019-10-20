//
//  CompassView.swift
//  projectglory
//
//  Created by James Williams on 26/09/2019.
//  Copyright © 2019 James Williams. All rights reserved.
//

import SwiftUI

struct CompassTabView: View {
	@State private var selection = 0
	
	
	@FetchRequest(fetchRequest: DiaryEntry.getLast7DaysOfEntries()) var last7Days: FetchedResults<DiaryEntry>
	
	
	let week = [
		Day(id: "Monday", dayOfWeek: 0, attribute: .amazing),
		Day(id: "Tuesday", dayOfWeek: 1),
		Day(id: "Wednesday", dayOfWeek: 2, attribute: .amazing),
		Day(id: "Thursday", dayOfWeek: 3, attribute: .amazing),
		Day(id: "Friday", dayOfWeek: 4, attribute: .noInput),
		Day(id: "Saturday", dayOfWeek: 5, attribute: .frustrating),
		Day(id: "Sunday", dayOfWeek: 6, attribute: .frustrating)
	]
	
	var body: some View {
		
		return NavigationView {
			ScrollView {
				VStack {
					Picker(selection: $selection, label: Text("Picker Name")) {
										Text("7 Days").tag(0)
										Text("Month").tag(1)
										Text("Year").tag(2)
					}
					.pickerStyle(SegmentedPickerStyle())
					.padding(20)
					ArrowView(input: self.week.reduce(0) { $0 + ($1.attribute?.toPoints() ?? 0) })
						.frame(minHeight: 150)
					WeekView(week: self.week)
						.padding(20)
				}
			}
			.navigationBarTitle(Text("Compass"))
		}
	}
}

struct CompassView_Previews: PreviewProvider {
    static var previews: some View {
        CompassTabView()
    }
}
