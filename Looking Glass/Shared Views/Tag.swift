//
//  Tag.swift
//  Project Glory
//
//  Created by James Williams on 21/10/2019.
//  Copyright © 2019 James Williams. All rights reserved.
//

import SwiftUI

struct Tag: View {
	@State var data: TagData?
	@State var color: Color?
	@State var text: String?
	@Environment(\.colorScheme) var colorScheme: ColorScheme
	
	var body: some View {
		var title = ""
		var baseColor: Color = .blue
		
		if(text == nil) {
			title = data?.text ?? ""
		} else {
			title = text ?? ""
		}
		
		if(color == nil) {
			baseColor = data?.color ?? .blue
		} else {
			baseColor = color ?? .blue
		}
		
		return HStack {
			Spacer()
			Text(title)
				.font(.subheadline)
				.fontWeight(.bold)
				.padding(10)
				.foregroundColor(baseColor)
			Spacer()
		}
		.overlay(
			RoundedRectangle(cornerRadius: 6)
			.foregroundColor(color)
			.opacity(colorScheme == ColorScheme.light ? 0.1 : 0.2)
			.brightness(colorScheme == ColorScheme.light ? 0 : 0.4)
		)
	}
}

struct Tag_Previews: PreviewProvider {
    static var previews: some View {
			Group {
				Tag(color: Color("hc-main"), text: "Honeycomb")
				ForEach([Attribute.amazing], id: \.self) { (attribute: Attribute) in
					Group {
						ForEach(attribute.toTags(), id: \.self) { (tag: TagData) in
							Tag(color: tag.color, text: tag.text)
						}
						ForEach(attribute.toTags(), id: \.self) { (tag: TagData) in
							Tag(color: tag.color, text: tag.text)
						}
						.background(Color.black)
						.environment(\.colorScheme, .dark)
					}
				}
			}
			.previewLayout(.sizeThatFits)
    }
}
