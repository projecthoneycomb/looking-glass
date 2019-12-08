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
					.offset(x: -40 + ((UIScreen.main.bounds.width - 320) * 0.4), y: 0)
				Spacer()
				Image("RightCelebrate")
					.offset(x: 40 - ((UIScreen.main.bounds.width - 320) * 0.4), y: 0)
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
			}
    }
}
