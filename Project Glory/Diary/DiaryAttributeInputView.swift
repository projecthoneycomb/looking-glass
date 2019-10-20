//
//  DiaryAttributeInputView.swift
//  Project Glory
//
//  Created by James Williams on 27/09/2019.
//  Copyright © 2019 James Williams. All rights reserved.
//

import SwiftUI
import CoreData

extension AnyTransition {
		static var slideAndFade: AnyTransition {
				let insertion = AnyTransition.move(edge: .trailing)
						.combined(with: .opacity)
				let removal = AnyTransition.move(edge: .leading)
						.combined(with: .opacity)
				return .asymmetric(insertion: insertion, removal: removal)
		}
}

enum InputStage {
	case attributeInput
	case textInput
	case notImplemented
}

struct DiaryAttributeInputView: View {
	
	@State var managedObjectContext: NSManagedObjectContext
	@State var mainService: MainService
	@Environment(\.presentationMode) var presentationMode
	
	@State private var currentlySelectedAttribute: Attribute?
	@State private var currentText: String = ""
	@State private var currentTitle: String = ""
	
	@State var inputStage: InputStage
	@State private var currentEntry: DiaryEntry?
	
	let calendar = Calendar.current

	var body: some View {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "d MMMM yyyy"
		let date = dateFormatter.string(from: Date())
		return HStack {
			VStack(alignment: .leading) {
				HStack {
					Spacer()
					Button(action: closeModal) {
						Image(systemName: "xmark")
							.resizable()
							.accentColor(Color("hc-main"))
							.scaledToFill()
					}
					.frame(width: 20, height: 20, alignment: .center)
				}
				Text(date)
					.font(.subheadline)
				
				Group {
					if (self.inputStage == .attributeInput) {
						AttributeSelection(currentlySelectedAttribute: self.$currentlySelectedAttribute)
					} else if (self.inputStage == .textInput) {
						DiaryTextInput(currentText: self.$currentText, currentTitle: self.$currentTitle, placeholderTitle: self.currentlySelectedAttribute?.toDescription())
					} else if (self.inputStage == .notImplemented) {
						VStack {
							Spacer()
							Image(systemName: "pencil")
								.resizable()
								.scaledToFit()
								.padding(.horizontal, 40)
							Text("Adding to entries will be coming soon!")
								.font(.title)
								.fontWeight(.semibold)
								.multilineTextAlignment(.center)
							Spacer()
						}
						.foregroundColor(Color("hc-main"))
						.padding(.horizontal, 60)
					}
				}
				.transition(.slideAndFade)
				.animation(.spring())
				
				Spacer()
				
				if (self.inputStage == .attributeInput) {
					HStack(alignment: .center, spacing: 10) {
						Button(action: moveOnToTextInput) {
								HStack(alignment: .lastTextBaseline, spacing: 2) {
									Spacer()
									Text("Next:")
										.fontWeight(.bold)
									Text("Thoughts")
									Spacer()
								}
								.foregroundColor(.white)
						}
						.padding(EdgeInsets(top: 10, leading: 25, bottom: 10, trailing: 25))
						.background(Color("hc-main"))
						.cornerRadius(.infinity)
						.opacity(currentlySelectedAttribute != nil ? 1 : 0.4)
						Button(action: { self.currentlySelectedAttribute == nil ? self.closeModal() : self.saveAndClose() }) {
							Text(currentlySelectedAttribute == nil ? "Close" : "Save")
								.fontWeight(.bold)
								.foregroundColor(.white)
						}
						.padding(EdgeInsets(top: 10, leading: 25, bottom: 10, trailing: 25))
						.background(Color.gray)
						.cornerRadius(.infinity)
					}
					
				} else if (self.inputStage == .textInput) {
					Button(action: saveText) {
							HStack(alignment: .lastTextBaseline, spacing: 2) {
								Spacer()
								Text("Save")
									.fontWeight(.bold)
								Spacer()
							}
							.foregroundColor(.white)
					}
					.padding(EdgeInsets(top: 10, leading: 25, bottom: 10, trailing: 25))
					.background(Color("hc-main"))
					.cornerRadius(.infinity)
				} else if (self.inputStage == .notImplemented) {
					Button(action: self.closeModal) {
						Spacer()
						Text("Close")
							.fontWeight(.bold)
							.foregroundColor(.white)
						Spacer()
					}
					.padding(EdgeInsets(top: 10, leading: 25, bottom: 10, trailing: 25))
					.background(Color.gray)
					.cornerRadius(.infinity)
				}
				

			}
		}
		.padding(30)
		.navigationBarTitle(Text(""), displayMode: .inline)
	}
	
	func closeModal() {
		self.mainService.clearState()
		self.presentationMode.wrappedValue.dismiss()
	}
	
	func saveText() {
		LogService.event(name: "diary_save_text")
		var currentTitle = self.currentlySelectedAttribute?.toDescription()
		if (!self.currentTitle.isEmpty) {
			currentTitle = self.currentTitle
		}
		self.currentEntry?.title = currentTitle
		self.currentEntry?.body = currentText
		
		do {
			try self.managedObjectContext.save()
			closeModal()
		} catch {
			print(error)
		}
	}
	
	func saveAndClose() {
		saveAttribute { _ in
			closeModal()
		}
	}
	
	func moveOnToTextInput() {
		saveAttribute { diaryEntry in
			self.currentEntry = diaryEntry
			self.inputStage = .textInput
			LogService.event(name: "diary_start_text")
		}
	}
	
	func saveAttribute(cb: (DiaryEntry?) -> Void) {
		LogService.event(name: "diary_save_attribute")
		
		guard let attribute = self.currentlySelectedAttribute else {
			return
		}
		
		let diaryEntry = DiaryEntry(context: self.managedObjectContext)
		diaryEntry.attribute = attribute.rawValue
		
		let currentDate = Date()
		let calendar = Calendar(identifier: .iso8601)
		diaryEntry.monthOfYear = Int16(calendar.component(.month, from: currentDate))
		diaryEntry.weekOfMonth = Int16(calendar.component(.weekOfMonth, from: currentDate))
		diaryEntry.dayOfWeek = Int16(calendar.component(.weekday, from: currentDate))
		diaryEntry.year = Int16(calendar.component(.year, from: currentDate))
		diaryEntry.createdAt = currentDate
		
		do {
			try self.managedObjectContext.save()
			cb(diaryEntry)
		} catch {
			print(error)
		}
	}
}

struct DiaryTextInput: View {
	@Binding var currentText: String
	@Binding var currentTitle: String
	@State var placeholderTitle: String?
	
	let calendar = Calendar.current
	
	var body: some View {
		let hour = calendar.component(.hour, from: Date())
		let minutes = calendar.component(.minute, from: Date())

		return Group {
			VStack(alignment: .leading, spacing: -10) {
				Text("What do you want to")
					.font(.title)
					.fontWeight(.bold)
				Text("remember about today?")
					.font(.title)
					.fontWeight(.bold)
			}
 			Text("Good, bad; happy, sad; emotional or a rant; what do you want to learn from today?")
				.font(.footnote)
			HStack(alignment: .center) {
				TextField(placeholderTitle ?? "", text: $currentTitle)
					.font(.title)
				Text("\(hour):\(minutes)")
					.font(.footnote)
			}
			TextField("Tap to start typing", text: $currentText)
		}
	}
}

struct AttributeSelection: View {
	@Binding var currentlySelectedAttribute: Attribute?
	var body: some View {
		Group {
			Text("How has today gone?")
				.font(.largeTitle)
				.fontWeight(.bold)
			Text("Don’t over think it; go with your gut.")
				.font(.footnote)
			VStack(alignment: .center, spacing: 10) {
				Spacer().frame(height: 10)
				HStack(alignment: .center, spacing: 10) {
					Button(action: { self.selectAttribute(attribute: .amazing) }) {
						BigButton(text: Attribute.amazing.toDescription(), attribute: .amazing)
					}
					.opacity(self.currentlySelectedAttribute == .amazing || self.currentlySelectedAttribute == nil ? 1 : 0.4)
					.animation(.easeInOut)
					Button(action: { self.selectAttribute(attribute: .reallyGood) }) {
						BigButton(text: Attribute.reallyGood.toDescription(), attribute: .reallyGood)
					}
					.opacity(self.currentlySelectedAttribute == .reallyGood || self.currentlySelectedAttribute == nil ? 1 : 0.4)
					.animation(.easeInOut)
				}
				.frame(height: 90)
				
				HStack(alignment: .center, spacing: 10) {
					Button(action: { self.selectAttribute(attribute: .normal) }) {
						BigButton(text: Attribute.normal.toDescription(), attribute: .normal)
					}
					.opacity(self.currentlySelectedAttribute == .normal || self.currentlySelectedAttribute == nil ? 1 : 0.4)
					.animation(.easeInOut)
					Button(action: { self.selectAttribute(attribute: .depressed) }) {
						BigButton(text: Attribute.depressed.toDescription(), attribute: .depressed)
					}
					.opacity(self.currentlySelectedAttribute == .depressed || self.currentlySelectedAttribute == nil ? 1 : 0.4)
					.animation(.easeInOut)
				}.frame(height: 90)
				
				HStack(alignment: .center, spacing: 10) {
					Button(action: { self.selectAttribute(attribute: .frustrating) }) {
						BigButton(text: Attribute.frustrating.toDescription(), attribute: .frustrating)
					}
					.opacity(self.currentlySelectedAttribute == .frustrating || self.currentlySelectedAttribute == nil ? 1 : 0.4)
					.animation(.easeInOut)
					Button(action: { self.selectAttribute(attribute: .stressed) }) {
						BigButton(text: Attribute.stressed.toDescription(), attribute: .stressed)
					}
					.opacity(self.currentlySelectedAttribute == .stressed || self.currentlySelectedAttribute == nil ? 1 : 0.4)
					.animation(.easeInOut)
				}.frame(height: 90)
			}
		}
	}
	
	func selectAttribute(attribute: Attribute) {
		self.currentlySelectedAttribute = attribute
	}
}
