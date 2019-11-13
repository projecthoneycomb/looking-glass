//
//  UpdateService.swift
//  Project Glory
//
//  Created by James Williams on 20/10/2019.
//  Copyright © 2019 James Williams. All rights reserved.
//

import Foundation
import SwiftUI

class UpdateService {
	
	static func isUpdated(currentVersion: String) -> Bool {
		let defaults = UserDefaults.standard
		
		guard let lastOpenedVersion = defaults.string(forKey: "lastOpenedVersion") else {
			LogService.event(name: "First Open")
			defaults.set(Date(), forKey: "lastVersionSet")
			defaults.set(currentVersion, forKey: "lastOpenedVersion")
			return true
		}
		
		if currentVersion.compare(lastOpenedVersion, options: .numeric) == .orderedDescending {
			defaults.set(Date(), forKey: "lastVersionSet")
			defaults.set(currentVersion, forKey: "lastOpenedVersion")
			return true
		}
		
		if let lastVersionSet = defaults.object(forKey: "lastVersionSet") as? Date {
			return Calendar.current.isDate(lastVersionSet, inSameDayAs: Date())
		}
		
		return false
	}
	
	static func updatesForVersion(version: String) -> [Substring] {
		if let filepath = Bundle.main.path(forResource: version, ofType: "txt") {
			do {
				let contents = try String(contentsOfFile: filepath)
				let updates = contents.split(separator: "\n")
				return updates
			} catch {
				// contents could not be loaded
			}
		} else {
			// example.txt not found!
		}
		
		return []
	}
}
