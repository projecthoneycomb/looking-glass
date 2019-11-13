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
	@Published var hasBeenOnboarded: Bool
	
	init(version: String) {
		let defaults = UserDefaults.standard
		self.currentVersion = version
		self.hasBeenOnboarded = defaults.bool(forKey: "isOnboardedv2")
		if !self.hasBeenOnboarded {
			LogService.event(name: "Started Onboarding")
		}
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
	
	func setOnboardedState() {
		let defaults = UserDefaults.standard
		LogService.event(name: "Ended Onboarding")
		defaults.set(true, forKey: "isOnboardedv2")
		hasBeenOnboarded = true
	}
}



struct ContentView: View {
		
	@EnvironmentObject var mainService: MainService
	
	init() {
		let transBarAppearance = UINavigationBarAppearance()
		transBarAppearance.configureWithTransparentBackground()
				
		UINavigationBar.appearance().standardAppearance = transBarAppearance
	}
	
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
		
		if(!self.mainService.hasBeenOnboarded) {
			return AnyView(OnboardingView(cb: { self.mainService.setOnboardedState() }))
		}
		
		return AnyView(TabView(selection: smartSelection) {
			MainTabView()
				.tabItem {
					Image(systemName: "house.fill")
					Text("Home")
				}
				.tag(0)
			ReflectionTabView()
				.tabItem {
					Image(systemName: "location.fill")
					Text("Reflection")
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
		)
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
