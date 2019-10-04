//
//  CompassTabPlaceholderView.swift
//  Project Glory
//
//  Created by James Williams on 04/10/2019.
//  Copyright © 2019 James Williams. All rights reserved.
//

import SwiftUI

struct CompassTabPlaceholderView: View {
    var body: some View {
			VStack {
				Image(systemName: "location.circle.fill")
				.resizable()
				.aspectRatio(contentMode: .fit)
				Text("Compass view will be coming soon!")
					.font(.title)
					.fontWeight(.semibold)
					.multilineTextAlignment(.center)
			}
			.foregroundColor(Color("hc-blue"))
			.padding(100)
    }
}

struct CompassTabPlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        CompassTabPlaceholderView()
    }
}
