"""
Sample tests
"""

from django.test import SimpleTestCase
from apps.calculator import calc


class ClacTests(SimpleTestCase):
    def test_add_numbers(self):
        """Test that two numbers are added together"""
        res = calc.add(3, 8)
        self.assertEqual(res, 11)

    def test_subtract_numbers(self):
        """Test that values are subtracted and returned"""
        res = calc.subtract(11, 5)
        self.assertEqual(res, 6)
