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
			let v: Int = 1
			let ua: String = "ios"
			let platform: String = "ios"
			#if targetEnvironment(simulator)
			let hostname: String = "sim.projectglory.projecthoneycomb.org"
			#else
			let hostname: String = "projectglory.projecthoneycomb.org"
			#endif
			let date: Date = Date()
			let events: [String]
	}
	
	private static let encoder: JSONEncoder = {
			let encoder = JSONEncoder()
			encoder.keyEncodingStrategy = .convertToSnakeCase
			encoder.dateEncodingStrategy = .formatted(dateFormatter)
			return encoder
	}()
	
	private static let dateFormatter: DateFormatter = {
			let formatter = DateFormatter()
			formatter.dateFormat = "yyyy-MM-dd"
			return formatter
	}()
	
	static func startup(version: String) {
		let formattedVersion = version.replacingOccurrences(of: ".", with: "_")
		LogService.event(names: ["open_\(formattedVersion)"])
	}
	
	static func event(name: String) {
		LogService.event(names: [name])
	}
	
	static func event(names: [String]) {
		let eventData = EventData(events: names)

		guard let jsonData = try? encoder.encode(eventData) else {
				print("Error while logging event: unable to convert event to JSON")
				return
		}

		let url = URL(string: "https://api.simpleanalytics.io/events")!
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.httpBody = jsonData
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("application/json", forHTTPHeaderField: "Accept")

		let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
				if let error = error {
						print("Error while logging event: \(error)")
				}
		}
		task.resume()
	}
}
