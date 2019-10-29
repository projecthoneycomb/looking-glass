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
		
		let texts: [DiaryEntryText] = Array(entry.entries ?? Set())
		
		return ZStack(alignment: .top) {
			DiaryDecorationView()
			VStack(alignment: .leading) {
				Spacer()
					.frame(height: 100)
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
				
				if (self.entry.body != nil) {
					HStack(alignment: .firstTextBaseline) {
						Text(self.entry.body!)
						Spacer()
						Text(time)
							.font(.footnote)

					}
				}
				
				if(texts.count > 0) {
					ForEach(texts, id: \.createdAt) { (textEntry: DiaryEntryText) in
						HStack(alignment: .firstTextBaseline) {
							Text(textEntry.text ?? "")
							Spacer()
							Text(dateFormatter.string(from: textEntry.createdAt!))
							.font(.footnote)
						}
					}
				}

				Spacer()
			}
			.padding(20)
			.navigationBarTitle(Text(""), displayMode: .inline)
		}
	}
}

struct DiaryEntryView_Previews: PreviewProvider {
    static var previews: some View {
			DiaryEntryView(entry: DiaryEntry())
    }
}
