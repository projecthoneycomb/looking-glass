//
//  ContentView.swift
//  projectglory
//
//  Created by James Williams on 25/09/2019.
//  Copyright © 2019 James Williams. All rights reserved.
//

import SwiftUI

struct ContentView: View {
	@State var selection = 0
	var body: some View {
		return TabView(selection: $selection) {
			DiaryTabView()
				.tabItem {
					Image(systemName: "text.quote")
					Text("Diary")
				}
				.tag(0)
			CompassTabPlaceholderView()
				.tabItem {
					Image(systemName: "location.fill")
					Text("Compass")
				}
				.tag(1)
			SettingsTabPlaceholderView()
				.tabItem {
					Image(systemName: "gear")
					Text("Settings")
				}
				.tag(2)
		}.edgesIgnoringSafeArea(.top)
		.accentColor(Color("hc-blue"))
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
