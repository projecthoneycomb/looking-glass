//
//  FocusModeView.swift
//  Project Glory
//
//  Created by James Williams on 20/11/2019.
//  Copyright © 2019 James Williams. All rights reserved.
//

import SwiftUI

struct FocusModeConfig: Identifiable {
	let id: UUID = UUID()
	let soundtrack: Soundtrack
	let schedule: Schedule?
}

struct FocusModeView: View {
	@State var isShown = false
	var config: FocusModeConfig

	@ObservedObject var focusModeService: FocusModeService = FocusModeService()
	var body: some View {
		ZStack {
			VStack {
				Spacer()
					.frame(height: 30)
				Image("\(config.soundtrack.id)-upper")
				.resizable()
				.scaleEffect(1.2)
				.aspectRatio(contentMode: .fit)
				.offset(x: 0, y: self.isShown ? 0 : -50)
				.animation(.easeInOut(duration: 0.6))
				
				Spacer()
				HStack {
					Spacer()
				}
				
				Image("\(config.soundtrack.id)-lower")
				.resizable()
				.aspectRatio(contentMode: .fit)
				.offset(x: 0, y: self.isShown ? 20 : 70)
				.animation(.easeInOut(duration: 0.8))
			}
			.background(LinearGradient(gradient: Gradient(colors: [Color("\(config.soundtrack.id)-start"), Color("\(config.soundtrack.id)-end")]), startPoint: .top, endPoint: .bottom))
			.edgesIgnoringSafeArea([.top, .bottom])
			.onAppear(perform: {
				self.isShown = true
				self.focusModeService.stream = self.config.soundtrack.url
			})
			.onDisappear(perform: {
				self.focusModeService.playbackStatus = .stopped
			})
			
			VStack {
				HStack {
					VStack(alignment: .leading) {
						Spacer()
						.frame(height: 100)
						Text("\(config.soundtrack.name)")
						.font(.largeTitle)
						.fontWeight(.bold)
						Text(config.soundtrack.description)
						.font(.headline)
					}
					Spacer()
				}
				Spacer()
				.frame(height: 100)
				
				ZStack {
					
				ProgressBar().stroke(Color.white.opacity(0.6), lineWidth: 20)
				.frame(width: 180, height: 180)

						
				
				if(focusModeService.playbackStatus == .paused) {
					Button(action: { self.focusModeService.playbackStatus = .playing
					}) {
						Image(systemName: "play.circle.fill")
						.resizable()
						.frame(width: 140, height: 140)
					}
				}
				
				if(focusModeService.playbackStatus == .playing) {
					Button(action: { self.focusModeService.playbackStatus = .paused
					}) {
						Image(systemName: "pause.circle.fill")
						.resizable()
						.frame(width: 140, height: 140)
					}
				}
				
				if(focusModeService.playbackStatus == .buffering) {
					ActivityIndicator()
					.frame(width: 140, height: 140)
				}
				
				if(focusModeService.playbackStatus == .error) {
					Image(systemName: "xmark.octagon.fill")
					.resizable()
					.frame(width: 140, height: 140)
				}
					
				}
				
				Spacer()
			}
			.navigationBarTitle("", displayMode: .inline)
			.navigationBarBackButtonHidden(true)
			.foregroundColor(.white)
			.padding()
		}
	}
}

struct ProgressBar: Shape {
		func path(in rect: CGRect) -> Path {
				return Path(ellipseIn: rect)
		}
}

struct ActivityIndicator: View {

  @State private var isAnimating: Bool = false

  var body: some View {
    GeometryReader { (geometry: GeometryProxy) in
      ForEach(0..<4) { index in
        Group {
          Circle()
            .frame(width: 25, height: 25)
            .scaleEffect(!self.isAnimating ? 1 - CGFloat(index) / 5 : 0.2 + CGFloat(index) / 5)
            .offset(y: geometry.size.width / 10 - geometry.size.height / 2)
          }.frame(width: geometry.size.width, height: geometry.size.height)
            .rotationEffect(!self.isAnimating ? .degrees(0) : .degrees(360))
            .animation(Animation
              .timingCurve(0.5, 0.15 + Double(index) / 5, 0.25, 1, duration: 1.5)
              .repeatForever(autoreverses: false))
        }
      }
    .aspectRatio(1, contentMode: .fit)
    .onAppear {
        self.isAnimating = true
    }
  }
}

struct FocusModeWrapperView: View {
	@State var config: FocusModeConfig?

	var body: some View {
		Button(action: { self.config = FocusModeConfig(soundtrack: Soundtrack(id: "lofi", name: "Lo-Fi Chill", description: "Lo-fi chill beats to study and relax to", url: URL(string: "http://focus-mux.f6c3d55f36bd46c893dc.uksouth.aksapp.io/live/lofi/index.m3u8")!), schedule: Schedule(id: "pomodoro", name: "Pomodoro", description: "A classic technique to break down tasks into easily manageable chunks.", workingPeriod: 25, breakPeriod: 5)) }) {
			Text("Go")
		}
		.sheet(item: self.$config,
		onDismiss: { print("finished!") },
		content: { FocusModeView(config: $0) })
	}
}

struct FocusModeView_Previews: PreviewProvider {
    static var previews: some View {
			FocusModeWrapperView()
    }
}
