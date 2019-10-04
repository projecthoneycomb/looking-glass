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
	@State var input = 0
	
	let week = [
		Day(id: 0, name: "Monday", attribute: .reallyGood),
		Day(id: 1, name: "Tuesday", attribute: .normal),
		Day(id: 2, name: "Wednesday", attribute: .depressed),
		Day(id: 3, name: "Thursday", attribute: .normal),
		Day(id: 4, name: "Friday", attribute: .normal),
		Day(id: 5, name: "Saturday", attribute: .normal),
		Day(id: 6, name: "Sunday", attribute: .normal)
	]
	
	var body: some View {
			NavigationView {
				ScrollView {
					VStack {
						Picker(selection: $selection, label: Text("Picker Name")) {
											Text("7 Days").tag(0)
											Text("Month").tag(1)
											Text("Year").tag(2)
						}
						.pickerStyle(SegmentedPickerStyle())
						.padding(20)
						ArrowView(input: $input)
							.frame(minHeight: 150)
						WeekView(week: self.week)
							.padding(20)
						HStack {
							Stepper("Points \(input)", value: $input, in: -15...15)
						}.padding(20)
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
