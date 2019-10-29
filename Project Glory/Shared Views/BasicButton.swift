//
//  Button.swift
//  Project Glory
//
//  Created by James Williams on 28/10/2019.
//  Copyright © 2019 James Williams. All rights reserved.
//

import SwiftUI


enum ButtonStyle {
	case basic
	case branded
}

enum ButtonLayout {
	case flex
	case fixed
}

struct BasicButton: View {
	@State var action: () -> Void
	var style: ButtonStyle = .basic
	var layout: ButtonLayout = .flex
	var label: String

	
	var body: some View {
		Button(action: action) {
			if(layout == .flex) {
				Spacer()
			}
			Text(label)
			.font(.subheadline)
			.fontWeight(.bold)
			.foregroundColor(style == .branded ? Color("hc-branded-text") : .primary)
			.padding(EdgeInsets(top: 15, leading: 20, bottom: 15, trailing: 20))
			if(layout == .flex) {
				Spacer()
			}
		}
		.background(Color(style == .branded ? "hc-branded-button" : "background"))
		.cornerRadius(8)
	}
}

struct BasicButton_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			Group {
				BasicButton(action: { print("Pressed!") }, label: "Preview button")
					.previewLayout(.sizeThatFits)
				BasicButton(action: { print("Pressed!") }, style: .branded, label: "Preview button")
				.previewLayout(.sizeThatFits)
			}
			Group {
				BasicButton(action: { print("Pressed!") }, label: "Preview button")
					.previewLayout(.sizeThatFits)
				BasicButton(action: { print("Pressed!") }, style: .branded, label: "Preview button")
				.previewLayout(.sizeThatFits)
			}
			.environment(\.colorScheme, .dark)
		}
	}
}
