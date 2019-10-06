//
//  SwiftUIView.swift
//  projectglory
//
//  Created by James Williams on 25/09/2019.
//  Copyright © 2019 James Williams. All rights reserved.
//

import SwiftUI

func calculateAngleFromScore(input: Int) -> Double {
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
	
	result.negate() // Reverse direction
	return Double(result)
}

struct ArrowView: View {
	@State var input: Int
	var body: some View {
		VStack {
			HStack(alignment: .center, spacing: 0) {
				Rectangle()
					.frame(width: 140, height: 4)
				Circle()
					.frame(width: 25)
			}
			.rotationEffect(.init(degrees: calculateAngleFromScore(input: input)))
			.animation(.easeInOut(duration: 0.2))
		}
				
	}
}
