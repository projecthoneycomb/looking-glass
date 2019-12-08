//
//  CardView.swift
//  Project Glory
//
//  Created by James Williams on 30/10/2019.
//  Copyright © 2019 James Williams. All rights reserved.
//

import SwiftUI

struct CardView<Content: View>: View {
	@Environment(\.colorScheme) var colorScheme: ColorScheme

	let title: String
	let subtitle: String = ""
	let viewBuilder: () -> Content

	var body: some View {
		VStack(spacing: 10) {
			HStack {
				Text(title)
					.font(.footnote)
					.fontWeight(.bold)
				Spacer()
				Text(subtitle)
					.font(.footnote)
					.fontWeight(.bold)
			}
			viewBuilder()
		}
		.padding(10)
		.background(colorScheme == .dark ? Color("background") : Color.white)
			
		.clipped()
		.cornerRadius(6)
		.shadow(color: .init(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.03), radius: 20)
	}
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
			CardView(title: "How did this week go?") {
				HStack {
					Text("Hey")
					Spacer()
				}
			}
    }
}
