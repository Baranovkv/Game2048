//
//  ContentView.swift
//  Game2048
//
//  Created by Kirill Baranov on 07/04/24.
//

import SwiftUI

struct GameView: View {
	
	@StateObject var game = Game()
	
	var body: some View {
		NavigationStack {
			VStack {
				title
				score
				Spacer()
				table
				newGameButton
			}
			.padding()
			.modifier(GestureAlertOnChangeModifiers(game: game))
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					gameModePicker
				}
			}
		}
		.preferredColorScheme(.light)
	}
	
	private var title: some View {
		VStack {
			Text("2048")
				.font(.title)
			if game.gameMode == .specialists {
				Text("IT Специалисты")
			}
			
		}
		.padding()
	}
	
	@ViewBuilder
	private var score: some View {
			switch game.gameMode {
			case .classic:
				Text("Текущий счет: \(game.score.description)")
				Text("Лучший результат: \(game.bestScore.description)")
			case .specialists:
				HStack {
					Text("Наиболее опытный специалист в команде:")
					Spacer()
					SpecialistCellView(cell: game.cellWithMaxResult)
					
				}
				.padding(.horizontal)
			}
	}
	
	private var newGameButton: some View {
		
		MenuButtonComponent(title: "Новая игра", action: game.startNewGame)
			.padding(.top, 80)
		
	}
	
	private var table: some View {
		LazyVGrid(columns: Constants.gridColumns, spacing: Constants.gridSpace) {
			ForEach (game.cells.oneDimensional) { cell in
				ZStack {
					Color.clear
						.aspectRatio(1, contentMode: .fill)
					if cell.value != 0 {
						
						switch game.gameMode {
						case .classic:
							ClassicCellView(cell: cell)
						case .specialists:
							SpecialistCellView(cell: cell)
						}
					}
				}
			}
		}
		.background(tableBackground)
		.padding()
	}
	
	@ViewBuilder
	private var tableBackground: some View {
		let base = RoundedRectangle(cornerRadius: Constants.cornerRadius)
		
		LazyVGrid(columns: Constants.gridColumns, spacing: Constants.gridSpace) {
			ForEach(0..<16) { _ in
				base
					.foregroundStyle(.gray)
					.frame(width: Constants.cellSize, height: Constants.cellSize)
			}
		}
		.padding(Constants.gridSpace)
		.background {
			base
				.foregroundStyle(.primary)
			
		}
	}
	
	private var gameModePicker: some View {
			Menu {
				Picker("Choose sort order", selection: $game.gameMode) {
					ForEach (GameModes.allCases, id: \.self) {
						Text($0.rawValue)
					}
				}
			} label: {
				Text("Режим игры")
				
			}
		
	}
	
	struct GestureAlertOnChangeModifiers: ViewModifier {
		@ObservedObject var game: Game
		
		func body(content: Content) -> some View {
			content
				.gesture(
					DragGesture(minimumDistance: 20, coordinateSpace: .global)
						.onEnded(game.identifyGesture)
				)
				.alert("Игра окончена!", isPresented: $game.isGameOver, actions: {
					Button("Посмотреть результат", role: .cancel) {
						game.seeResults()
					}
					Button("Начать новую игру") {
						game.startNewGame()
					}
				}, message: {
					Text("Ваш счет: \(game.score)")
				})
				.onChange(of: game.gameMode) { _ in
					
					game.startNewGame()
				}
		}
	}
	
	struct Constants {
		static let cellSize: CGFloat = 75
		static let gridSize: Int = 4
		static let gridSpace: CGFloat = 8
		static let gridColumns = Array(repeating: GridItem(.fixed(cellSize), spacing: gridSpace), count: gridSize)
		static let cornerRadius: CGFloat = 4
		
	}
	
}

#Preview {
	GameView()
}
