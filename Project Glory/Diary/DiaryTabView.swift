//
//  DiaryView.swift
//  projectglory
//
//  Created by James Williams on 26/09/2019.
//  Copyright © 2019 James Williams. All rights reserved.
//

import SwiftUI

struct DiaryTabView: View {
	@ObservedObject var diaryService: DiaryService = DiaryService()
	
	@Environment(\.managedObjectContext) var managedObjectContext
	@FetchRequest(fetchRequest: DiaryEntry.getAllDiaryEntries()) var diaryEntries: FetchedResults<DiaryEntry>
	@FetchRequest(fetchRequest: DiaryEntry.getEntryFromToday()) var entriesFromToday: FetchedResults<DiaryEntry>
	
	@State private var showModal: Bool = false
		
	var body: some View {
		let formattedEntries: [Month] = self.diaryService.formatDiaryData(entries: self.diaryEntries)
		
		return NavigationView {
			ScrollView {
				Group {
					Button(action: {
							self.showModal = true
					}) {
							HStack {
								Text(self.entriesFromToday.count == 0 ? "Do you want to write today's entry?" : "Do you want to add to today's entry?")
									.fontWeight(.bold)
									.foregroundColor(.white)

							}
					}
					.padding(EdgeInsets(top: 10, leading: 25, bottom: 10, trailing: 25))
					.background(Color("hc-blue"))
					.cornerRadius(.infinity)
					.sheet(isPresented: self.$showModal) {
						if(self.entriesFromToday.count == 1) {
							DiaryAttributeInputView(managedObjectContext: self.managedObjectContext, inputStage: .notImplemented)
						} else {
							DiaryAttributeInputView(managedObjectContext: self.managedObjectContext, inputStage: .attributeInput)
						}
					}
					HStack {
						Spacer()
						VStack(alignment: .leading, spacing: 10) {
							ForEach(formattedEntries) {	(month: Month) in
								VStack(alignment: .leading) {
									Text(month.name)
										.font(.title)
										.fontWeight(.bold)
									ForEach(month.weeks) { (week: Week) in
											WeekView(week: week.days)
												.padding(EdgeInsets(top: 4, leading: 3, bottom: 4, trailing: 3))
									}
								}
							}
						}
						Spacer()
					}
					.padding(20)
				}.padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
			}
			.navigationBarTitle(Text("Diary"))
		}
	}
}
struct DiaryView_Previews: PreviewProvider {
    static var previews: some View {
			ContentView()
    }
}
