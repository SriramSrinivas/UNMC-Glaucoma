//
//  Matrix.swift
//  glacInit
//
//  Created by Abdullahi Mahamed on 9/27/17.
//  Copyright © 2017 Parshav Chauhan. All rights reserved.
//

struct Matrix {
    let rows: Int, columns: Int
    var grid: [Int]
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        grid = Array(repeating: 0, count: rows * columns)
    }
    func indexIsValid(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    subscript(row: Int, column: Int) -> Int {
        get {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            return grid[(row * columns) + column]
        }
        set {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            grid[(row * columns) + column] = newValue
        }
    }
}

