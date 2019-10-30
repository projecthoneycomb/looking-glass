//
//  SettingsView.swift
//  projectglory
//
//  Created by James Williams on 26/09/2019.
//  Copyright © 2019 James Williams. All rights reserved.
//

import SwiftUI


struct SettingsTabView: View {
	@ObservedObject var settingsService: SettingsService = SettingsService()
		
	var body: some View {
		return NavigationView {
			VStack(alignment: .leading, spacing: 15) {
				NotificationConfigurationView()
				Spacer()
				BasicButton(action: openTestflight, style: .branded, label: "Send feedback")
				BasicButton(action: { self.settingsService.toggleOptIn() }, style: .basic, label: self.settingsService.optedOut ? "Opt in to anonymous logging" : "Opt out of anonymous logging")
			}
			.padding(30)

			.navigationBarTitle(Text("Settings"))
		}
	}
	
	func openTestflight() {
		if let customAppURL = URL(string: "itms-beta://"){
				if(UIApplication.shared.canOpenURL(customAppURL)){
					UIApplication.shared.open(URL(string: "https://beta.itunes.apple.com/v1/app/1482401458")!)
				}
		}
	}
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsTabView()
    }
}
