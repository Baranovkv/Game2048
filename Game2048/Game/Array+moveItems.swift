//
//  Array_Extensoins.swift
//  Game2048
//
//  Created by Kirill Baranov on 08/04/24.
//

import Foundation
import SwiftUI

extension Array<GameCell> {
	mutating func moveItems(from index: Int) {
		
		for i in index..<self.count-1 {
			for j in i+1..<self.count {
				if self[j].value != 0 {
					self[i] = self[j]
					self[j] = GameCell()
					break
				}
			}
		}
	}
}
