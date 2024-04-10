### Здравствуйте! Представляю классическую версию игры 2048 с дополнительным модом - собрать команду айти специалистов! 

Реализована классическая механика: смещение жестом клеток в сторону, слияние клеток с одинаковым названием, заполнение пустых ячеек новыми со значениями 2 (повышенная вероятность) и 4. 
Мод со специалистами поддерживает варианты до значения 2048.

В основе данных лежит одномерный массив с сабскриптом, принимающим индексы строки и столбца. Логика игры написана применительно к двумерному массиву, однако для анимации SwiftUI использовалось его одномерное представление.


### Hello! This is the classic version of the game 2048 with an additional mod - gather a team of IT specialists!

Classic mechanics are implemented: moving cells to the side with a gesture, merging cells with the same name, filling empty cells with new ones with values 2 (increased probability) and 4.
The specialist mod supports options up to 2048.

The data is based on a one-dimensional array with a subscript that takes row and column indices. The game logic was written in relation to a two-dimensional array, but for the SwiftUI animation its one-dimensional representation was used.
