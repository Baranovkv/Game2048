//
//  Game.swift
//  Game2048
//
//  Created by Kirill Baranov on 07/04/24.
//

import Foundation
import SwiftUI

enum Directions: CaseIterable {
	case toBottom, toLeft, toTop, toRight
}

enum GameModes: String, CaseIterable {
	case specialists = "Специалисты",
		 classic = "Классический"
}


//MARK: - Game viewModel
final class Game: ObservableObject {
	
	@Published var cells: GameCells = GameCells()
	@Published var score: Int = 0 {
		didSet {
			updateBestScore()
		}
	}
	
	@Published var bestScore: Int
	@Published var isGameOver = false
	@Published var gameMode: GameModes = .specialists
	
	var cellWithMaxResult: GameCell {
		cells.oneDimensional.max(by: { $0.value < $1.value }) ?? GameCell()
	}
	
	private var showResults = false
	private let savePath = URL.documentsDirectory.appending(path: "bestScore")
	
	init() {
		do {
			let data = try Data(contentsOf: savePath)
			bestScore = try JSONDecoder().decode(Int.self, from: data)
		} catch {
			print("Failed to load best score data")
			bestScore = 0
		}
	}
	
	//MARK: - intents:
	
	func startNewGame() {
		//		withAnimation {
		score = 0
		cells = GameCells()
		showResults = false
		//		}
	}
	
	func seeResults() {
		showResults = true
	}
	
	func identifyGesture(_ value: DragGesture.Value) {
		guard !showResults else { return }
		let horizontalAmount = value.translation.width
		let verticalAmount = value.translation.height
		
		if abs(horizontalAmount) > abs(verticalAmount) {
			if horizontalAmount < 0 {
				self.handleGesture(direction: .toLeft)
			} else {
				self.handleGesture(direction: .toRight)
			}
		} else {
			if verticalAmount < 0 {
				self.handleGesture(direction: .toTop)
			} else {
				self.handleGesture(direction: .toBottom)
			}
		}
		
	}
	
	//MARK: - private functions
	private func handleGesture(direction: Directions) {
		
		let originalCells = getCurrentCellsValues()
		
		withAnimation(.linear(duration: 0.1)) {
			
			switch direction {
			case .toBottom:
				moveToBottom()
			case .toLeft:
				moveToLeft()
			case .toTop:
				moveToTop()
			case .toRight:
				moveToRight()
			}
		}
		
		if originalCells != getCurrentCellsValues() {
			withAnimation(.linear.delay(0.1)) {
				cells.fillEmptyCell()
			}
		}
		
		if !checkForAvailableMoves() {
			isGameOver = true
		}
		
	}
	
	private func checkForAvailableMoves() -> Bool {
		let emptyCells = cells.oneDimensional.filter( {$0.value == 0} )
		guard emptyCells.isEmpty else {
			return true
		}
		for row in 0..<cells.side-1 {
			for col in 0..<cells.side-1 {
				if cells[row, col].value == cells[row, col + 1].value
					|| cells[row, col].value == cells[row + 1, col].value {
					return true
				}
			}
			if cells[row, cells.side-1].value == cells[row + 1, cells.side-1].value {
				return true
			}
		}
		for colInLastRow in 0..<cells.side-1 {
			if cells[cells.side-1, colInLastRow].value == cells[cells.side-1, colInLastRow + 1].value {
				return true
			}
		}
		return false
	}
	
	private func getCurrentCellsValues() -> [Int] {
		cells.oneDimensional.map { cell in
			cell.value
		}
	}
	
	private func moveToBottom() {
		
		for col in 0..<cells.side {
			var currentCol = [GameCell]()
			
			for row in 0..<cells.side {
				currentCol.append(cells[row,col])
			}
			currentCol.reverse()
			updateLine(&currentCol)
			currentCol.reverse()
			for row in 0..<cells.side {
				cells[row, col] = currentCol[row]
			}
		}
	}
	
	private func moveToLeft() {
		for row in 0..<cells.side {
			var currentRow = [GameCell]()
			for col in 0..<cells.side {
				currentRow.append(cells[row, col])
			}
			updateLine(&currentRow)
			for col in 0..<cells.side {
				cells[row, col] = currentRow[col]
			}
		}
	}
	
	private func moveToTop() {
		for col in 0..<cells.side {
			var currentCol = [GameCell]()
			for row in 0..<cells.side {
				currentCol.append(cells[row,col])
			}
			updateLine(&currentCol)
			for row in 0..<cells.side {
				cells[row,col] = currentCol[row]
			}
		}
	}
	
	private func moveToRight() {
		for row in 0..<cells.side {
			var currentRow = [GameCell]()
			for col in 0..<cells.side {
				currentRow.append(cells[row, col])
			}
			currentRow.reverse()
			updateLine(&currentRow)
			currentRow.reverse()
			for col in 0..<cells.side {
				cells[row, col] = currentRow[col]
			}
		}
	}
	
	private func updateLine(_ cells: inout [GameCell]) {
		var currentIndex = 0
		for _ in 1...3 {
			if cells[currentIndex].value != 0 {
				if cells[currentIndex + 1].value != 0 {
					if cells[currentIndex].value == cells[currentIndex + 1].value {
						cells.moveItems(from: currentIndex)
						cells[currentIndex].value *= 2
						score += cells[currentIndex].value
					}
					currentIndex += 1
				} else {
					cells.moveItems(from: currentIndex + 1)
				}
			} else {
				cells.moveItems(from: currentIndex)
			}
		}
	}
	
	private func updateBestScore() {
		if score > bestScore && gameMode == .classic {
			bestScore = score
			do {
				let data = try JSONEncoder().encode(score)
				try data.write(to: savePath, options: [.atomic, .completeFileProtection])
			} catch {
				print("Unable to save data")
			}
		}
	}
}
