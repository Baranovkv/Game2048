//
//  CellView.swift
//  Game2048
//
//  Created by Kirill Baranov on 07/04/24.
//

import SwiftUI

struct ClassicCellView: View {
	let cell: GameCell
	
	var body: some View {
		VStack {
			Text(cell.value.description)
				.bold()
				.foregroundStyle(.black)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background { background }
		.transition(.scale)
	}
	
	private var background: some View {
		RoundedRectangle(cornerRadius: 4)
			.foregroundStyle(backgroundColor)
	}
	
	private var backgroundColor: Color {
		switch cell.value {
		case 2, 4: return .white
		case 8: return Color(red: 1.0, green: 0.98, blue: 0.8)
		case 16: return .yellow
		case 32: return Color(red: 1.0, green: 0.65, blue: 0.0)
		case 64: return .orange
		case 128: return Color(red: 1.0, green: 0.41, blue: 0.71)
		case 256: return .red
		case 512: return Color(red: 0.8, green: 0.0, blue: 0.8)
		case 1024: return .purple
		default: return .teal
		}
		
	}
}

#Preview {
	ClassicCellView(cell: GameCell(value: 1024))
}
