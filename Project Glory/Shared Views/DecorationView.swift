//
//  DiaryDecorationView.swift
//  Project Glory
//
//  Created by James Williams on 29/10/2019.
//  Copyright © 2019 James Williams. All rights reserved.
//

import SwiftUI

struct DecorationView: View {
	var body: some View {
		VStack {
			HStack {
				Image("LeftAutumnDecoration")
					.offset(x: -40 + ((UIScreen.main.bounds.width - 320) * 0.4), y: 0)
				Spacer()
				Image("RightAutumnDecoration")
					.offset(x: 40 - ((UIScreen.main.bounds.width - 320) * 0.4), y: 0)
			}
		}
	}
}

struct DecorationView_Previews: PreviewProvider {
    static var previews: some View {
		Group {
			Group {
				DecorationView()
				Group {
					DecorationView()
				}
				.background(Color.black)
			}
			.previewDevice(.init(rawValue: "iPhone 11 Pro Max"))
			Group {
				DecorationView()
				Group {
					DecorationView()
				}
				.background(Color.black)
			}
			.previewDevice(.init(rawValue: "iPhone 8"))
    }
	}
}
