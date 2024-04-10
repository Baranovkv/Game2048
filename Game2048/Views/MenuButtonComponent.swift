//
//  MenuButtonComponent.swift
//  Game2048
//
//  Created by Kirill Baranov on 09/04/24.
//

import SwiftUI

struct MenuButtonComponent: View {
	let title: LocalizedStringKey
	var action: (() -> Void)
    var body: some View {
		Button(action: {
			action()
		}, label: {
			Text(title)
				.padding(8)
				.overlay {
					RoundedRectangle(cornerRadius: 8)
						.stroke()
				}
				.background {
					RoundedRectangle(cornerRadius: 8)
						.foregroundStyle(.white)
				}
		})
    }
}


