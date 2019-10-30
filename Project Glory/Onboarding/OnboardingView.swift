//
//  OnboardingView.swift
//  Project Glory
//
//  Created by James Williams on 30/10/2019.
//  Copyright © 2019 James Williams. All rights reserved.
//

import SwiftUI

enum OnboardingState {
	case thankyou
	case privacy
	case notifications
	case feedback
	case completed
	
	func toEmoji() -> String {
		switch self {
		case .thankyou:
			return "🙏"
		case .privacy:
			return "👮‍♀️"
		case .notifications:
			return "👉"
		case .feedback:
			return "💌"
		case .completed:
			return ""
		}
	}
	
	func toTitle() -> String {
		switch self {
		case .thankyou:
			return "Thank you!"
		case .privacy:
			return "Privacy"
		case .notifications:
			return "Notifications"
		case .feedback:
			return "Feedback"
		case .completed:
			return ""
		}
	}
	
	func nextPage() -> OnboardingState {
		switch self {
		case .thankyou:
			return .privacy
		case .privacy:
			return .notifications
		case .notifications:
			return .feedback
		case .feedback:
			return .completed
		case .completed:
			return .thankyou
		}
	}
	
	func previousPage() -> OnboardingState {
		switch self {
		case .thankyou:
			return .thankyou
		case .privacy:
			return .thankyou
		case .notifications:
			return .privacy
		case .feedback:
			return .notifications
		case .completed:
			return .feedback
		}
	}
}

struct OnboardingView: View {
	@State var currentState: OnboardingState = .thankyou
	var cb: () -> Void
	var body: some View {
		VStack {
			HStack {
				Button(action: reverseOnboarding) {
					Text(currentState != .thankyou ? "Back" : "")
						.foregroundColor(Color("hc-main"))
				}
				Spacer()
			}
			Text(currentState.toEmoji())
				.font(.system(size: 40))
				.padding(5)
			Text(currentState.toTitle())
			.font(.title)
			.fontWeight(.bold)
			
			Group {
				if(currentState == .thankyou) {
					Text("Thank you so much for trying out the Project Looking-Glass beta.")
				}
				
				if(currentState == .privacy) {
					Text("We do not store, transfer or see any of your data that you enter into this app.")
						.fontWeight(.bold)
					Text("If you use iCloud then your data will be backed up to Apple’s servers where Honeycomb can not see it.")
					Text("We have anonymous logging in the app that tells us how you are using the app. This helps us know how we can improve.")
					Button(action: openEventLink) {
						Text("To see a full list of events & the source code of this app tap here.")
							.font(.footnote)
							.padding(.horizontal, 40)
					}
					Text("You can opt out at any time in settings.")
						.font(.footnote)
						.padding(.horizontal, 40)
				}
				
				if(currentState == .notifications) {
					Group {
						Text("Sometimes, you need a nudge to do the right thing and we can be that for you.")
						.layoutPriority(1)
						Text("When do you want to be asked how your day went?")
						.layoutPriority(1)
						Text("We’ve preselected week days for you.")
							.font(.footnote)
							.foregroundColor(.secondary)
					}
					NotificationConfigurationView()
				}

				
				if(currentState == .feedback) {
					Text("And finally, we would love any and all feedback you have about Project Looking-Glass.")
					Text("At any point in the settings tab you can tap the “Send feedback” button and we’ll get right to it.")
				}
			}
			.padding(10)
			.multilineTextAlignment(.center)
			
			Spacer()
			BasicButton(action: progressOnboarding, style: .branded, label: currentState == .feedback ? "Done" : "Next")
		}
		.padding(30)
	}
	
	func progressOnboarding() {
		currentState = currentState.nextPage()
		if(currentState == .completed) {
			cb()
		}
	}
	
	func reverseOnboarding() {
		currentState = currentState.previousPage()
	}
	
	func openEventLink() {
		UIApplication.shared.open(URL(string: "https://projecthoneycomb.org")!)
	}
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
			OnboardingView(cb: {})
    }
}
