class MathHelpSection {
  //#region Addition Help
   List<Map<String, dynamic>> getAdditionHelp(int grade) {
    return [
      {
        'Grade': 1,
        'title': 'Adding 1-Digit Numbers with Carry',
        'description':
            'Add 1-digit numbers by summing them directly. If the sum is 10 or more, write the ones digit and carry the tens digit.',
        'exampleSteps': [
          'Add directly: 7 + 8 = 15.',
          'Write 5 in the ones place, carry 1 to the tens place.',
          'Result: 15 (1 ten and 5 ones).',
        ],
        'exampleText': '''   7\n + 8\n ---\n  15\n\nAnswer: 7 + 8 = 15''',
      },
      {
        'Grade': 1,
        'title': 'Adding Whole Tens',
        'description':
            'Add numbers that are multiples of 10 by summing their tens digits directly.',
        'exampleSteps': ['Add directly: 40 + 30 = 70.', 'Result: 70 (7 tens).'],
        'exampleText': '   40\n + 30\n ----\n   70\n\nAnswer: 40 + 30 = 70',
      },
      {
        'Grade': 2,
        'title': 'Adding 2-Digit Numbers with carry',
        'description':
            'Align by tens and ones. Add the ones place first, carrying over if the sum is 10 or more. Then add the tens place.',
        'exampleSteps': [
          'Write vertically: 45 + 27.',
          'Ones: 5 + 7 = 12. Write 2, carry 1.',
          'Tens: 4 + 2 + 1 = 7. Write 7.',
          'Result: 72.',
        ],
        'exampleText': '''   45\n + 27\n ----\n   72\n\nAnswer: 45 + 27 = 72''',
      },
      {
        'Grade': 3,
        'title': 'Adding 3-Digit Numbers',
        'description':
            'Align by hundreds, tens, and ones. Add from right to left, carrying over when necessary.',
        'exampleSteps': [
          'Write vertically: 356 + 472.',
          'Ones: 6 + 2 = 8. Write 8.',
          'Tens: 5 + 7 = 12. Write 2, carry 1.',
          'Hundreds: 3 + 4 + 1 = 8. Write 8.',
          'Result: 828.',
        ],
        'exampleText':
            '''   356\n + 472\n -----\n   828\n\nAnswer: 356 + 472 = 828''',
      },
      {
        'Grade': 3,
        'title': 'Adding Three 3-Digit Numbers',
        'description':
            'Align three 3-digit numbers by hundreds, tens, and ones. Add column by column, carrying over as needed.',
        'exampleSteps': [
          'Write vertically: 234 + 567 + 189.',
          'Ones: 4 + 7 + 9 = 20. Write 0, carry 2.',
          'Tens: 3 + 6 + 8 + 2 = 19. Write 9, carry 1.',
          'Hundreds: 2 + 5 + 1 + 1 = 9. Write 9.',
          'Result: 990.',
        ],
        'exampleText':
            '''   234\n + 567\n + 189\n -----\n   990\n\nAnswer: 234 + 567 + 189 = 990''',
      },
      {
        'Grade': 3,
        'title': 'Adding Four 3-Digit Numbers',
        'description':
            'Add four 3-digit numbers by aligning them by place values, summing each column, and carrying over when the sum exceeds 9.',
        'exampleSteps': [
          'Write vertically: 234 + 456 + 678 + 123.',
          'Ones: 4 + 6 + 8 + 3 = 21. Write 1, carry 2.',
          'Tens: 3 + 5 + 7 + 2 + 2 (carry) = 19. Write 9, carry 1.',
          'Hundreds: 2 + 4 + 6 + 1 + 1 (carry) = 14. Write 4, carry 1.',
          'Thousands: 1 (carry) = 1. Write 1.',
          'Result: 1491.',
        ],
        'exampleText':
            '   234\n + 456\n + 678\n + 123\n -----\n  1491\n\nAnswer: 234 + 456 + 678 + 123 = 1491',
      },
      {
        'Grade': 3,
        'title': 'Adding 4-Digit Numbers',
        'description':
            'Align by thousands, hundreds, tens, and ones. Add column by column, carrying over when needed.',
        'exampleSteps': [
          'Write vertically: 2345 + 1789.',
          'Ones: 5 + 9 = 14. Write 4, carry 1.',
          'Tens: 4 + 8 + 1 = 13. Write 3, carry 1.',
          'Hundreds: 3 + 7 + 1 = 11. Write 1, carry 1.',
          'Thousands: 2 + 1 + 1 = 4. Write 4.',
          'Result: 4134.',
        ],
        'exampleText':
            '''   2345\n + 1789\n ------\n   4134\n\nAnswer: 2345 + 1789 = 4134''',
      },
      {
        'Grade': 4,
        'title': 'Adding Negative Numbers',
        'description':
            'Add negative numbers by considering their signs. If both numbers are negative, add their absolute values and keep the negative sign. If one is negative, subtract the smaller absolute value from the larger and use the sign of the larger.',
        'exampleSteps': [
          'Add: -7 + (-8).',
          'Both negative: Add absolute values 7 + 8 = 15.',
          'Apply negative sign: -15.',
          'Result: -15.',
        ],
        'exampleText':
            '    -7\n + (-8)\n ------\n   -15\n\nAnswer: -7 + (-8) = -15',
      },
      {
        'Grade': 4,
        'title': 'Adding Four 4-Digit Numbers',
        'description':
            'Add four 4-digit numbers by aligning them by place values, summing each column, and carrying over when the sum exceeds 9.',
        'exampleSteps': [
          'Write vertically: 1234 + 2345 + 3456 + 4567.',
          'Ones: 4 + 5 + 6 + 7 = 22. Write 2, carry 2.',
          'Tens: 3 + 4 + 5 + 6 + 2 (carry) = 20. Write 0, carry 2.',
          'Hundreds: 2 + 3 + 4 + 5 + 2 (carry) = 16. Write 6, carry 1.',
          'Thousands: 1 + 2 + 3 + 4 + 1 (carry) = 11. Write 1, carry 1.',
          'Ten-thousands: 1 (carry) = 1. Write 1.',
          'Result: 11602.',
        ],
        'exampleText':
            '   1234\n + 2345\n + 3456\n + 4567\n ------\n  11602\n\nAnswer: 1234 + 2345 + 3456 + 4567 = 11602',
      },
      {
        'Grade': 4,
        'title': 'Adding 5-Digit Numbers',
        'description':
            'Align by ten-thousands, thousands, hundreds, tens, and ones. Add from right to left.',
        'exampleSteps': [
          'Write vertically: 45678 + 23456.',
          'Ones: 8 + 6 = 14. Write 4, carry 1.',
          'Tens: 7 + 5 + 1 = 13. Write 3, carry 1.',
          'Hundreds: 6 + 4 + 1 = 11. Write 1, carry 1.',
          'Thousands: 5 + 3 + 1 = 9. Write 9.',
          'Ten-thousands: 4 + 2 = 6. Write 6.',
          'Result: 69134.',
        ],
        'exampleText':
            '''    45678\n +  23456\n  -------\n    69134\n\nAnswer: 45678 + 23456 = 69134''',
      },
      {
        'Grade': 5,
        'title': 'Adding 6-Digit Numbers',
        'description':
            'Align by hundred-thousands, ten-thousands, thousands, hundreds, tens, and ones. Add column by column.',
        'exampleSteps': [
          'Write vertically: 345678 + 234567.',
          'Ones: 8 + 7 = 15. Write 5, carry 1.',
          'Tens: 7 + 6 + 1 = 14. Write 4, carry 1.',
          'Hundreds: 6 + 5 + 1 = 12. Write 2, carry 1.',
          'Thousands: 5 + 4 + 1 = 10. Write 0, carry 1.',
          'Ten-thousands: 4 + 3 + 1 = 8. Write 8.',
          'Hundred-thousands: 3 + 2 = 5. Write 5.',
          'Result: 580245.',
        ],
        'exampleText':
            '''   345678\n + 234567\n --------\n   580245\n\nAnswer: 345678 + 234567 = 580245''',
      },
      {
        'Grade': 5,
        'title': 'Adding Three 6-Digit Numbers',
        'description':
            'Add three 6-digit numbers by aligning them by place values, summing each column, and carrying over when the sum exceeds 9.',
        'exampleSteps': [
          'Write vertically: 123456 + 234567 + 345678.',
          'Ones: 6 + 7 + 8 = 21. Write 1, carry 2.',
          'Tens: 5 + 6 + 7 + 2 (carry) = 20. Write 0, carry 2.',
          'Hundreds: 4 + 5 + 6 + 2 (carry) = 17. Write 7, carry 1.',
          'Thousands: 3 + 4 + 5 + 1 (carry) = 13. Write 3, carry 1.',
          'Ten-thousands: 2 + 3 + 4 + 1 (carry) = 10. Write 0, carry 1.',
          'Hundred-thousands: 1 + 2 + 3 + 1 (carry) = 7. Write 7.',
          'Result: 703701.',
        ],
        'exampleText':
            '   123456\n + 234567\n + 345678\n --------\n   703701\n\nAnswer: 123456 + 234567 + 345678 = 703701',
      },
      {
        'Grade': 5,
        'title': 'Adding Complex Numbers',
        'description':
            'Add complex numbers by adding their real and imaginary parts separately (a + bi format).',
        'exampleSteps': [
          'Write: (3 + 4i) + (5 - 2i).',
          'Add real parts: 3 + 5 = 8.',
          'Add imaginary parts: 4 + (-2) = 2.',
          'Combine: 8 + 2i.',
        ],
        'exampleText':
            '''    3 + 4i\n +  5 - 2i\n ---------\n    8 + 2i\n\nAnswer: (3 + 4i) + (5 - 2i) = 8 + 2i''',
      },
      {
        'Grade': 4,
        'title': 'Adding Fractions',
        'description':
            'Find a common denominator, add numerators, and simplify by dividing by the greatest common divisor (GCD).',
        'exampleSteps': [
          'Find LCD for 3/4 and 2/6. Multiples of 4: 4, 8, 12; multiples of 6: 6, 12. LCD = 12.',
          'Convert: 3/4 = (3 × 3)/(4 × 3) = 9/12; 2/6 = (2 × 2)/(6 × 2) = 4/12.',
          'Add numerators: 9 + 4 = 13. Result: 13/12.',
          'Simplify: 13 is prime, 12 = 2 × 2 × 3, no common factors. Convert to mixed number: 13 ÷ 12 = 1 remainder 1 → 1 1/12.',
        ],
        'exampleText':
            '''   9/12\n + 4/12\n  -----\n  13/12\n\nAnswer: 3/4 + 2/6 = 13/12''',
      },
      {
        'Grade': 5,
        'title': 'Adding Binary Numbers',
        'description':
            'Use rules: 0 + 0 = 0, 0 + 1 = 1, 1 + 1 = 10 (write 0, carry 1), 1 + 1 + 1 = 11 (write 1, carry 1). Add from right to left.',
        'exampleSteps': [
          'Write vertically: 1011 + 1101.',
          'Ones: 1 + 1 = 10. Write 0, carry 1.',
          'Twos: 1 + 0 + 1 = 10. Write 0, carry 1.',
          'Fours: 0 + 1 + 1 = 10. Write 0, carry 1.',
          'Eights: 1 + 1 + 1 = 11. Write 1, carry 1.',
          'Carry: Write 1 (10000).',
          'Result: 11000.',
        ],
        'exampleText':
            '''   1011\n + 1101\n ------\n  11000\n\nAnswer: 1011 + 1101 = 11000''',
      },
      {
        'Grade': 3,
        'title': 'Adding Decimal Numbers',
        'description':
            'Align numbers by decimal points, add as whole numbers (padding with zeros if needed), and place the decimal point in the result.',
        'exampleSteps': [
          'Write vertically: 12.34 + 5.678.',
          'Align decimal points, pad 12.34 with a zero: 12.340.',
          'Ones: 0 + 8 = 8. Write 8.',
          'Tenths: 4 + 7 = 11. Write 1, carry 1.',
          'Hundredths: 3 + 6 + 1 = 10. Write 0, carry 1.',
          'Thousandths: 2 + 5 + 1 = 8. Write 8.',
          'Units: 2 + 0 = 2. Write 2.',
          'Place decimal point: 18.018.',
        ],
        'exampleText':
            '''   12.340\n +  5.678\n --------\n   18.018\n\nAnswer: 12.34 + 5.678 = 18.018''',
      },
    ].where((op) => op["Grade"] == grade).toList();
  }
  //#endregion

   //#region Subtraction Help
   List<Map<String, dynamic>> getSubtractionHelp(int grade) {
    return [
      {
        'Grade': 1,
        'title': 'Subtracting 1-Digit Numbers',
        'description':
            'Subtract 1-digit numbers directly. Ensure the minuend is greater than or equal to the subtrahend.',
        'exampleSteps': ['Subtract directly: 9 - 4 = 5.', 'Result: 5.'],
        'exampleText': '''   9\n - 4\n ----\n   5\n\nAnswer: 9 - 4 = 5''',
      },
      {
        'Grade': 1,
        'title': 'Subtracting Whole Tens',
        'description':
            'Subtract numbers that are multiples of 10 by subtracting the tens digits.',
        'exampleSteps': [
          'Write vertically: 50 - 20.',
          'Subtract tens: 5 - 2 = 3 (tens).',
          'Result: 30.',
        ],
        'exampleText':
            '''    50\n -  20\n ------\n    30\n\nAnswer: 50 - 20 = 30''',
      },
      {
        'Grade': 2,
        'title': 'Subtracting Whole Hundreds',
        'description':
            'Subtract numbers that are multiples of 100 by subtracting the hundreds digits.',
        'exampleSteps': [
          'Write vertically: 400 - 200.',
          'Subtract hundreds: 4 - 2 = 2 (hundreds).',
          'Result: 200.',
        ],
        'exampleText':
            '''    400\n -  200\n -------\n    200\n\nAnswer: 400 - 200 = 200''',
      },
      {
        'Grade': 2,
        'title': '2-Digit Subtraction Without Borrowing',
        'description':
            'Subtract 2-digit numbers where no borrowing is required.',
        'exampleSteps': [
          'Write vertically: 67 - 34.',
          'Ones: 7 - 4 = 3.',
          'Tens: 6 - 3 = 3.',
          'Result: 33.',
        ],
        'exampleText':
            '''   67\n - 34\n -----\n   33\n\nAnswer: 67 - 34 = 33''',
      },
      {
        'Grade': 2,
        'title': '2-Digit Subtraction With Borrowing',
        'description':
            'Subtract 2-digit numbers, borrowing from the tens place when needed.',
        'exampleSteps': [
          'Write vertically: 45 - 28.',
          'Ones: 5 < 8, borrow 1 from tens (4 becomes 3, 5 becomes 15). 15 - 8 = 7.',
          'Tens: 3 - 2 = 1.',
          'Result: 17.',
        ],
        'exampleText':
            '''    45\n -  28\n  -----\n    17\n\nAnswer: 45 - 28 = 17''',
      },
      {
        'Grade': 3,
        'title': '3-Digit Subtraction Without Borrowing',
        'description':
            'Subtract multi-digit numbers where no borrowing is needed (each digit in the minuend is greater than or equal to the subtrahend’s corresponding digit).',
        'exampleSteps': [
          'Write vertically: 876 - 543.',
          'Ones: 6 - 3 = 3.',
          'Tens: 7 - 4 = 3.',
          'Hundreds: 8 - 5 = 3.',
          'Result: 333.',
        ],
        'exampleText':
            '''   876\n - 543\n ------\n   333\n\nAnswer: 876 - 543 = 333''',
      },
      {
        'Grade': 3,
        'title': '3-Digit Subtraction with borrowing',
        'description':
            'Subtract 3-digit numbers, aligning by place values and borrowing as needed.',
        'exampleSteps': [
          'Write vertically: 654 - 387.',
          'Ones: 4 < 7, borrow 1 from tens (5 becomes 4, 4 becomes 14). 14 - 7 = 7.',
          'Tens: 4 < 8, borrow 1 from hundreds (6 becomes 5, 4 becomes 14). 14 - 8 = 6.',
          'Hundreds: 5 - 3 = 2.',
          'Result: 267.',
        ],
        'exampleText':
            '''   654\n - 387\n ------\n   267\n\nAnswer: 654 - 387 = 267''',
      },
      {
        'Grade': 4,
        'title': '4-Digit Subtraction with borrowing',
        'description':
            'Subtract 4-digit numbers, borrowing across multiple place values if necessary.',
        'exampleSteps': [
          'Write vertically: 5432 - 2789.',
          'Ones: 2 < 9, borrow 1 from tens (3 becomes 2, 2 becomes 12). 12 - 9 = 3.',
          'Tens: 2 < 8, borrow 1 from hundreds (4 becomes 3, 2 becomes 12). 12 - 8 = 4.',
          'Hundreds: 3 < 7, borrow 1 from thousands (5 becomes 4, 3 becomes 13). 13 - 7 = 6.',
          'Thousands: 4 - 2 = 2.',
          'Result: 2643.',
        ],
        'exampleText':
            '''   5432\n - 2789\n -------\n   2643\n\nAnswer: 5432 - 2789 = 2643''',
      },
      {
        'Grade': 4,
        'title': '5-Digit Subtraction With Borrowing',
        'description':
            'Subtract 5-digit numbers, borrowing across multiple place values when the minuend’s digit is smaller than the subtrahend’s.',
        'exampleSteps': [
          'Write vertically: 50234 - 37895.',
          'Ones: 4 < 5, borrow 1 from tens (3 becomes 2, 4 becomes 14). 14 - 5 = 9.',
          'Tens: 2 < 9, borrow 1 from hundreds (2 becomes 1, 2 becomes 12). 12 - 9 = 3.',
          'Hundreds: 1 < 8, borrow 1 from thousands (0 becomes 9, 1 becomes 11 after borrowing from ten-thousands where 5 becomes 4). 11 - 8 = 3.',
          'Thousands: 9 - 7 = 2.',
          'Ten-thousands: 4 - 3 = 1.',
          'Result: 12339.',
        ],
        'exampleText':
            '''   50234\n - 37895\n --------\n   12339\n\nAnswer: 50234 - 37895 = 12339''',
      },
      {
        'Grade': 5,
        'title': '6-Digit Subtraction with borrowing',
        'description':
            'Subtract 6-digit numbers, borrowing as needed across place values.',
        'exampleSteps': [
          'Write vertically: 654321 - 387654.',
          'Ones: 1 < 4, borrow 1 from tens (2 becomes 1, 1 becomes 11). 11 - 4 = 7.',
          'Tens: 1 < 5, borrow 1 from hundreds (3 becomes 2, 1 becomes 11). 11 - 5 = 6.',
          'Hundreds: 2 < 6, borrow 1 from thousands (4 becomes 3, 2 becomes 12). 12 - 6 = 6.',
          'Thousands: 3 < 7, borrow 1 from ten-thousands (5 becomes 4, 3 becomes 13). 13 - 7 = 6.',
          'Ten-thousands: 4 < 8, borrow 1 from hundred-thousands (6 becomes 5, 4 becomes 14). 14 - 8 = 6.',
          'Hundred-thousands: 5 - 3 = 2.',
          'Result: 266667.',
        ],
        'exampleText':
            '''   654321\n - 387654\n ---------\n   266667\n\nAnswer: 654321 - 387654 = 266667''',
      },
      {
        'Grade': 5,
        'title': 'Subtract Three 4-Digit Numbers',
        'description':
            'Subtract three 4-digit numbers sequentially, borrowing as needed.',
        'exampleSteps': [
          'Write vertically: 7500 - 2000 - 1500.',
          'First subtraction (7500 - 2000):',
          '  Ones: 0 - 0 = 0.',
          '  Tens: 0 - 0 = 0.',
          '  Hundreds: 5 - 0 = 5.',
          '  Thousands: 7 - 2 = 5.',
          '  Result: 5500.',
          'Second subtraction (5500 - 1500):',
          '  Ones: 0 - 0 = 0.',
          '  Tens: 0 - 0 = 0.',
          '  Hundreds: 5 - 5 = 0.',
          '  Thousands: 5 - 1 = 4.',
          '  Result: 4000.',
        ],
        'exampleText':
            '''   7500\n - 2000\n -------\n   5500\n - 1500\n -------\n   4000\n\nAnswer: 7500 - 2000 - 1500 = 4000''',
      },
      {
        'Grade': 5,
        'title': 'Subtract Four 4-Digit Numbers',
        'description':
            'Subtract four 4-digit numbers sequentially, handling borrowing where necessary.',
        'exampleSteps': [
          'Write vertically: 9000 - 1500 - 1200 - 1100.',
          'First subtraction (9000 - 1500):',
          '  Ones: 0 - 0 = 0.',
          '  Tens: 0 - 0 = 0.',
          '  Hundreds: 0 - 5, borrow 1 from thousands (9 becomes 8, 0 becomes 10). 10 - 5 = 5.',
          '  Thousands: 8 - 1 = 7.',
          '  Result: 7500.',
          'Second subtraction (7500 - 1200):',
          '  Ones: 0 - 0 = 0.',
          '  Tens: 0 - 0 = 0.',
          '  Hundreds: 5 - 2 = 3.',
          '  Thousands: 7 - 1 = 6.',
          '  Result: 6300.',
          'Third subtraction (6300 - 1100):',
          '  Ones: 0 - 0 = 0.',
          '  Tens: 0 - 0 = 0.',
          '  Hundreds: 3 - 1 = 2.',
          '  Thousands: 6 - 1 = 5.',
          '  Result: 5200.',
        ],
        'exampleText':
            '''   9000\n - 1500\n -------\n   7500\n - 1200\n -------\n   6300\n - 1100\n -------\n   5200\n\nAnswer: 9000 - 1500 - 1200 - 1100 = 5200''',
      },
      {
        'Grade': 5,
        'title': 'Subtract a 6-Digit Number with Two Smaller Numbers',
        'description':
            'Subtract a 6-digit number by two smaller numbers sequentially, borrowing as needed.',
        'exampleSteps': [
          'Write vertically: 800000 - 50000 - 4000.',
          'First subtraction (800000 - 50000):',
          '  Ones to thousands: 0 - 0 = 0.',
          '  Ten-thousands: 0 - 5, borrow 1 from hundred-thousands (8 becomes 7, 0 becomes 10). 10 - 5 = 5.',
          '  Hundred-thousands: 7 - 0 = 7.',
          '  Result: 750000.',
          'Second subtraction (750000 - 4000):',
          '  Ones to hundreds: 0 - 0 = 0.',
          '  Thousands: 0 - 4, borrow 1 from ten-thousands (5 becomes 4, 0 becomes 10). 10 - 4 = 6.',
          '  Ten-thousands: 4 - 0 = 4.',
          '  Hundred-thousands: 7 - 0 = 7.',
          '  Result: 746000.',
        ],
        'exampleText':
            '''   800000\n -  50000\n ---------\n   750000\n -   4000\n ---------\n   746000\n\nAnswer: 800000 - 50000 - 4000 = 746000''',
      },
      {
        'Grade': 5,
        'title': 'Subtracting Decimal Numbers',
        'description':
            'Align numbers by decimal points, pad with zeros if needed, subtract as whole numbers, and place the decimal point in the result.',
        'exampleSteps': [
          'Write vertically: 8.75 - 3.21.',
          'Align decimal points: 8.75 and 3.21.',
          'Hundredths: 5 - 1 = 4.',
          'Tenths: 7 - 2 = 5.',
          'Units: 8 - 3 = 5.',
          'Place decimal point: 5.54.',
        ],
        'exampleText':
            '''   8.75\n - 3.21\n -------\n   5.54\n\nAnswer: 8.75 - 3.21 = 5.54''',
      },
    ].where((op) => op["Grade"] == grade).toList();
  }
  //#endregion

   //#region Multiplication Help
   List<Map<String, dynamic>> getMultiplicationHelp(int grade) {
    return [
      {
        'Grade': 1,
        'title': 'Multiplying Two 1-Digit Numbers',
        'description':
            'Multiply two single-digit numbers directly using the multiplication table.',
        'exampleSteps': ['Multiply: 6 × 9 = 54.', 'Result: 54.'],
        'exampleText': '''  6\n× 9\n----\n 54\n\nAnswer: 6 × 9 = 54''',
      },
      {
        'Grade': 1,
        'title': 'Multiplying Two-Digit by One-Digit Number',
        'description':
            'Multiply each digit of the two-digit number by the one-digit number, carrying over as needed.',
        'exampleSteps': [
          'Write: 23 × 4.',
          'Ones: 3 × 4 = 12. Write 2, carry 1.',
          'Tens: 2 × 4 = 8, plus carry 1 = 9.',
          'Result: 92.',
        ],
        'exampleText': '''  23\n×  4\n-----\n  92\n\nAnswer: 23 × 4 = 92''',
      },
      {
        'Grade': 2,
        'title': 'Multiplying Two Two-Digit Numbers',
        'description':
            'Multiply using partial products: multiply each digit of the second number by the first number, shift left for tens, and add the results.',
        'exampleSteps': [
          'Write: 45 × 23.',
          'First partial product (45 × 3):',
          '  Ones: 5 × 3 = 15. Write 5, carry 1.',
          '  Tens: 4 × 3 = 12, plus carry 1 = 13. Write 135.',
          'Second partial product (45 × 20):',
          '  Ones: 5 × 2 = 10. Write 0, carry 1.',
          '  Tens: 4 × 2 = 8, plus carry 1 = 9. Write 900 (shift left).',
          'Add partial products: 135 + 900 = 1035.',
          'Result: 1035.',
        ],
        'exampleText':
            '''   45\n×  23\n------\n  135  (45 × 3)\n+ 900  (45 × 20)\n------\n 1035\n\nAnswer: 45 × 23 = 1035''',
      },
      {
        'Grade': 2,
        'title': 'Multiplying Two-Digit by Two-Digit with Carrying',
        'description':
            'Multiply two-digit numbers, handling carrying when the product of digits exceeds 9.',
        'exampleSteps': [
          'Write: 78 × 45.',
          'First partial product (78 × 5):',
          '  Ones: 8 × 5 = 40. Write 0, carry 4.',
          '  Tens: 7 × 5 = 35, plus carry 4 = 39. Write 390.',
          'Second partial product (78 × 40):',
          '  Ones: 8 × 4 = 32. Write 2, carry 3.',
          '  Tens: 7 × 4 = 28, plus carry 3 = 31. Write 3120 (shift left).',
          'Add partial products: 390 + 3120 = 3510.',
          'Result: 3510.',
        ],
        'exampleText':
            '''    78\n  × 45\n-------\n   390  (78 × 5)\n+ 3120  (78 × 40)\n-------\n  3510\n\nAnswer: 78 × 45 = 3510''',
      },
      {
        'Grade': 3,
        'title': 'Multiplying Two 3-Digit Numbers',
        'description':
            'Multiply each digit of the second number by the first number, shifting left for each place value, and add partial products.',
        'exampleSteps': [
          'Write: 234 × 567.',
          'First partial product (234 × 7):',
          '  Ones: 4 × 7 = 28. Write 8, carry 2.',
          '  Tens: 3 × 7 = 21, plus 2 = 23. Write 3, carry 2.',
          '  Hundreds: 2 × 7 = 14, plus 2 = 16. Write 1638.',
          'Second partial product (234 × 60):',
          '  Ones: 4 × 6 = 24. Write 4, carry 2.',
          '  Tens: 3 × 6 = 18, plus 2 = 20. Write 0, carry 2.',
          '  Hundreds: 2 × 6 = 12, plus 2 = 14. Write 14040.',
          'Third partial product (234 × 500):',
          '  Ones: 4 × 5 = 20. Write 0, carry 2.',
          '  Tens: 3 × 5 = 15, plus 2 = 17. Write 7, carry 1.',
          '  Hundreds: 2 × 5 = 10, plus 1 = 11. Write 117000.',
          'Add: 1638 + 14040 + 117000 = 132678.',
          'Result: 132678.',
        ],
        'exampleText':
            '''     234\n   × 567\n---------\n    1638   (234 × 7)\n+  14040   (234 × 60)\n+ 117000  (234 × 500)\n---------\n  132678\n\nAnswer: 234 × 567 = 132678''',
      },
      {
        'Grade': 4,
        'title': 'Multiplying Four-Digit by One-Digit with Carrying',
        'description':
            'Multiply a four-digit number by a one-digit number, handling carrying when the product of digits exceeds 9.',
        'exampleSteps': [
          'Write: 5432 × 7.',
          'Ones: 2 × 7 = 14. Write 4, carry 1.',
          'Tens: 3 × 7 = 21, plus carry 1 = 22. Write 2, carry 2.',
          'Hundreds: 4 × 7 = 28, plus carry 2 = 30. Write 0, carry 3.',
          'Thousands: 5 × 7 = 35, plus carry 3 = 38. Write 38.',
          'Result: 38024.',
        ],
        'exampleText':
            '''  5432\n ×   7\n-------\n 38024\n\nAnswer: 5432 × 7 = 38024''',
      },
      {
        'Grade': 4,
        'title': 'Multiplying Two 4-Digit Numbers',
        'description':
            'Multiply each digit of the second number by the first number, shifting left for each place value, and add partial products.',
        'exampleSteps': [
          'Write: 1234 × 5678.',
          'First partial product (1234 × 8):',
          '  Ones: 4 × 8 = 32. Write 2, carry 3.',
          '  Tens: 3 × 8 = 24, plus 3 = 27. Write 7, carry 2.',
          '  Hundreds: 2 × 8 = 16, plus 2 = 18. Write 8, carry 1.',
          '  Thousands: 1 × 8 = 8, plus 1 = 9. Write 9872.',
          'Second partial product (1234 × 70):',
          '  Ones: 4 × 7 = 28. Write 8, carry 2.',
          '  Tens: 3 × 7 = 21, plus 2 = 23. Write 3, carry 2.',
          '  Hundreds: 2 × 7 = 14, plus 2 = 16. Write 6, carry 1.',
          '  Thousands: 1 × 7 = 7, plus 1 = 8. Write 86380.',
          'Third partial product (1234 × 600):',
          '  Ones: 4 × 6 = 24. Write 4, carry 2.',
          '  Tens: 3 × 6 = 18, plus 2 = 20. Write 0, carry 2.',
          '  Hundreds: 2 × 6 = 12, plus 2 = 14. Write 4, carry 1.',
          '  Thousands: 1 × 6 = 6, plus 1 = 7. Write 740400.',
          'Fourth partial product (1234 × 5000):',
          '  Ones: 4 × 5 = 20. Write 0, carry 2.',
          '  Tens: 3 × 5 = 15, plus 2 = 17. Write 7, carry 1.',
          '  Hundreds: 2 × 5 = 10, plus 1 = 11. Write 1, carry 1.',
          '  Thousands: 1 × 5 = 5, plus 1 = 6. Write 6170000.',
          'Add: 9872 + 86380 + 740400 + 6170000 = 7006652.',
          'Result: 7006652.',
        ],
        'exampleText':
            '''     1234\n  ×  5678\n----------\n     9872  (1234 × 8)\n+   86380  (1234 × 70)\n+  740400  (1234 × 600)\n+ 6170000  (1234 × 5000)\n----------\n  7006652\n\nAnswer: 1234 × 5678 = 7006652''',
      },
      {
        'Grade': 4,
        'title': 'Multiplying Two 5-Digit Numbers',
        'description':
            'Multiply each digit of the second number by the first number, shifting left for each place value, and add partial products.',
        'exampleSteps': [
          'Write: 12345 × 23456.',
          'Due to the large number of steps, use a simplified partial product overview:',
          '  First: 12345 × 6 = 74070.',
          '  Second: 12345 × 50 = 617250.',
          '  Third: 12345 × 400 = 4938000.',
          '  Fourth: 12345 × 3000 = 37035000.',
          '  Fifth: 12345 × 20000 = 246900000.',
          'Add partial products: 74070 + 617250 + 4938000 + 37035000 + 246900000 = 289564320.',
          'Result: 289564320.',
        ],
        'exampleText':
            '''      12345\n   ×  23456\n------------\n      74070  (12345 × 6)\n+    617250  (12345 × 50)\n+   4938000  (12345 × 400)\n+  37035000  (12345 × 3000)\n+ 246900000  (12345 × 20000)\n------------\n  289564320\n\nAnswer: 12345 × 23456 = 289564320''',
      },
      {
        'Grade': 5,
        'title': 'Multiplying Two 6-Digit Numbers',
        'description':
            'Multiply each digit of the second number by the first number, shifting left for each place value, and add partial products.',
        'exampleSteps': [
          'Write: 123456 × 234567.',
          'Due to the large number of steps, use a simplified partial product overview:',
          '  First: 123456 × 7 = 864192.',
          '  Second: 123456 × 60 = 7407360.',
          '  Third: 123456 × 900 = 111110400.',
          '  Fourth: 123456 × 4000 = 493824000.',
          '  Fifth: 123456 × 30000 = 3703680000.',
          '  Sixth: 123456 × 200000 = 24691200000.',
          'Add partial products: 864192 + 7407360 + 111110400 + 493824000 + 3703680000 + 24691200000 = 28966176552.',
          'Result: 28966176552.',
        ],
        'exampleText':
            '''      123456\n   ×  234567\n-------------\n      864192 (123456×7)\n+    7407360 (123456×60)\n+  111110400 (123456×900)\n+  493824000 (123456×4000)\n+ 3703680000 (123456×30000)\n+24691200000 (123456×200000)\n-------------\n 28966176552\n\nAnswer: 123456 × 234567 = 28966176552''',
      },

      {
        'Grade': 5,
        'title': 'Multiplying Decimal Numbers',
        'description':
            'Multiply as whole numbers, then adjust the decimal point based on the total number of decimal places in the factors.',
        'exampleSteps': [
          'Write: 3.14 × 2.5.',
          'Convert to whole numbers: 314 × 25.',
          'First partial product (314 × 5):',
          '  Ones: 4 × 5 = 20. Write 0, carry 2.',
          '  Tens: 1 × 5 = 5, plus 2 = 7. Write 7, carry 0.',
          '  Hundreds: 3 × 5 = 15. Write 1570.',
          'Second partial product (314 × 20):',
          '  Ones: 4 × 2 = 8. Write 8, carry 0.',
          '  Tens: 1 × 2 = 2. Write 2, carry 0.',
          '  Hundreds: 3 × 2 = 6. Write 6280.',
          'Add: 1570 + 6280 = 7850.',
          'Count decimal places: 3.14 (2) + 2.5 (1) = 3 places.',
          'Adjust: 7850 → 7.850.',
          'Result: 7.85.',
        ],
        'exampleText':
            '''  3.14\n× 2.50\n-------\n  1570 (314 × 5)\n+ 6280 (314 × 20)\n-------\n  7850\n\nAnswer: 3.14 × 2.5 = 7.85''',
      },
    ].where((op) => op["Grade"] == grade).toList();
  }
  //#endregion

   //#region Division Help
   List<Map<String, dynamic>> getDivisionHelp(int grade) {
    return [
      {
        'Grade': 1,
        'title': 'Dividing Two 1-Digit Numbers',
        'description':
            'Divide one single-digit number by another, ensuring the divisor is not zero.',
        'exampleSteps': [
          'Set up: 8 ÷ 2.',
          'Determine how many times 2 fits into 8: 2 × 4 = 8.',
          'Write quotient: 4.',
          'Check remainder: 8 - 8 = 0.',
          'Result: 4.',
        ],
        'exampleText':
            '''    4\n   ____\n2 )  8\n   - 8\n  -----\n     0\n\nAnswer: 8 ÷ 2 = 4''',
      },
      {
        'Grade': 1,
        'title': 'Dividing One-Digit Number by One-Digit Number',
        'description':
            'Divide one single-digit number by another, ensuring the divisor is not zero, and extend the division to include decimal places for a floating-point result.',
        'exampleSteps': [
          'Set up: 7 ÷ 2.',
          'Determine how many times 2 fits into 7: 2 × 3 = 6.',
          'Write 3, subtract: 7 - 6 = 1.',
          'Add a decimal point and bring down a 0: 10.',
          'Divide: 2 into 10. 2 × 5 = 10. Write 5, subtract: 10 - 10 = 0.',
          'Quotient: 3.5, remainder: 0.',
          'Result: 3.5.',
        ],
        'exampleText':
            '''    3.5\n    ______\n2 )  7.0\n   - 6\n   ------\n     1 0\n   - 1 0\n   ------\n      0\n\nAnswer: 7 ÷ 2 = 3.5''',
      },
      {
        'Grade': 2,
        'title': 'Dividing Two-Digit by One-Digit Number',
        'description':
            'Use long division to divide a two-digit number by a single-digit number.',
        'exampleSteps': [
          'Set up: 48 ÷ 4.',
          'Tens: 4 into 4 (tens). 4 × 1 = 4. Write 1, subtract: 4 - 4 = 0.',
          'Bring down 8: 08.',
          'Ones: 4 into 8. 4 × 2 = 8. Write 2, subtract: 8 - 8 = 0.',
          'Quotient: 12, remainder: 0.',
          'Result: 12.',
        ],
        'exampleText':
            '''     12\n   _____\n4 )  48\n   - 4\n   -----\n     08\n   - 08\n   -----\n      0\n\nAnswer: 48 ÷ 4 = 12''',
      },
      {
        'Grade': 2,
        'title': 'Dividing Two Two-Digit Numbers',
        'description':
            'Use long division to divide a two-digit number by another two-digit number.',
        'exampleSteps': [
          'Set up: 96 ÷ 24.',
          'Estimate: 24 into 96. Try 4: 24 × 4 = 96.',
          'Write 4, subtract: 96 - 96 = 0.',
          'No digits to bring down.',
          'Quotient: 4, remainder: 0.',
          'Result: 4.',
        ],
        'exampleText':
            '''      4\n    _____\n24 )  96\n    - 96\n    ------\n      0\n\nAnswer: 96 ÷ 24 = 4''',
      },
      {
        'Grade': 3,
        'title': 'Dividing a 3-Digit Number by a 1-Digit Number',
        'description':
            'Use long division to divide a three-digit number by a single-digit number, processing each digit from left to right.',
        'exampleSteps': [
          'Set up: 432 ÷ 4.',
          'Hundreds: 4 into 4 (hundreds). 4 × 1 = 4. Write 1, subtract: 4 - 4 = 0.',
          'Bring down 3: 03 (tens).',
          'Tens: 4 into 3. 4 × 0 = 0. Write 0, subtract: 3 - 0 = 3.',
          'Bring down 2: 32 (ones).',
          'Ones: 4 into 32. 4 × 8 = 32. Write 8, subtract: 32 - 32 = 0.',
          'Quotient: 108, remainder: 0.',
          'Result: 108.',
        ],
        'exampleText':
            '''     108\n   _______\n4 ) 432\n   -4\n  ------ \n    03 \n   - 0 \n  ------ \n     32 \n   - 32 \n  ------ \n      0 \n\nAnswer: 432 ÷ 4 = 108''',
      },
      {
        'Grade': 3,
        'title': 'Dividing Two 3-Digit Numbers',
        'description':
            'Use long division to divide a three-digit number by another three-digit number.',
        'exampleSteps': [
          'Set up: 984 ÷ 246.',
          'Estimate: 246 into 984. Try 4: 246 × 4 = 984.',
          'Write 4, subtract: 984 - 984 = 0.',
          'No digits to bring down.',
          'Quotient: 4, remainder: 0.',
          'Result: 4.',
        ],
        'exampleText':
            '''       4\n     ______\n246 )  984\n     - 984\n    -------\n       0\n\nAnswer: 984 ÷ 246 = 4''',
      },
      {
        'Grade': 4,
        'title': 'Dividing Two 4-Digit Numbers',
        'description':
            'Use long division to divide a four-digit number by another four-digit number.',
        'exampleSteps': [
          'Set up: 9876 ÷ 2469.',
          'Estimate: 2469 into 9876. Try 4: 2469 × 4 = 9876.',
          'Write 4, subtract: 9876 - 9876 = 0.',
          'No digits to bring down.',
          'Quotient: 4, remainder: 0.',
          'Result: 4.',
        ],
        'exampleText':
            '''       4\n      _____\n2469 ) 9876\n      -9876\n     ------\n       0\n\nAnswer: 9876 ÷ 2469 = 4''',
      },
      {
        'Grade': 5,
        'title': 'Dividing Two 5-Digit Numbers',
        'description':
            'Use long division to divide a five-digit number by another five-digit number, working digit by digit and handling remainders.',
        'exampleSteps': [
          'Set up: 98765 ÷ 12345.',
          'Estimate: 12345 into 98765. Try 8: 12345 × 8 = 98760.',
          'Write 8, subtract: 98765 - 98760 = 5.',
          'No digits to bring down.',
          'Quotient: 8, remainder: 5.',
          'Result: 8 remainder 5.',
        ],
        'exampleText':
            '''        8\n       _______\n12345 ) 98765 \n       -98760\n      --------\n        5 \nAnswer: 98765 ÷ 12345 = 8 remainder 5''',
      },
      {
        'Grade': 5,
        'title': 'Dividing Two 6-Digit Numbers',
        'description':
            'Use long division to divide a six-digit number by another six-digit number.',
        'exampleSteps': [
          'Set up: 888888 ÷ 222222.',
          'Estimate: 222222 into 888888. Try 4: 222222 × 4 = 888888.',
          'Write 4, subtract: 888888 - 888888 = 0.',
          'No digits to bring down.',
          'Quotient: 4, remainder: 0.',
          'Result: 4.',
        ],
        'exampleText':
            '''          4\n        ________\n222222 )  888888\n        - 888888\n       ---------\n          0\n\nAnswer: 888888 ÷ 222222 = 4''',
      },
      {
        'Grade': 5,
        'title': 'Dividing Decimal Numbers',
        'description':
            'Adjust the dividend and divisor to whole numbers by moving the decimal point, then perform long division.',
        'exampleSteps': [
          'Set up: 12.5 ÷ 2.5.',
          'Move decimal points: 12.5 → 125, 2.5 → 25 (multiply both by 10).',
          'Divide: 125 ÷ 25.',
          'Estimate: 25 into 125. Try 5: 25 × 5 = 125.',
          'Write 5, subtract: 125 - 125 = 0.',
          'Quotient: 5, remainder: 0.',
          'No decimal adjustment needed (same decimal places moved).',
          'Result: 5.',
        ],
        'exampleText':
            '''      5\n    _____\n25 ) 125\n    -125\n   -------\n     0\n\nAnswer: 12.5 ÷ 2.5 = 5''',
      },
    ].where((op) => op["Grade"] == grade).toList();
  }
  //#endregion
}
