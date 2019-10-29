//
//  DiaryTodayButton.swift
//  Project Glory
//
//  Created by James Williams on 23/10/2019.
//  Copyright © 2019 James Williams. All rights reserved.
//

import SwiftUI

struct DiaryTodayButton: View {
	var hasEntry: Bool
	var body: some View {
		HStack {
			Spacer()
				.frame(width: 30)
			VStack(spacing: 0) {
				Spacer()
				.frame(height: 25)
				HStack {
					Spacer()
					Text(hasEntry ? "Want to add anything more?" : "How is today going?")
						.font(.headline)
						.fontWeight(.bold)
						.foregroundColor(.primary)
						.padding(20)
					Spacer()
				}
				.background(Color("background"))
				.cornerRadius(8)
				HStack {
					Spacer()
					Image(systemName: "bookmark.fill")
						.resizable()
						.foregroundColor(hasEntry ? Color("hc-main") : Color("disabled"))
						.aspectRatio(contentMode: .fit)
						.frame(width: 25, height: 25)
						.offset(x: -10, y: -70)
				}
			}
			Spacer()
			.frame(width: 30)
		}
	}
}

struct DiaryTodayButton_Previews: PreviewProvider {
    static var previews: some View {
			Group {
				DiaryTodayButton(hasEntry: false)
				DiaryTodayButton(hasEntry: false)
					.environment(\.colorScheme, .dark)
				DiaryTodayButton(hasEntry: true)
				DiaryTodayButton(hasEntry: true)
					.environment(\.colorScheme, .dark)
			}
			.previewLayout(.sizeThatFits)
    }
}
