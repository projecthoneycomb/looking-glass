//
//  AppDelegate.swift
//  projectglory
//
//  Created by James Williams on 25/09/2019.
//  Copyright © 2019 James Williams. All rights reserved.
//

import UIKit
import UserNotifications
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
	
	
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		let center = UNUserNotificationCenter.current()
		let defaults = UserDefaults.standard
		let options: UNAuthorizationOptions = [.alert, .sound];
		center.requestAuthorization(options: options) {
			(granted, error) in
			if let error = error {
				LogService.error(name: "NotificationPermissionError", error: error)
			}
			
			if let existingPermission = defaults.object(forKey: "notificationPermission") {
				if((existingPermission as! Bool) == granted) {
					return
				}
			}
			
			defaults.set(granted, forKey: "notificationPermission")
			self.reportNotificationPermission(granted: granted)
		}
		center.delegate = self
		return true
	}
	
	func reportNotificationPermission(granted: Bool) {
		if !granted {
			LogService.event(name: "Notification Permission Denied")
		} else {
			LogService.event(name: "Notification Permission Granted")
		}
	}
	
	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
		// Determine the user action
		switch response.actionIdentifier {
		case UNNotificationDismissActionIdentifier:
			print("Dismiss Action")
		case UNNotificationDefaultActionIdentifier:
			print("Default")
			DispatchQueue.main.async {
				let userInfo = ["notification": response]
				let note = Notification(name: .onNotificationStart, userInfo: userInfo)
				NotificationCenter.default.post(note)
				
				LogService.event(name: "notification_tap")
			}
		default:
			print("Unknown action")
		}
		completionHandler()
	}
	
	
	// MARK: UISceneSession Lifecycle
	
	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		// Called when a new scene session is being created.
		// Use this method to select a configuration to create the new scene with.
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}
	
	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
		// Called when the user discards a scene session.
		// If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
		// Use this method to release any resources that were specific to the discarded scenes, as they will not return.
	}
	
	// MARK: - Core Data stack
	
	lazy var persistentContainer: NSPersistentContainer = {
		/*
		The persistent container for the application. This implementation
		creates and returns a container, having loaded the store for the
		application to it. This property is optional since there are legitimate
		error conditions that could cause the creation of the store to fail.
		*/
		let container = NSPersistentCloudKitContainer(name: "projectglory")
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {
				// Replace this implementation with code to handle the error appropriately.
				// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
				
				/*
				Typical reasons for an error here include:
				* The parent directory does not exist, cannot be created, or disallows writing.
				* The persistent store is not accessible, due to permissions or data protection when the device is locked.
				* The device is out of space.
				* The store could not be migrated to the current model version.
				Check the error message to determine what the actual problem was.
				*/
				LogService.error(name: "CoreDataError", error: error)
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}()
	
	// MARK: - Core Data Saving support
	
	func saveContext () {
		let context = persistentContainer.viewContext
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				// Replace this implementation with code to handle the error appropriately.
				// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
				let nserror = error as NSError
				LogService.error(name: "CoreDataError", error: error)
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}
	
}

