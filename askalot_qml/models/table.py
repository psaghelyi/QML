from typing import List, Any


class Table:
    """
    A simple 2D grid data structure for representing matrix question outcomes.
    Used exclusively within ItemProxy to represent MatrixQuestion outcomes.
    """
    def __init__(self, rows: int, cols: int, default_value: Any = None):
        # Use None as default to distinguish unanswered cells from cells with value 0
        self.data = [[default_value for _ in range(cols)] for _ in range(rows)]
        self.rows = rows
        self.cols = cols
        self.default_value = default_value

    def __getitem__(self, index):
        if isinstance(index, tuple) and len(index) == 2:
            row, col = index
            if 0 <= row < self.rows and 0 <= col < self.cols:
                return self.data[row][col]
            raise IndexError("Table index out of range.")
        elif isinstance(index, int):
            if 0 <= index < self.rows:
                return self.data[index]  # Return the entire row
            raise IndexError("Row index out of range.")
        else:
            raise TypeError("Invalid index type.")

    def __setitem__(self, index, value):
        if isinstance(index, tuple) and len(index) == 2:
            row, col = index
            if 0 <= row < self.rows and 0 <= col < self.cols:
                self.data[row][col] = value
            else:
                raise IndexError("Table index out of range.")
        else:
            raise TypeError("Index must be a tuple of two integers.")

    def row(self, index: int) -> List[int]:
        """Return a specific row as a list."""
        if 0 <= index < self.rows:
            return self.data[index]
        raise IndexError("Row index out of range.")

    def column(self, index: int) -> List[int]:
        """Return a specific column as a list."""
        if 0 <= index < self.cols:
            return [self.data[i][index] for i in range(self.rows)]
        raise IndexError("Column index out of range.")

    def __repr__(self):
        return "\n".join(" ".join(map(str, row)) for row in self.data)
        
    def __eq__(self, other):
        if not isinstance(other, Table):
            return False
        return (self.rows == other.rows and 
                self.cols == other.cols and 
                self.data == other.data)

"""
# Example usage
table = Table(5, 4)  # 5 rows, 4 columns

# Direct cell assignment
table[2][3] = 42
table[3, 3] = 43

print("Table:")
print(table)

print(table[2][3])
print(table[3, 3])

print("\nRow 2:", table.row(2))
print("Column 3:", table.column(3))


"""
