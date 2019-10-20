//
//  ContentView.swift
//  projectglory
//
//  Created by James Williams on 25/09/2019.
//  Copyright © 2019 James Williams. All rights reserved.
//

import SwiftUI
import Combine


extension NSNotification.Name {
	static let onNotificationStart = Notification.Name("on-notification-start")
}

class MainService: ObservableObject {
	@Published var notificationStart: Bool = false
	@Published var currentSelection: Int = 0
	var currentVersion: String
	@Published var updateModelState: Bool?
	
	init(version: String) {
		self.currentVersion = version
		LogService.startup(version: version)
		NotificationCenter.default.addObserver(self, selector: #selector(self.handleNotification), name: .onNotificationStart, object: nil)
	}
	
	@objc public func handleNotification() {
		DispatchQueue.main.async {
			LogService.event(name: "diary_start_entry_from_notification")
			self.notificationStart = true
		}
	}
	
	func clearState() {
		notificationStart = false
	}
}



struct ContentView: View {
		
	@EnvironmentObject var mainService: MainService
	var body: some View {
		
		let smartSelection = Binding<Int>( get: {
			if(self.mainService.notificationStart && self.mainService.currentSelection != 0) {
				self.mainService.currentSelection = 0
			}
			let selection = self.mainService.currentSelection
			return selection
		}, set: { newVal in
			self.mainService.currentSelection = newVal
		})
		
		return TabView(selection: smartSelection) {
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
			SettingsTabView()
				.tabItem {
					Image(systemName: "gear")
					Text("Settings")
				}
				.tag(2)
		}.edgesIgnoringSafeArea(.top)
		.accentColor(Color("hc-main"))
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
