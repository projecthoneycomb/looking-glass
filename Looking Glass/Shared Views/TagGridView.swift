//
//  TagButton.swift
//  Project Glory
//
//  Created by James Williams on 28/10/2019.
//  Copyright © 2019 James Williams. All rights reserved.
//

import SwiftUI

struct TagGridLayout {
	var rows: Int
	var columns: Int
	var width: CGFloat
	var height: CGFloat
	var spacing: CGFloat
	var tags: [TagData]
	
	func getTag(row: Int, column: Int) -> TagData? {
		let index = column + row * columns
		return tags.indices.contains(index) ? tags[index] : nil
	}
}

func calculateGridLayout(screenWidth: CGFloat, tags: [TagData]) -> TagGridLayout {
	let minimumGridWidth: CGFloat = 100
	let defaultColumns: CGFloat = 3
	let gutter: CGFloat = 7
	
	let fullWidth = screenWidth - 60

	var spacing = CGFloat((gutter * defaultColumns) - gutter)
	var width = (fullWidth - spacing) / defaultColumns
	var columns = defaultColumns
	
	if(width < minimumGridWidth) {
		spacing = CGFloat((gutter * 2) - gutter)
		width = (fullWidth - spacing) / 2
		columns = 2
	}
	
	let rows = ceil(CGFloat(tags.count) / columns)
	return TagGridLayout(rows: Int(rows), columns: Int(columns), width: width, height: 36, spacing: gutter, tags: tags)
}

struct TagGridView: View {
	@State var tags: [TagData]
	var body: some View {
		
		let gridLayout = calculateGridLayout(screenWidth: UIScreen.main.bounds.width, tags: self.tags)
		return HStack {
			VStack(alignment: .leading, spacing: gridLayout.spacing + 2) {
				ForEach(0...gridLayout.rows - 1, id: \.self) { (row: Int) in
					HStack(spacing: gridLayout.spacing) {
						ForEach(0...gridLayout.columns - 1, id: \.self) { (column: Int) in
							gridLayout.getTag(row: row, column: column) == nil ? AnyView(Spacer()) : AnyView(
								TagButton(data: gridLayout.getTag(row: row, column: column)!)
									.frame(width: gridLayout.width, height: gridLayout.height)
							)
						}
					}
				}
			}
		}
		.frame(minHeight: CGFloat(gridLayout.rows) * (gridLayout.height + gridLayout.spacing + 2))
	}
}

var tags = [TagData(text: "A", color: .blue), TagData(text: "B", color: .blue), TagData(text: "C", color: .blue), TagData(text: "D", color: .blue), TagData(text: "E", color: .blue)]

struct TagGridView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			TagGridView(tags: tags)
				.previewDevice(.init(rawValue: "iPhone SE"))
			TagGridView(tags: tags)
				.previewDevice(.init(rawValue: "iPhone 11 Pro Max"))
		}
		.padding(30)
	}
}
