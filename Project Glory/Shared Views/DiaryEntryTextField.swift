//
//  DiaryEntryTextField.swift
//  Project Glory
//
//  Created by James Williams on 21/10/2019.
//  Copyright © 2019 James Williams. All rights reserved.
//

import SwiftUI

class DiaryEntryUITextView: UITextView, UITextViewDelegate {
	var textViewChangedHandler: ((String)->Void)?
	var onCommitHandler: (()->Void)?
	
	override func layoutSubviews() {
		super.layoutSubviews()
		textContainerInset = UIEdgeInsets.zero
		textContainer.lineFragmentPadding = 0
	}
	
	override init(frame: CGRect, textContainer: NSTextContainer?) {
		super.init(frame: frame, textContainer: textContainer)
		self.delegate = self
		self.font = .preferredFont(forTextStyle: .body)
		self.textColor = .secondaryLabel
	}
	
	required init?(coder: NSCoder) {
		fatalError("Not implemented")
	}
	
	@objc func onTap(sender: UITapGestureRecognizer) {
		if let handler = onCommitHandler {
			handler()
		}
	}
	
	func textViewDidChange(_ textView: UITextView) {
		if let currentValue = textView.text as NSString? {
			textViewChangedHandler?(currentValue as String)
		}
	}
	
	func textView(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		if let currentValue = textField.text as NSString? {
			let proposedValue = currentValue.replacingCharacters(in: range, with: string)
			textViewChangedHandler?(proposedValue as String)
		}
		return true
	}
	
	func textViewDidBeginEditing(_ textView: UITextView) {
			if textView.textColor == UIColor.secondaryLabel {
					textView.text = nil
					textView.textColor = UIColor.label
			}
	}
	
	private func textViewDidEndEditing(_ textField: UITextField) {
		onCommitHandler?()
	}
}

struct DiaryEntryTextField: UIViewRepresentable  {
	
	var placeholder: String
	var changeHandler:((String)->Void)?
	var onCommitHandler:(()->Void)?
	
	func makeUIView(context: Context) -> UITextView {
		let textView =  DiaryEntryUITextView()
		textView.onCommitHandler = onCommitHandler
		textView.text = placeholder
		textView.textViewChangedHandler = changeHandler
		return textView
	}
	
	func updateUIView(_ uiView: UITextView, context: Context) {
		
	}
	
}


struct DiaryTextFieldContainer: View {
	var placeholder = "Tap to start typing"
	@State var text: String = ""

	var body: some View {
		VStack {
			Text(text)
			DiaryEntryTextField(placeholder: placeholder, changeHandler: { text in self.text = text }, onCommitHandler:{ })
		}
	}
}


struct DiaryEntryTextField_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			DiaryTextFieldContainer()
			DiaryTextFieldContainer()
				.environment(\.colorScheme, .dark)
		}
	}
}
