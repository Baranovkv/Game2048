//
//  Cell.swift
//  Game2048
//
//  Created by Kirill Baranov on 07/04/24.
//

import Foundation

struct GameCell: Identifiable, Equatable, CustomDebugStringConvertible {
	
	var id = UUID()
	
	var value = 0
	
	mutating func setRandomValue() {
			value = GameCell.randomValue.randomElement()!
	}
	
	var debugDescription: String {
		value.description
	}
	
	func getSpecialistLabel() -> String {
		switch value {
		case 2: return "Intern"
		case 4: return "Junior"
		case 8: return "Middle"
		case 16: return "Senior"
		case 32: return "TeamLead"
		case 64: return "TechLead"
		case 128: return "Architect"
		case 256: return "CTO"
		case 512: return "CEO"
		case 1024: return "Owner"
		case 2048: return "Jedi"
		default: return "Unknown"
		}
	}
	
	private static let randomValue = [2, 2, 2, 4]

	
}
