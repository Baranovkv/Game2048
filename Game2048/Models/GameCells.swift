//
//  Matrix.swift
//  Game2048
//
//  Created by Kirill Baranov on 08/04/24.
//

import Foundation

struct GameCells {
		
	let side: Int
	var oneDimensional: [GameCell]
	
	init(side: Int = 4) {
		self.side = side
		var oneDimensional = [GameCell]()
		
		for _ in 0..<side * side {
			oneDimensional.append(GameCell())
		}
		
		self.oneDimensional = oneDimensional
		
		for _ in 0..<2 {
			fillEmptyCell()
		}
	}
	
	mutating func fillEmptyCell() {
		guard let randomElementWithZeroValue = oneDimensional.filter({ $0.value == 0 }).randomElement() else { return }
		if let randomElementIndex = oneDimensional.firstIndex(where: { $0.id == randomElementWithZeroValue.id }) {
			oneDimensional[randomElementIndex].setRandomValue()
		}
	}
	
	subscript(row: Int, column: Int) -> GameCell {
		get {
			assert(indexIsValid(row: row, column: column), "Index out of range")
			return oneDimensional[(row * side) + column]
		}
		set {
			assert(indexIsValid(row: row, column: column), "Index out of range")
			oneDimensional[(row * side) + column] = newValue
		}
	}
	
	private func indexIsValid(row: Int, column: Int) -> Bool {
		return row >= 0 && row < side && column >= 0 && column < side
	}
	
}
