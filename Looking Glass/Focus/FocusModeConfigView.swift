//
//  FocusModeConfigView.swift
//  Project Glory
//
//  Created by James Williams on 20/11/2019.
//  Copyright © 2019 James Williams. All rights reserved.
//

import SwiftUI

struct FocusModeConfigView: View {
	var body: some View {
			FocusModeSoundtrackConfigView()
				.navigationBarTitle(Text(""), displayMode: .inline)
	}
}

struct FocusModeScheduleConfigView: View {
	@State var soundtrack: Soundtrack

	let schedules: [Schedule] = [
		Schedule(id: "pomodoro", name: "Pomodoro", description: "A classic technique to break down tasks into easily manageable chunks.", workingPeriod: 25, breakPeriod: 5),
		Schedule(id: "desktime", name: "Desktime", description: "A lesson like structure that follows almost an hour of focus with a meaningful break.", workingPeriod: 52, breakPeriod: 18),
		Schedule(id: "marathon", name: "Marathon", description: "A one shot marathon to complete a task all in one with total focus.", workingPeriod: 90, breakPeriod: 30)
	]
	
	var body: some View {
		VStack {
			ScrollView {
				VStack(alignment: .center, spacing: 20) {
					Text("Choose your schedule")
						.font(.body)
						.fontWeight(.bold)
					ForEach(schedules) { schedule in
						NavigationLink(destination: FocusModeExtraStepsConfigView(config: FocusModeConfig(soundtrack: self.soundtrack, schedule: schedule))) {
							ScheduleCard(schedule: schedule)
						}
					}
				}
				.padding(30)
			}
			NavigationLink(destination: FocusModeExtraStepsConfigView(config: FocusModeConfig(soundtrack: self.soundtrack, schedule: nil))) {
				Spacer()
				Text("No Schedule")
				.font(.subheadline)
				.fontWeight(.bold)
				.foregroundColor(Color("hc-branded-text"))
				.padding(EdgeInsets(top: 15, leading: 20, bottom: 15, trailing: 20))
				Spacer()
			}
			.background(Color("hc-branded-button"))
			.cornerRadius(8)
			.padding(EdgeInsets(top: 5, leading: 30, bottom: 30, trailing: 30))
		}
	}
}

struct FocusModeSoundtrackConfigView: View {
	let soundtracks: [Soundtrack] = [
		Soundtrack(id: "lofi", name: "Lo-Fi Chill", description: "Lo-fi chill beats to study and relax to", url: URL(string: "http://focus-mux.f6c3d55f36bd46c893dc.uksouth.aksapp.io/live/lofi/index.m3u8")!),
		Soundtrack(id: "electronic", name: "Electronic", description: "Electric instrumentals to help you dial in", url: URL(string: "http://focus-mux.f6c3d55f36bd46c893dc.uksouth.aksapp.io/live/electronic/index.m3u8")!),
//		Soundtrack(id: "classicjazz", name: "Classic Jazz", description: "Electric instrumentals to help you dial in")
	]
	
	@State var selectedSoundtrack: Soundtrack?
	
	var body: some View {
		ScrollView {
			VStack(alignment: .center, spacing: 20) {
				Text("Choose your soundtrack")
					.font(.body)
					.fontWeight(.bold)
				ForEach(soundtracks) { soundtrack in
					Button(action: { self.selectedSoundtrack = soundtrack }) {
						SoundtrackCard(soundtrack: soundtrack)
					}
					.sheet(item: self.$selectedSoundtrack) { soundtrack in
						FocusModeView(config: FocusModeConfig(soundtrack: soundtrack, schedule: nil))
					}
				}
			}
			.padding(30)
		}
	}
}

struct FocusModeExtraStepsConfigView: View {
	var config: FocusModeConfig
	@State var presented: Bool = false
	var body: some View {
		ScrollView {
		VStack(alignment: .center, spacing: 20) {
			Text("Steps you can take to help you focus")
				.font(.title)
				.fontWeight(.bold)
				.multilineTextAlignment(.center)
						
			VStack(alignment: .leading, spacing: 20) {
				Text("Do not disturb mode")
					.font(.subheadline)
					.fontWeight(.bold)
				Group {
					Text("Your phone comes with a mode that stops notifications from disturbing you. We recommend turning this one.")
					Text("Don’t worry about missing something important either, if someone needs to get in touch, they can.")
				}
				.font(.subheadline)
				
				HStack {
					Spacer()
					VStack(spacing: 10) {
						Text("Turn it on by asking Siri:")
						.font(.subheadline)
						Text("“Hey Siri, turn on do not disturb”")
						.font(.body)
						.fontWeight(.bold)
					}
					Spacer()
				}
				
				HStack {
					Spacer()
					Text("Or by tapping this button in Control Centre:")
					.font(.subheadline)
					Spacer()
				}
				
				Image("controlcentre")
				.resizable()
				.scaledToFit()
			}
			
			Spacer()
			
			Button(action: { self.presented = true }) {
				Spacer()
				Text("Start focus mode")
				.font(.subheadline)
				.fontWeight(.bold)
				.foregroundColor(Color("hc-branded-text"))
				.padding(EdgeInsets(top: 15, leading: 20, bottom: 15, trailing: 20))
				Spacer()
			}
			.background(Color("hc-branded-button"))
			.cornerRadius(8)
			.sheet(isPresented: self.$presented,
			onDismiss: { print("finished!") },
			content: { FocusModeView(config: self.config) })
		}
		.padding(30)
		}
	}
}

struct FocusModeConfigView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			NavigationView {
				FocusModeConfigView()
			}
			NavigationView {
				FocusModeConfigView()
			}
			.environment(\.colorScheme, .dark)
		}
	}
}
