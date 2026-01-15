#!/usr/bin/env python3
"""Comprehensive tests for Table - matrix data structure operations."""

import unittest
import pytest

from askalot_qml.models.table import Table


@pytest.mark.unit
@pytest.mark.models
class TestTable(unittest.TestCase):
    """Test matrix data structure operations."""

    def test_basic_initialization(self):
        """Test basic table creation."""
        table = Table(3, 4)

        self.assertEqual(table.rows, 3)
        self.assertEqual(table.cols, 4)

        # Check all values initialized to default (None)
        for i in range(3):
            for j in range(4):
                self.assertIsNone(table[i, j])

    def test_custom_default_value(self):
        """Test table creation with custom default value."""
        table = Table(2, 3, default_value=-1)

        for i in range(2):
            for j in range(3):
                self.assertEqual(table[i, j], -1)

    def test_tuple_indexing_get(self):
        """Test getting values with tuple indexing."""
        table = Table(3, 3)
        table.data[1][2] = 42

        # Test tuple indexing
        self.assertEqual(table[1, 2], 42)
        self.assertIsNone(table[0, 0])  # Default value is None

    def test_tuple_indexing_set(self):
        """Test setting values with tuple indexing."""
        table = Table(3, 3)

        table[1, 2] = 99
        self.assertEqual(table.data[1][2], 99)

        table[0, 1] = 55
        self.assertEqual(table.data[0][1], 55)

    def test_row_access_single_index(self):
        """Test accessing entire row with single index."""
        table = Table(3, 3)
        table[0, 0] = 1
        table[0, 1] = 2
        table[0, 2] = 3

        # Single index returns entire row
        row = table[0]
        self.assertEqual(row, [1, 2, 3])

    def test_row_method(self):
        """Test row() method."""
        table = Table(3, 4)
        for j in range(4):
            table[1, j] = j * 10

        row = table.row(1)
        self.assertEqual(row, [0, 10, 20, 30])

    def test_column_method(self):
        """Test column() method."""
        table = Table(4, 3)
        for i in range(4):
            table[i, 1] = i * 5

        col = table.column(1)
        self.assertEqual(col, [0, 5, 10, 15])

    def test_bounds_checking_get(self):
        """Test index bounds checking for get operations."""
        table = Table(2, 3)

        # Valid access (default value is None)
        self.assertIsNone(table[0, 0])
        self.assertIsNone(table[1, 2])

        # Out of bounds
        with self.assertRaises(IndexError):
            _ = table[2, 0]  # Row out of range

        with self.assertRaises(IndexError):
            _ = table[0, 3]  # Column out of range

        with self.assertRaises(IndexError):
            _ = table[-1, 0]  # Negative index

    def test_bounds_checking_set(self):
        """Test index bounds checking for set operations."""
        table = Table(2, 2)

        # Valid set
        table[0, 0] = 1
        table[1, 1] = 2

        # Out of bounds
        with self.assertRaises(IndexError):
            table[2, 0] = 3

        with self.assertRaises(IndexError):
            table[0, 2] = 3

    def test_invalid_index_type(self):
        """Test error handling for invalid index types."""
        table = Table(2, 2)

        # Invalid get
        with self.assertRaises(TypeError):
            _ = table["invalid"]

        # Invalid set
        with self.assertRaises(TypeError):
            table["invalid"] = 1

        # Wrong tuple length for set
        with self.assertRaises(TypeError):
            table[1] = 42  # Can't set entire row this way

    def test_row_bounds_checking(self):
        """Test bounds checking for row() method."""
        table = Table(3, 3)

        # Valid
        row = table.row(1)
        self.assertIsNotNone(row)

        # Out of bounds
        with self.assertRaises(IndexError):
            table.row(3)

        with self.assertRaises(IndexError):
            table.row(-1)

    def test_column_bounds_checking(self):
        """Test bounds checking for column() method."""
        table = Table(3, 3)

        # Valid
        col = table.column(1)
        self.assertIsNotNone(col)

        # Out of bounds
        with self.assertRaises(IndexError):
            table.column(3)

        with self.assertRaises(IndexError):
            table.column(-1)

    def test_repr_method(self):
        """Test string representation of table."""
        table = Table(2, 3)
        table[0, 0] = 1
        table[0, 1] = 2
        table[0, 2] = 3
        table[1, 0] = 4
        table[1, 1] = 5
        table[1, 2] = 6

        repr_str = repr(table)
        self.assertIn('1', repr_str)
        self.assertIn('6', repr_str)
        # Should have two lines
        self.assertEqual(len(repr_str.split('\n')), 2)

    def test_equality_comparison(self):
        """Test equality comparison between tables."""
        table1 = Table(2, 2)
        table1[0, 0] = 1
        table1[1, 1] = 4

        table2 = Table(2, 2)
        table2[0, 0] = 1
        table2[1, 1] = 4

        table3 = Table(2, 2)
        table3[0, 0] = 1
        table3[1, 1] = 5  # Different value

        table4 = Table(2, 3)  # Different dimensions

        # Same values and dimensions
        self.assertEqual(table1, table2)

        # Different values
        self.assertNotEqual(table1, table3)

        # Different dimensions
        self.assertNotEqual(table1, table4)

        # Not a table
        self.assertNotEqual(table1, "not a table")
        self.assertNotEqual(table1, 42)

    def test_large_table(self):
        """Test operations on larger table."""
        table = Table(10, 10, default_value=0)

        # Set diagonal
        for i in range(10):
            table[i, i] = i

        # Check diagonal
        for i in range(10):
            self.assertEqual(table[i, i], i)

        # Check off-diagonal
        self.assertEqual(table[0, 1], 0)
        self.assertEqual(table[5, 8], 0)

    def test_row_and_column_modification(self):
        """Test that row() returns direct reference but column() returns a copy."""
        table = Table(3, 3)
        table[1, 0] = 10
        table[1, 1] = 20
        table[1, 2] = 30

        # Get row and modify it
        row = table.row(1)
        row[0] = 999

        # Table should be changed (row returns direct reference to internal list)
        self.assertEqual(table[1, 0], 999)
        self.assertEqual(table.row(1), [999, 20, 30])

        # Reset for column test
        table[0, 1] = 5
        table[1, 1] = 20
        table[2, 1] = 35

        # Get column and modify it
        col = table.column(1)
        original_col = col.copy()
        col[0] = 888

        # Table should be unchanged (column returns a new list)
        self.assertEqual(table[0, 1], 5)
        self.assertEqual(table.column(1), original_col)

    def test_single_row_table(self):
        """Test table with single row."""
        table = Table(1, 5)

        for j in range(5):
            table[0, j] = j * 2

        self.assertEqual(table.row(0), [0, 2, 4, 6, 8])

        # Test column access
        self.assertEqual(table.column(2), [4])

    def test_single_column_table(self):
        """Test table with single column."""
        table = Table(5, 1)

        for i in range(5):
            table[i, 0] = i * 3

        self.assertEqual(table.column(0), [0, 3, 6, 9, 12])

        # Test row access
        self.assertEqual(table.row(2), [6])


if __name__ == '__main__':
    unittest.main()