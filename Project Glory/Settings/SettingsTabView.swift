//
//  SettingsView.swift
//  projectglory
//
//  Created by James Williams on 26/09/2019.
//  Copyright © 2019 James Williams. All rights reserved.
//

import SwiftUI

struct SettingsTabView: View {
    var body: some View {
        NavigationView {
					Text("Settings")
					.navigationBarTitle(Text("Settings"))
				}
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsTabView()
    }
}
