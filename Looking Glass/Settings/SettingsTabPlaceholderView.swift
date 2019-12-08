//
//  SettingsTabPlaceholderView.swift
//  Project Glory
//
//  Created by James Williams on 04/10/2019.
//  Copyright © 2019 James Williams. All rights reserved.
//

import SwiftUI

struct SettingsTabPlaceholderView: View {
    var body: some View {
				VStack {
					Image(systemName: "gear")
					.resizable()
					.aspectRatio(contentMode: .fit)
					Text("Settings will be coming soon!")
						.font(.title)
						.fontWeight(.semibold)
						.multilineTextAlignment(.center)
				}
				.foregroundColor(Color("hc-main"))
				.padding(100)
    }
}

struct SettingsTabPlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsTabPlaceholderView()
    }
}
