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
			HStack(alignment: .center, spacing: 10) {
				ForEach(Attribute(rawValue: entry.attribute)?.toTags() ?? [], id: \.self) { (tag: TagData) in
					Tag(color: tag.color, text: tag.text)
				}
			}
			
			Spacer()
				.frame(height: 15)
			
			Text(date)
				.font(.subheadline)

			if(self.entry.title != nil) {
				Text(self.entry.title!)
				.font(.title)
				.fontWeight(.bold)
			}

			HStack(alignment: .firstTextBaseline) {
				Text(self.entry.body!)
				Spacer()
				Text(time)
					.font(.footnote)

			}
			Spacer()
		}
		.padding(20)
		.navigationBarTitle(Text(""), displayMode: .inline)
	}
}

struct DiaryEntryView_Previews: PreviewProvider {
    static var previews: some View {
			DiaryEntryView(entry: DiaryEntry())
    }
}
