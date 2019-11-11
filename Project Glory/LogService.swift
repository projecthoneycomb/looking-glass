//
//  LogService.swift
//  Project Glory
//
//  Created by James Williams on 20/10/2019.
//  Copyright © 2019 James Williams. All rights reserved.
//

import Foundation

class LogService {
	
	private struct EventData: Encodable {
			let anonymousId: UUID = UUID()
			let timestamp: Date = Date()
			let event: String
	}
	
	private struct ScreenData: Encodable {
			let anonymousId: UUID = UUID()
			let timestamp: Date = Date()
			let name: String
	}
	
	private static let encoder: JSONEncoder = {
			let encoder = JSONEncoder()
			encoder.dateEncodingStrategy = .formatted(dateFormatter)
			return encoder
	}()
	
	private static let dateFormatter: DateFormatter = {
			let formatter = DateFormatter()
			formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
			formatter.timeZone = TimeZone(secondsFromGMT: 0)
			formatter.locale = Locale(identifier: "en_US_POSIX")
			return formatter
	}()
	
	static func startup(version: String) {
		let formattedVersion = version.replacingOccurrences(of: ".", with: "_")
		LogService.event(name: "open_\(formattedVersion)")
	}
	
	static func event(name: String) {
		let defaults = UserDefaults.standard
		if(defaults.bool(forKey: "optOutLogging")) {
			return
		}
		
		let eventData = EventData(event: name)

		guard let jsonData = try? encoder.encode(eventData) else {
				print("Error while logging event: unable to convert event to JSON")
				return
		}
		
		let url = URL(string: "https://api.segment.io/v1/track")!
		makeRequest(url: url, json: jsonData)
	}
	
	static func screen(name: String) {
		let defaults = UserDefaults.standard
		if(defaults.bool(forKey: "optOutLogging")) {
			return
		}
		
		let eventData = ScreenData(name: name)

		guard let jsonData = try? encoder.encode(eventData) else {
				print("Error while logging event: unable to convert event to JSON")
				return
		}
		
		let url = URL(string: "https://api.segment.io/v1/screen")!
		makeRequest(url: url, json: jsonData)
	}
	
	static func makeRequest(url: URL, json: Data) {
			var request = URLRequest(url: url)
			request.httpMethod = "POST"
			request.httpBody = json
			request.addValue("application/json", forHTTPHeaderField: "Content-Type")
			request.addValue("application/json", forHTTPHeaderField: "Accept")
			request.addValue("Basic MkxtMHBWNm1HdjBvREVtMWVoU3RZWjIzYXJCdHJVUHU6", forHTTPHeaderField: "Authorization")

			let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
					if let error = error {
							print("Error while logging event: \(error)")
					}
			}
			task.resume()
	}
}
