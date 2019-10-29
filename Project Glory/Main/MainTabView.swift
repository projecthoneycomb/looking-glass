//
//  DiaryView.swift
//  projectglory
//
//  Created by James Williams on 26/09/2019.
//  Copyright © 2019 James Williams. All rights reserved.
//

import SwiftUI

struct MainTabView: View {
	@ObservedObject var diaryService: DiaryService = DiaryService()
	
	@Environment(\.managedObjectContext) var managedObjectContext
	@EnvironmentObject var mainService: MainService
	
	@FetchRequest(fetchRequest: DiaryEntry.getAllDiaryEntries()) var diaryEntries: FetchedResults<DiaryEntry>
	@FetchRequest(fetchRequest: DiaryEntry.getEntryFromToday()) var entriesFromToday: FetchedResults<DiaryEntry>
	
	@State private var showModal: Bool = false
		
	var body: some View {
		let formattedEntries: [Month] = self.diaryService.formatDiaryData(entries: self.diaryEntries)
		let showModalWithNotification = Binding<Bool>(get: {
			return self.mainService.notificationStart ? true : self.$showModal.wrappedValue
		}, set: { newValue in
			self.showModal = newValue
		})
		
		return NavigationView {
			ScrollView {
				Group {
					Button(action: {
							LogService.event(name: "diary_start_entry_manual")
							showModalWithNotification.wrappedValue = true
					}) { DiaryTodayButton(hasEntry: self.entriesFromToday.count > 0 ? true : false) }
					.sheet(isPresented: showModalWithNotification) {
						if(self.entriesFromToday.count == 1) {
							DiaryAttributeInputView(managedObjectContext: self.managedObjectContext, mainService: self.mainService, inputStage: .notImplemented)
						} else {
							DiaryAttributeInputView(managedObjectContext: self.managedObjectContext, mainService: self.mainService, inputStage: .attributeInput)
						}
					}
					if(UpdateService.isUpdated(currentVersion: self.mainService.currentVersion)) {
						UpdateNotesView(version: self.mainService.currentVersion)
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
					.padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
				}
				.padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
				.navigationBarTitle(Text("Home 🏡"))
			}
		}
	}
}

struct DiaryView_Previews: PreviewProvider {
    static var previews: some View {
			ContentView()
    }
}
