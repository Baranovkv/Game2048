//
//  SpecialistCell.swift
//  Game2048
//
//  Created by Kirill Baranov on 10/04/24.
//

import SwiftUI

struct SpecialistCellView: View {
	let cell: GameCell
	var body: some View {
		Image(cell.value.description)
			.resizable()
			.scaledToFit()
			.overlay {
				label
			}
			.clipShape(RoundedRectangle(cornerRadius: 4))
			.shadow(radius: 2)
			.transition(.scale)
	}
	
	private var label: some View {
		VStack{
			Spacer()
			Text(cell.getSpecialistLabel())
				.scaledToFit()
				.padding(1)
				.padding(.top, 6)
				.frame(maxWidth: .infinity)
				.background(
					LinearGradient(
						gradient: Gradient(colors: [Color.white.opacity(1), Color.clear]),
						startPoint: .bottom,
						endPoint: .top
					)
				)
		}
	}
}

#Preview {
	SpecialistCellView(cell: GameCell(value: 64))
}
