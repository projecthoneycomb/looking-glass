//
//  UpdateNotesView.swift
//  Project Glory
//
//  Created by James Williams on 20/10/2019.
//  Copyright © 2019 James Williams. All rights reserved.
//

import SwiftUI

struct UpdateNotesView: View {
	
	@State var version: String
	@Environment(\.presentationMode) var presentationMode
	
	@State private var isAnimating = false
	
	var body: some View {
		ZStack {
			HStack {
				Image("LeftCelebrate")
					.offset(x: -40 + ((UIScreen.main.bounds.width - 320) * 0.4), y: self.isAnimating ? -10 : 10)
					.scaleEffect(self.isAnimating ? 1.05 : 1)
					.rotationEffect(self.isAnimating ? Angle(degrees: 2) : Angle(degrees: -2))
					.animation(
						Animation.easeInOut(duration: 8)
						.repeatForever()
					)
				Spacer()
				Image("RightCelebrate")
					.offset(x: 40 - ((UIScreen.main.bounds.width - 320) * 0.4), y: self.isAnimating ? -14 : 6)
					.scaleEffect(self.isAnimating ? 1.05 : 1)
					.rotationEffect(self.isAnimating ? Angle(degrees: -2) : Angle(degrees: 2))
					.animation(
						Animation.easeInOut(duration: 11)
						.repeatForever()
					)
			}
			.onAppear {
				self.isAnimating = true
			}
			HStack {
				Spacer()
				VStack(alignment: .center, spacing: 5) {
					Text("New updates!")
						.font(.title)
						.fontWeight(.bold)
					ForEach(UpdateService.updatesForVersion(version: self.version), id: \.self) { update in
							Text("• " + update)
								.font(.subheadline)
								.fontWeight(.medium)
								.multilineTextAlignment(.center)
								.foregroundColor(.secondary)
						}
					}
					.padding(EdgeInsets(top: 5, leading: 50, bottom: 5, trailing: 50))
				Spacer()
			}
		}
	}
}

struct UpdateNotesView_Previews: PreviewProvider {
    static var previews: some View {
			Group {
				UpdateNotesView(version: "1.0.3")
				UpdateNotesView(version: "1.0.3")
					.previewDevice(PreviewDevice(rawValue: "iPhone SE"))
			}
    }
}
