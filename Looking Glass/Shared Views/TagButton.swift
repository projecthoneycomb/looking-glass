//
//  TagButton.swift
//  Project Glory
//
//  Created by James Williams on 28/10/2019.
//  Copyright © 2019 James Williams. All rights reserved.
//

import SwiftUI

struct TagButton: View {
	@State var data: TagData
	@State var selected: Bool = false
	var body: some View {
		Button(action: { self.selected.toggle() }) {
			HStack(spacing: 4) {
				Spacer()
				Image(systemName: "person.crop.circle.fill")
				Text(data.text)
				.font(.footnote)
				.fontWeight(.bold)
				.padding(.vertical, 10)
				Spacer()
			}
			.foregroundColor(selected ? Color("hc-branded-text") : .primary)
		}
		.background(selected ? Color("hc-branded-button"): Color("background"))
		.cornerRadius(6)
	}
}

struct TagButton_Previews: PreviewProvider {
    static var previews: some View {
			Group {
				TagButton(data: TagData(text: "Heather", color: .gray))
				TagButton(data: TagData(text: "Dark Button", color: .gray))
				.environment(\.colorScheme, .dark)
				TagButton(data: TagData(text: "Selected Button", color: .gray), selected: true)
				TagButton(data: TagData(text: "Selected Dark Button", color: .gray), selected: true)
				.environment(\.colorScheme, .dark)
			}
			.previewLayout(.fixed(width: 105, height: 45))
    }
}
