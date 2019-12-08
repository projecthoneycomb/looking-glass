//
//  SoundtrackCard.swift
//  Project Glory
//
//  Created by James Williams on 20/11/2019.
//  Copyright © 2019 James Williams. All rights reserved.
//

import SwiftUI

struct Soundtrack: Identifiable {
	let id: String
	let name: String
	let description: String
	let url: URL
}

struct SoundtrackCard: View {
	@Environment(\.colorScheme) var colorScheme: ColorScheme
	
	var soundtrack: Soundtrack
	var darkGradient: Gradient = Gradient(colors: [Color("background").opacity(0.9), Color("background").opacity(0.01)])
	var lightGradient: Gradient = Gradient(colors: [Color.black, Color.black.opacity(0.01)])

	var body: some View {
		VStack {
			HStack {
				Spacer()
				VStack(alignment: .trailing) {
					Text("24/7")
						.fontWeight(.bold)
				}
				.font(.footnote)
			}
			.padding()
			
			Spacer()
				.frame(height: 50)
			
			HStack {
				VStack(alignment: .leading) {
					Text("\(soundtrack.name)")
						.font(.title)
						.fontWeight(.bold)
					Text("\(soundtrack.description)")
						.font(.footnote)
				}
				Spacer()
			}
			.padding()
			.background(LinearGradient(gradient: colorScheme == .dark ? darkGradient : lightGradient, startPoint: .bottom, endPoint: .top))
		}
		.foregroundColor(.white)
		.background(
			Image(soundtrack.id)
			.renderingMode(.original)
			.resizable()
			.aspectRatio(contentMode: .fill)
			.background(Color.black)
		)
		.cornerRadius(6)
	}
}

struct SoundtrackCard_Previews: PreviewProvider {
	static var previews: some View {
		let soundtracks: [Soundtrack] = [
			Soundtrack(id: "lofi", name: "Lo-Fi Chill", description: "Lo-fi chill beats to study and relax to", url: URL(string: "http://focus-mux.f6c3d55f36bd46c893dc.uksouth.aksapp.io/live/lofi/index.m3u8")!),
			Soundtrack(id: "electronic", name: "Electronic", description: "Electric instrumentals to help you dial in", url: URL(string: "http://focus-mux.f6c3d55f36bd46c893dc.uksouth.aksapp.io/live/electronic/index.m3u8")!)
		]
		
		return Group {
			SoundtrackCard(soundtrack: soundtracks.first!)
				.previewLayout(.sizeThatFits)
			
			SoundtrackCard(soundtrack: soundtracks.first!)
				.environment(\.colorScheme, .dark)
				.previewLayout(.sizeThatFits)
			
			ScrollView {
				VStack(alignment: .center, spacing: 20) {
					ForEach(soundtracks) { soundtrack in
						SoundtrackCard(soundtrack: soundtrack)
					}
				}
			}
			.padding(30)
			
			ScrollView {
				VStack(alignment: .center, spacing: 20) {
					ForEach(soundtracks) { soundtrack in
						SoundtrackCard(soundtrack: soundtrack)
					}
				}
			}
			.padding(30)
			.background(Color.black)
			.environment(\.colorScheme, .dark)
		}
	}
}
