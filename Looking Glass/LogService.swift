//
//  LogService.swift
//  Project Glory
//
//  Created by James Williams on 20/10/2019.
//  Copyright © 2019 James Williams. All rights reserved.
//

import Foundation

struct Metadata: Encodable {
	let day: String
	let hour: Int
	let minute: Int
}

class LogService {
	
	private struct LogContext: Encodable {
		#if DEBUG
		let environment: String = "development"
		#else
		let environment: String = "production"
		#endif
		let metadata: Metadata?
	}
	
	private struct ErrorContext: Encodable {
		#if DEBUG
		let environment: String = "development"
		#else
		let environment: String = "production"
		#endif
		let name: String
		let description: String
	}
	
	private struct EventData: Encodable {
		let anonymousId: UUID
		let timestamp: Date = Date()
		let event: String
		let context: LogContext
	}
	
	private struct ErrorData: Encodable {
		let anonymousId: UUID
		let timestamp: Date = Date()
		let event: String = "error"
		let context: ErrorContext
	}
	
	private struct ScreenData: Encodable {
		let anonymousId: UUID = UUID()
		let timestamp: Date = Date()
		let name: String
		let context: LogContext = LogContext(metadata: nil)
	}
	
	private static let encoder: JSONEncoder = {
		let encoder = JSONEncoder()
		encoder.dateEncodingStrategy = .formatted(dateFormatter)
		return encoder
	}()
	
	static let dateFormatter: DateFormatter = {
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
	
	static func event(name: String, metadata: Metadata? = nil) {
		let defaults = UserDefaults.standard
		if(defaults.bool(forKey: "optOutLogging")) {
			return
		}
		
		guard let anonIdString = defaults.string(forKey: "anonId"), let anonId = UUID(uuidString: anonIdString) else {
			defaults.set(UUID().uuidString, forKey: "anonId")
			return
		}
		
		let context = LogContext(metadata: metadata)
		let eventData = EventData(anonymousId: anonId, event: name, context: context)

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
	
	static func error(name: String, error: Error) {
		let defaults = UserDefaults.standard
		if(defaults.bool(forKey: "optOutLogging")) {
			return
		}
		
		guard let anonIdString = defaults.string(forKey: "anonId"), let anonId = UUID(uuidString: anonIdString) else {
			defaults.set(UUID().uuidString, forKey: "anonId")
			return
		}
		
		let eventData = ErrorData(anonymousId: anonId, context: ErrorContext(name: name, description: error.localizedDescription))

		guard let jsonData = try? encoder.encode(eventData) else {
			print("Error while logging event: unable to convert event to JSON")
			return
		}
		
		let url = URL(string: "https://api.segment.io/v1/track")!
		makeErrorRequest(url: url, json: jsonData)
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
	
	static func makeErrorRequest(url: URL, json: Data) {
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.httpBody = json
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		request.addValue("Basic RXJZdGtGRVJOSW9FZFNkUjVqWHZlbmNRWTlaaXl5VTE6", forHTTPHeaderField: "Authorization")

		let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
			if let error = error {
				print("Error while logging event: \(error)")
			}
		}
		task.resume()
	}
}
