//
//  ReflectionService.swift
//  Project Glory
//
//  Created by James Williams on 30/10/2019.
//  Copyright © 2019 James Williams. All rights reserved.
//

import Foundation
import SwiftUI
import SigmaSwiftStatistics

class ReflectionService {
	
	func calculateAngleFromScore(input: Double) -> Double {
		var score = CGFloat(input)
		var isNegative = false
		if(score < 0) {
			isNegative = true
			score.negate()
		}
		
		var result: CGFloat = log(score + 1) / 0.02 * log(2)
		
		if(result > 90) {
			result = 90
		}
		
		if(isNegative) {
			result.negate()
		}
		
		// result.negate() // Reverse direction
		return Double(result)
	}
	
	func calculateDirection(entries: FetchedResults<DiaryEntry>) -> Double {
		let points = entries.reduce(0, { x, y in
			x + (Attribute(rawValue: y.attribute)?.toPoints() ?? 0)
		})
		return self.calculateAngleFromScore(input: points)
	}
	
	func calculateTurbulance(entries: FetchedResults<DiaryEntry>) -> Double {
		let points = entries.map { (entry: DiaryEntry) -> Double in
			guard let attribute = Attribute(rawValue: entry.attribute) else {
				return 0
			}
			return attribute.toPoints()
		}
		return Sigma.standardDeviationPopulation(points) ?? 0
	}
	
	func generateDays(entries: FetchedResults<DiaryEntry>) -> [Day] {
		return entries.enumerated().map { (arg) -> Day in
			let (index, entry) = arg
			return Day(id: "\(entry.createdAt)", dayOfWeek: index, attribute: Attribute(rawValue: entry.attribute), entry: entry)
		}
	}
	
	func firstDate(entries: FetchedResults<DiaryEntry>) -> Date {
		guard let firstEntry = entries.last else {
			return Date()
		}
		
		return firstEntry.createdAt
	}
	
	func lastDate(entries: FetchedResults<DiaryEntry>) -> Date {
		guard let lastEntry = entries.first else {
			return Date()
		}
		
		return lastEntry.createdAt
	}
}
