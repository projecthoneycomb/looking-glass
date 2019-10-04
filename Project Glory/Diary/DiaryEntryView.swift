//
//  DiaryEntryView.swift
//  Project Glory
//
//  Created by James Williams on 04/10/2019.
//  Copyright © 2019 James Williams. All rights reserved.
//

import SwiftUI

struct DiaryEntryView: View {
	@State var entry: DiaryEntry
	
	var body: some View {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "d MMMM yyyy"
		let date = dateFormatter.string(from: entry.createdAt)
		dateFormatter.dateFormat = "H:mm"
		let time = dateFormatter.string(from: entry.createdAt)

		return VStack(alignment: .leading) {
			Text(date)
				.font(.subheadline)

			HStack(alignment: .center) {
				Text(self.entry.title!)
					.font(.title)
					.fontWeight(.bold)
				Spacer()
				Text(time)
					.font(.footnote)
			}
			Text(self.entry.body!)
			Spacer()
		}
		.padding()
		.navigationBarTitle(Text(""), displayMode: .inline)
	}
}

struct DiaryEntryView_Previews: PreviewProvider {
    static var previews: some View {
			DiaryEntryView(entry: DiaryEntry())
    }
}
