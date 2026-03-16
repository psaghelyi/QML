#!/usr/bin/env python3
"""Comprehensive tests for ItemProxy - outcome transformation and property access."""

import unittest
import pytest

from askalot_qml.models.item_proxy import ItemProxy
from askalot_qml.models.table import Table


@pytest.mark.unit
@pytest.mark.models
class TestItemProxy(unittest.TestCase):
    """Test item property access and outcome transformation."""

    def test_question_outcome_none(self):
        """Test Question with None outcome."""
        item = {
            'id': 'q1',
            'kind': 'Question',
            'outcome': None,
            'input': {'control': 'Editbox', 'min': 0, 'max': 100}
        }
        proxy = ItemProxy(item)

        self.assertEqual(proxy.id, 'q1')
        self.assertEqual(proxy.kind, 'Question')
        self.assertIsNone(proxy.outcome)
        self.assertEqual(proxy.min, 0)
        self.assertEqual(proxy.max, 100)

    def test_question_outcome_primitive(self):
        """Test Question with primitive value outcome."""
        item = {
            'id': 'q1',
            'kind': 'Question',
            'outcome': 42,
            'input': {'control': 'Editbox'}
        }
        proxy = ItemProxy(item)

        self.assertEqual(proxy.outcome, 42)

    def test_question_outcome_dictionary(self):
        """Test Question with dictionary format outcome."""
        item = {
            'id': 'q1',
            'kind': 'Question',
            'outcome': {'_': 75},
            'input': {'control': 'Editbox'}
        }
        proxy = ItemProxy(item)

        self.assertEqual(proxy.outcome, 75)

    def test_question_group_outcome(self):
        """Test QuestionGroup with array outcome."""
        item = {
            'id': 'qg1',
            'kind': 'QuestionGroup',
            'outcome': {
                '_0': 10,
                '_1': 20,
                '_2': 30
            },
            'input': {'control': 'Checkbox'}
        }
        proxy = ItemProxy(item)

        self.assertEqual(proxy.kind, 'QuestionGroup')
        self.assertIsInstance(proxy.outcome, list)
        self.assertEqual(proxy.outcome, [10, 20, 30])

    def test_question_group_empty_outcome(self):
        """Test QuestionGroup with empty outcome."""
        item = {
            'id': 'qg1',
            'kind': 'QuestionGroup',
            'outcome': None,
            'input': {'control': 'Checkbox'}
        }
        proxy = ItemProxy(item)

        self.assertIsNone(proxy.outcome)

    def test_matrix_question_outcome(self):
        """Test MatrixQuestion with Table outcome."""
        item = {
            'id': 'mq1',
            'kind': 'MatrixQuestion',
            'outcome': {
                '_0_0': 1, '_0_1': 2, '_0_2': 3,
                '_1_0': 4, '_1_1': 5, '_1_2': 6
            },
            'input': {'control': 'RadioMatrix'}
        }
        proxy = ItemProxy(item)

        self.assertEqual(proxy.kind, 'MatrixQuestion')
        self.assertIsInstance(proxy.outcome, Table)

        # Check table dimensions
        self.assertEqual(proxy.outcome.rows, 2)
        self.assertEqual(proxy.outcome.cols, 3)

        # Check values
        self.assertEqual(proxy.outcome[0, 0], 1)
        self.assertEqual(proxy.outcome[0, 1], 2)
        self.assertEqual(proxy.outcome[1, 1], 5)
        self.assertEqual(proxy.outcome[1, 2], 6)

    def test_property_extraction_min_max(self):
        """Test extraction of min/max properties."""
        item = {
            'id': 'q1',
            'kind': 'Question',
            'outcome': None,
            'input': {
                'control': 'Slider',
                'min': 0,
                'max': 100,
                'step': 5
            }
        }
        proxy = ItemProxy(item)

        self.assertEqual(proxy.min, 0)
        self.assertEqual(proxy.max, 100)
        self.assertEqual(proxy.step, 5)
        self.assertIn('min', proxy.input_props)
        self.assertIn('max', proxy.input_props)
        self.assertIn('step', proxy.input_props)

    def test_property_extraction_labels(self):
        """Test extraction of labels property."""
        item = {
            'id': 'q1',
            'kind': 'Question',
            'outcome': None,
            'input': {
                'control': 'RadioButton',
                'labels': {
                    '1': 'Strongly Disagree',
                    '2': 'Disagree',
                    '3': 'Neutral',
                    '4': 'Agree',
                    '5': 'Strongly Agree'
                }
            }
        }
        proxy = ItemProxy(item)

        self.assertIsNotNone(proxy.labels)
        self.assertEqual(len(proxy.labels), 5)
        self.assertEqual(proxy.labels['3'], 'Neutral')

    def test_property_extraction_boolean_props(self):
        """Test extraction of boolean properties (on/off)."""
        item = {
            'id': 'q1',
            'kind': 'Question',
            'outcome': None,
            'input': {
                'control': 'Toggle',
                'on': 'Yes',
                'off': 'No',
                'default': True
            }
        }
        proxy = ItemProxy(item)

        self.assertEqual(proxy.on, 'Yes')
        self.assertEqual(proxy.off, 'No')
        self.assertEqual(proxy.default, True)

    def test_control_type_storage(self):
        """Test control type is stored."""
        item = {
            'id': 'q1',
            'kind': 'Question',
            'outcome': None,
            'input': {'control': 'DatePicker'}
        }
        proxy = ItemProxy(item)

        self.assertEqual(proxy.control, 'DatePicker')
        self.assertEqual(proxy.input_props['control'], 'DatePicker')

    def test_repr_method(self):
        """Test __repr__ method."""
        item = {
            'id': 'test_q',
            'kind': 'Question',
            'outcome': 42,
            'input': {'control': 'Editbox'}
        }
        proxy = ItemProxy(item)

        repr_str = repr(proxy)
        self.assertIn('test_q', repr_str)
        self.assertIn('42', repr_str)

    def test_comment_kind_handling(self):
        """Test handling of Comment kind (no outcome)."""
        item = {
            'id': 'c1',
            'kind': 'Comment',
            'outcome': None,
            'input': {}
        }
        proxy = ItemProxy(item)

        self.assertEqual(proxy.kind, 'Comment')
        self.assertIsNone(proxy.outcome)

    def test_complex_matrix_question(self):
        """Test complex MatrixQuestion with irregular indices."""
        item = {
            'id': 'mq1',
            'kind': 'MatrixQuestion',
            'outcome': {
                '_2_1': 10,  # Not starting from 0
                '_0_0': 1,
                '_1_2': 5,
                '_2_0': 8
            },
            'input': {'control': 'RadioMatrix'}
        }
        proxy = ItemProxy(item)

        # Should handle up to max indices
        self.assertEqual(proxy.outcome.rows, 3)  # 0, 1, 2
        self.assertEqual(proxy.outcome.cols, 3)  # 0, 1, 2

        self.assertEqual(proxy.outcome[0, 0], 1)
        self.assertEqual(proxy.outcome[2, 1], 10)
        self.assertEqual(proxy.outcome[1, 2], 5)

    def test_question_group_non_sequential(self):
        """Test QuestionGroup with non-sequential indices."""
        item = {
            'id': 'qg1',
            'kind': 'QuestionGroup',
            'outcome': {
                '_0': 10,
                '_2': 30,  # Skipping _1
                '_4': 50   # Skipping _3
            },
            'input': {'control': 'Checkbox'}
        }
        proxy = ItemProxy(item)

        # Should create array up to max index
        self.assertEqual(len(proxy.outcome), 5)
        self.assertEqual(proxy.outcome[0], 10)
        self.assertIsNone(proxy.outcome[1])  # Gap
        self.assertEqual(proxy.outcome[2], 30)
        self.assertIsNone(proxy.outcome[3])  # Gap
        self.assertEqual(proxy.outcome[4], 50)

    def test_to_outcome_conversion(self):
        """Test to_outcome method for reverse conversion."""
        item = {
            'id': 'q1',
            'kind': 'Question',
            'outcome': None,
            'input': {'control': 'Editbox'}
        }
        proxy = ItemProxy(item)

        # Set a new outcome
        proxy.outcome = 99
        result = proxy.to_outcome()

        self.assertEqual(result, {'_': 99})

    def test_to_outcome_question_group(self):
        """Test to_outcome for QuestionGroup."""
        item = {
            'id': 'qg1',
            'kind': 'QuestionGroup',
            'outcome': None,
            'input': {'control': 'Checkbox'}
        }
        proxy = ItemProxy(item)

        # Set array outcome
        proxy.outcome = [1, 2, 3]
        result = proxy.to_outcome()

        self.assertEqual(result, {'_0': 1, '_1': 2, '_2': 3})

    def test_to_outcome_matrix_question(self):
        """Test to_outcome for MatrixQuestion."""
        item = {
            'id': 'mq1',
            'kind': 'MatrixQuestion',
            'outcome': None,
            'input': {'control': 'RadioMatrix'}
        }
        proxy = ItemProxy(item)

        # Create a table
        table = Table(2, 2)
        table[0, 0] = 1
        table[0, 1] = 2
        table[1, 0] = 3
        table[1, 1] = 4

        proxy.outcome = table
        result = proxy.to_outcome()

        self.assertEqual(result, {
            '_0_0': 1, '_0_1': 2,
            '_1_0': 3, '_1_1': 4
        })


@pytest.mark.unit
@pytest.mark.models
class TestItemProxyStringCoercion(unittest.TestCase):
    """Test numeric coercion of string outcomes from MCP/JSON serialization."""

    def test_question_string_int_outcome_coerced(self):
        """String integer outcomes should be coerced to int."""
        item = {'id': 'q1', 'kind': 'Question', 'outcome': '7', 'input': {'control': 'Radio'}}
        proxy = ItemProxy(item)
        self.assertEqual(proxy.outcome, 7)
        self.assertIsInstance(proxy.outcome, int)

    def test_question_string_int_dict_outcome_coerced(self):
        """String integer in dict format should be coerced to int."""
        item = {'id': 'q1', 'kind': 'Question', 'outcome': {'_': '42'}, 'input': {'control': 'Editbox'}}
        proxy = ItemProxy(item)
        self.assertEqual(proxy.outcome, 42)
        self.assertIsInstance(proxy.outcome, int)

    def test_question_string_float_outcome_coerced(self):
        """String float outcomes should be coerced to float."""
        item = {'id': 'q1', 'kind': 'Question', 'outcome': '3.14', 'input': {'control': 'Slider'}}
        proxy = ItemProxy(item)
        self.assertAlmostEqual(proxy.outcome, 3.14)
        self.assertIsInstance(proxy.outcome, float)

    def test_question_textarea_outcome_preserved(self):
        """Non-numeric string outcomes in Textarea should stay as strings."""
        item = {'id': 'q1', 'kind': 'Question', 'outcome': 'hello world', 'input': {'control': 'Textarea'}}
        proxy = ItemProxy(item)
        self.assertEqual(proxy.outcome, 'hello world')
        self.assertIsInstance(proxy.outcome, str)

    def test_question_textarea_numeric_string_not_coerced(self):
        """Numeric strings in Textarea controls should NOT be coerced to int."""
        item = {'id': 'q1', 'kind': 'Question', 'outcome': '42', 'input': {'control': 'Textarea'}}
        proxy = ItemProxy(item)
        self.assertEqual(proxy.outcome, '42')
        self.assertIsInstance(proxy.outcome, str)

    def test_question_int_outcome_unchanged(self):
        """Integer outcomes should pass through unchanged."""
        item = {'id': 'q1', 'kind': 'Question', 'outcome': 7, 'input': {'control': 'Radio'}}
        proxy = ItemProxy(item)
        self.assertEqual(proxy.outcome, 7)
        self.assertIsInstance(proxy.outcome, int)

    def test_question_bool_outcome_unchanged(self):
        """Boolean outcomes should not be coerced to int."""
        item = {'id': 'q1', 'kind': 'Question', 'outcome': True, 'input': {'control': 'Switch'}}
        proxy = ItemProxy(item)
        self.assertIs(proxy.outcome, True)

    def test_precondition_comparison_with_coerced_outcome(self):
        """Coerced outcomes should work in precondition comparisons."""
        item = {'id': 'q_age', 'kind': 'Question', 'outcome': {'_': '25'}, 'input': {'control': 'Editbox'}}
        proxy = ItemProxy(item)
        self.assertTrue(proxy.outcome >= 18)
        self.assertFalse(proxy.outcome >= 30)

    def test_equality_comparison_with_coerced_outcome(self):
        """Coerced outcomes should work with == comparisons (the silent bug)."""
        item = {'id': 'q_emp', 'kind': 'Question', 'outcome': {'_': '1'}, 'input': {'control': 'Radio'}}
        proxy = ItemProxy(item)
        self.assertTrue(proxy.outcome == 1)
        self.assertFalse(proxy.outcome == 2)

    def test_question_group_string_values_coerced(self):
        """QuestionGroup string values should be coerced to numeric."""
        item = {
            'id': 'qg1', 'kind': 'QuestionGroup',
            'outcome': {'_0': '10', '_1': '20', '_2': '30'},
            'input': {'control': 'Checkbox'}
        }
        proxy = ItemProxy(item)
        self.assertEqual(proxy.outcome, [10, 20, 30])

    def test_matrix_question_string_values_coerced(self):
        """MatrixQuestion string values should be coerced to numeric."""
        item = {
            'id': 'mq1', 'kind': 'MatrixQuestion',
            'outcome': {'_0_0': '1', '_0_1': '2', '_1_0': '3', '_1_1': '4'},
            'input': {'control': 'RadioMatrix'}
        }
        proxy = ItemProxy(item)
        self.assertEqual(proxy.outcome[0, 0], 1)
        self.assertEqual(proxy.outcome[1, 1], 4)


if __name__ == '__main__':
    unittest.main()