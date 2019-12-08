//
//  NaturalLanguageService.swift
//  Project Glory
//
//  Created by James Williams on 12/11/2019.
//  Copyright © 2019 James Williams. All rights reserved.
//

import Foundation
import NaturalLanguage

/*
	The natural language service is responible for generating
	metadata for diary entries. This can be tagging them with interesting entities
	for later correlation and suggestion. An entry is also given a sentiment score.

	DiaryEntry
		DiaryEntryText
			- sentiment
		DiaryEntryTag (generated off text/ad hoc)
*/

class NaturalLanguageService {
	static let version = 1
	
	func calculateSentimentFromText(text: String) -> Double {
		let sentimentTagger = NLTagger(tagSchemes: [.sentimentScore])
		sentimentTagger.string = text
		let (sentiment, _) = sentimentTagger.tag(at: text.startIndex, unit: .sentence, scheme: .sentimentScore)
		let score = Double(sentiment?.rawValue ?? "0") ?? 0
		return score
	}
}
