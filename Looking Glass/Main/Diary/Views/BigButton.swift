//
//  BigButton.swift
//  Project Glory
//
//  Created by James Williams on 03/10/2019.
//  Copyright © 2019 James Williams. All rights reserved.
//

import SwiftUI

struct BigButton: View {
	@State var text: String
	@State var attribute: Attribute
	var body: some View {
		HStack {
			Spacer()
			VStack {
				Spacer()
				Text(self.text)
					.font(.system(size: 17))
					.fontWeight(.bold)
					.foregroundColor(.white)
					.multilineTextAlignment(.center)
					.lineLimit(2)
					.allowsTightening(true)
					.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
				Spacer()
			}
			Spacer()
		}.background(self.attribute.toColor())
		.cornerRadius(8, antialiased: true)
	}
}

func getGradientFromAttribute(attribute: Attribute) -> Gradient {
	switch attribute {
	case .amazing:
		return Gradient(colors: [Color("hc-grad-pink-s"), Color("hc-grad-pink-e")])
	case .reallyGood:
		return Gradient(colors: [Color("hc-grad-green-s"), Color("hc-grad-green-e")])
	case .normal:
		return Gradient(colors: [Color("hc-grad-blue-s"), Color("hc-grad-blue-e")])
	case .depressed:
		return Gradient(colors: [Color("hc-grad-purple-s"), Color("hc-grad-purple-e")])
	case .frustrating:
		return Gradient(colors: [Color("hc-grad-yellow-s"), Color("hc-grad-yellow-e")])
	case .stressed:
		return Gradient(colors: [Color("hc-grad-orange-s"), Color("hc-grad-orange-e")])
	default:
		return Gradient(colors: [.gray])
	}
}

struct BigButton_Previews: PreviewProvider {
    static var previews: some View {
			ForEach(Attribute.allCases, id: \.self) { (at: Attribute) in
				BigButton(text: at.toDescription(), attribute: at)
			}
			.previewLayout(.fixed(width: 160, height: 75))
    }
}
