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
					.offset(x: -30, y: isAnimating ? -10 : 10)
					.animation(
						Animation.easeInOut(duration: 8)
						.repeatForever()
					)
				Spacer()
				Image("RightCelebrate")
					.offset(x: 30, y: isAnimating ? -14 : 6)
					.animation(
						Animation.easeInOut(duration: 11)
						.repeatForever()
					)
			}
			.foregroundColor(.blue)
			.onAppear {
				self.isAnimating = true
			}
			HStack {
				Spacer()
				VStack(alignment: .center, spacing: 5) {
					Text("New updates!")
						.font(.title)
						.fontWeight(.bold)
						ForEach(UpdateService.updatesForVersion(version: version), id: \.self) { update in
							Text("• " + update)
								.font(.subheadline)
								.fontWeight(.medium)
								.multilineTextAlignment(.center)
								.foregroundColor(.secondary)
						}
					}
					.padding(50)
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
