//
//  Attribute.swift
//  Project Glory
//
//  Created by James Williams on 04/10/2019.
//  Copyright © 2019 James Williams. All rights reserved.
//

import Foundation
import SwiftUI

struct TagData: Hashable {
	var text: String
	var color: Color
}

enum Attribute: Int16, CaseIterable {
	case noInput = 0
	case amazing = 1
	case reallyGood = 2
	case normal = 3
	case depressed = 4
	case frustrating = 5
	case stressed = 6
	
	func toColor() -> Color {
		switch self {
		case .amazing:
			return Color("hc-pink")
		case .reallyGood:
			return Color("hc-green")
		case .normal:
			return Color("hc-blue")
		case .depressed:
			return Color("hc-purple")
		case .frustrating:
			return Color("hc-yellow")
		case .stressed:
			return Color("hc-orange")
		default:
			return .gray
		}
	}
	
	func toTags() -> [TagData] {
		switch self {
		case .amazing:
			return [TagData(text: "Amazing", color: self.toColor()), TagData(text: "Fantastic", color: self.toColor())]
		case .reallyGood:
			return [TagData(text: "Really good", color: self.toColor()), TagData(text: "Happy", color: self.toColor())]
		case .normal:
			return [TagData(text: "Normal", color: self.toColor()), TagData(text: "Average", color: self.toColor())]
		case .depressed:
			return [TagData(text: "Depressed", color: self.toColor()), TagData(text: "Sad", color: self.toColor())]
		case .frustrating:
			return [TagData(text: "Frustrated", color: self.toColor()), TagData(text: "Angry", color: self.toColor())]
		case .stressed:
			return [TagData(text: "Stressed", color: self.toColor()), TagData(text: "Frantic", color: self.toColor())]
		case .noInput:
			return [TagData(text: "No input", color: self.toColor())]
		}
	}
	
	func toDescription() -> String {
		switch self {
		case .amazing:
			return "Amazing, fantastic day"
		case .reallyGood:
			return "Really good, happy day"
		case .normal:
			return "Normal, average day"
		case .depressed:
			return "Depressing, sad day"
		case .frustrating:
			return "Frustrated, angry day"
		case .stressed:
			return "Stressed, frantic day"
		default:
			return ""
		}
	}
	
	func toPoints() -> Double {
		switch self {
		case .amazing:
			return 3
		case .reallyGood:
			return 1
		case .normal:
			return 0
		case .depressed:
			return -2
		case .frustrating:
			return -3
		case .stressed:
			return -2
		default:
			return 0
		}
	}
}
