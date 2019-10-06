//
//  DiaryEntry.swift
//  Project Glory
//
//  Created by James Williams on 27/09/2019.
//  Copyright © 2019 James Williams. All rights reserved.
//

import Foundation
import CoreData

public class DiaryEntry: NSManagedObject, Identifiable  {
	@NSManaged public var title: String?
	@NSManaged public var body: String?
	@NSManaged public var attribute: Int16
	@NSManaged public var monthOfYear: Int16
	@NSManaged public var dayOfWeek: Int16
	@NSManaged public var weekOfMonth: Int16
	@NSManaged public var year: Int16
	@NSManaged public var createdAt: Date
}

extension DiaryEntry {
	static func getAllDiaryEntries() -> NSFetchRequest<DiaryEntry> {
		let request: NSFetchRequest<DiaryEntry> = DiaryEntry.fetchRequest() as! NSFetchRequest<DiaryEntry>
		let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: true)
		request.sortDescriptors = [sortDescriptor]
		return request
	}
	
	static func getEntryFromToday() -> NSFetchRequest<DiaryEntry> {
		let calendar = Calendar.current
		let startOfToday = calendar.startOfDay(for: Date()) // eg. 2016-10-10 00:00:00
		let datePredicate = NSPredicate(format: "createdAt >= %@", startOfToday as NSDate)
		let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: true)
		
		let request: NSFetchRequest<DiaryEntry> = DiaryEntry.fetchRequest() as! NSFetchRequest<DiaryEntry>
		request.sortDescriptors = [sortDescriptor]
		request.fetchLimit = 1
		request.predicate = datePredicate
		return request
	}
	
	static func getLast7DaysOfEntries() -> NSFetchRequest<DiaryEntry> {
		let request: NSFetchRequest<DiaryEntry> = DiaryEntry.fetchRequest() as! NSFetchRequest<DiaryEntry>
		let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
		request.sortDescriptors = [sortDescriptor]
		request.fetchLimit = 7
		return request

	}
}
