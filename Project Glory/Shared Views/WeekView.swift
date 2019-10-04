//
//  WeekView.swift
//  projectglory
//
//  Created by James Williams on 25/09/2019.
//  Copyright © 2019 James Williams. All rights reserved.
//

import SwiftUI

struct WeekView: View {
	let spacing: CGFloat = 40.0
		@State var week: [Day]
    var body: some View {
			HStack(alignment: .center, spacing: 10) {
				Group {
					ForEach(week) { day -> AnyView in
						guard let attribute = day.attribute else {
							return AnyView(
								ZStack {
									Rectangle()
										.frame(width: self.spacing, height: self.spacing)
										.cornerRadius(3)
										.foregroundColor(Color("background"))
								}
							)
						}
						
						if let entry = day.entry, let _ = day.entry?.title {
							return AnyView(
								NavigationLink(destination: DiaryEntryView(entry: entry)) {
									ZStack {
										Rectangle()
											.frame(width: self.spacing, height: self.spacing)
											.cornerRadius(3)
											.foregroundColor(attribute.toColor())
										if (day.entry?.body != nil) {
											ZStack {
												Circle()
													.frame(width: 20, height: 20)
													.foregroundColor(.red)
												Image(systemName: "bookmark.fill")
													.resizable()
													.aspectRatio(contentMode: .fit)
													.frame(width: 10, height: 10)
													.foregroundColor(.white)
											}
											.offset(x: 15, y: -15)
										}
								}
							})
						}
						
						return AnyView(
								ZStack {
									Rectangle()
										.frame(width: self.spacing, height: self.spacing)
										.cornerRadius(3)
										.foregroundColor(attribute.toColor())
								})
					}
				}
			}
			.frame(minHeight: 40)
			.padding(-2)
    }
}

struct WeekView_Previews: PreviewProvider {
    static var previews: some View {
			let week = [
				Day(id: 0, name: "Monday", attribute: .amazing),
				Day(id: 1, name: "Tuesday"),
				Day(id: 2, name: "Wednesday", attribute: .amazing),
				Day(id: 3, name: "Thursday", attribute: .amazing),
				Day(id: 4, name: "Friday", attribute: .noInput),
				Day(id: 5, name: "Saturday", attribute: .frustrating),
				Day(id: 6, name: "Sunday", attribute: .frustrating)
			]
			
			return Group {
				WeekView(week: week)
					.frame(maxHeight: 60)
				
				WeekView(week: week)
				.frame(maxHeight: 60)
				.previewDevice(PreviewDevice(rawValue: "iPhone 8"))
				.previewDisplayName("iPhone 8")
			}
    }
}
