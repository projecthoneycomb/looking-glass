//
//  FocusModeService.swift
//  Looking Glass
//
//  Created by James Williams on 08/12/2019.
//  Copyright © 2019 James Williams. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import MediaPlayer

enum PlaybackStatus {
	case playing
	case paused
	case error
	case buffering
	case stopped
}

class FocusModeService: ObservableObject {
	@Published var playbackStatus: PlaybackStatus = .stopped {
		didSet {
			switch playbackStatus {
			case .paused:
				self.pause()
			case .playing:
				self.play()
			case .error:
				return
			case .buffering:
				return
			case .stopped:
				self.stop()
			}
		}
	}
	
	var stream: URL? {
		didSet {
			self.start()
		}
	}
	
	private var player: AVPlayer?
	
	init() {
		let commandCenter = MPRemoteCommandCenter.shared()
		commandCenter.playCommand.isEnabled = true
		commandCenter.pauseCommand.isEnabled = true
		commandCenter.playCommand.addTarget(handler: handlePlayCommand)
		commandCenter.pauseCommand.addTarget(handler: handlePauseCommand)
	}
	
	func handlePlayCommand(_ action: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
		self.play()
		return .success
	}
	
	@objc func handlePauseCommand(_ action: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
		self.pause()
		return .success
	}
	
	func start() {
		do {
			try AVAudioSession.sharedInstance().setCategory(.playback)
			try AVAudioSession.sharedInstance().setActive(true)
			
			guard let url = stream else { return }
			let asset = AVAsset(url: url)
			let playerItem = AVPlayerItem(asset: asset)
			self.player = AVPlayer(playerItem: playerItem)
			self.playbackStatus = .buffering
			
			Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { timer in
				self.playbackStatus = .playing
			}

		} catch let error as NSError {
				self.playbackStatus = .error
				print(error.localizedDescription)
		}
	}
	
	func play() {
		self.player?.play()
	}
	
	func pause() {
		self.player?.pause()
	}
	
	func stop() {
		self.player = nil
	}
}
