import 'dart:math';
import 'WordProblem.dart';

class Operations{
  //#region Addition Operation
  static List<Map<String, dynamic>> getSumOperations(int grade) {
    return [
      {
        "title": "Single Digit Addition Without Carry",
        "Grade": 1,
        "generateNumbers": () {
          int digit1 = Random().nextInt(9) + 1;
          int digit2 = Random().nextInt(9 - digit1+1)+1;
          return {
            "number1": digit1,
            "number2": digit2,
            "number3": null,
            "number4": null,
            "result": digit1 + digit2,
            "sign": "+",
          };
        },
      },
      {
        "title": "Single Digit Addition With Carry",
        "Grade": 1,
        "generateNumbers": () {
          int digit1 = Random().nextInt(5) + 5;
          int digit2 = Random().nextInt(5) + 5;
          int result = digit1 + digit2;
          return {
            "number1": digit1,
            "number2": digit2,
            "number3": null,
            "number4": null,
            "result": result,
            "sign": "+",
          };
        },
      },
      {
        "title": "Sum Of Two Digit Number",
        "Grade": 1,
        "generateNumbers": () {
          int num1 = Random().nextInt(90) + 10;
          int num2 = Random().nextInt(90) + 10;
          int result = num1 + num2;
          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": result,
            "sign": "+",
          };
        },
      },
      {
        "title": "Sum Of Two Digit Number With Carry",
        "Grade": 1,
        "generateNumbers": () {
          int num1 = Random().nextInt(90) + 10;
          int num2 = Random().nextInt(90) + 10;
          int result = num1 + num2;
          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": result,
            "sign": "+",
          };
        },
      },
      {
        "title": "Add Two-Digit and One-Digit Without Regrouping",
        "Grade": 1,
        "generateNumbers": () {
          int tens = Random().nextInt(9) + 1;
          int ones = Random().nextInt(9) + 1;
          int digit = Random().nextInt(9 - ones+1) +1;
          return {
            "number1": tens * 10 + ones,
            "number2": digit,
            "number3": null,
            "number4": null,
            "result": tens * 10 + ones + digit,
            "sign": "+",
          };
        },
      },
      {
        "title": "Addition of Whole Tens",
        "Grade": 1,
        "generateNumbers": () {
          int num1 = (Random().nextInt(10) + 1) * 10;
          int num2 = (Random().nextInt(10) + 1) * 10;
          int result = num1 + num2;
          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": result,
            "sign": "+",
          };
        },
      },
      {
        "title": "Word Problem",
        "Grade": 1,
        "generateNumbers": () {
          WordProblem problem = WordProblem();
          List<dynamic> nums = problem.getQuestion();
          return {
            "number1": nums[0],
            "number2":null,
            "number3": null,
            "number4":  null,
            "result": nums.last,
            "sign": "+",
          };
        },
      },

      {
        "title": "Add Two-Digit Numbers With Regrouping",
        "Grade": 2,
        "generateNumbers": () {
          int num1 = Random().nextInt(90) + 10;
          int num2 = Random().nextInt(90) + 10;
          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": num1 + num2,
            "sign": "+",
          };
        },
      },
      {
        "title": "Add Two-Digit Numbers Without Regrouping",
        "Grade": 2,
        "generateNumbers": () {
          int num1 = Random().nextInt(5) * 10 + Random().nextInt(10);
          int num2 = Random().nextInt(5) * 10 + Random().nextInt(10);
          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": num1 + num2,
            "sign": "+",
          };
        },
      },
      {
        "title": "Sum Of Two Digit Number Answer IN Three Digit",
        "Grade": 2,
        "generateNumbers": () {
          int num1 = Random().nextInt(50) + 50;
          int num2 = Random().nextInt(50) + 50;
          int result = num1 + num2;
          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": result,
            "sign": "+",
          };
        },
      },
      {
        "title": "Addition of Whole Hundreds",
        "Grade": 2,
        "generateNumbers": () {
          int num1 = (Random().nextInt(10) + 1) * 100;
          int num2 = (Random().nextInt(10) + 1) * 100;
          int result = num1 + num2;
          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": result,
            "sign": "+",
          };
        },
      },
      {
        "title": "Addition of Three 2-Digit Numbers",
        "Grade": 2,
        "generateNumbers": () {
          int num1 = Random().nextInt(90) + 10;
          int num2 = Random().nextInt(90) + 10;
          int num3 = Random().nextInt(90) + 10;
          int result = num1 + num2 + num3;
          return {
            "number1": num1,
            "number2": num2,
            "number3": num3,
            "number4": null,
            "result": result,
            "sign": "+",
          };
        },
      },
      {
        "title": "Add Three-Digit Numbers Without Regrouping",
        "Grade": 3,
        "generateNumbers": () {
          int num1 = Random().nextInt(900) + 100;
          int num2 = Random().nextInt(900) + 100;
          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": num1 + num2,
            "sign": "+",
          };
        },
      },
      {
        "title": "Add Three-Digit Numbers With Regrouping",
        "Grade": 3,
        "generateNumbers": () {
          int num1 = Random().nextInt(900) + 100;
          int num2 = Random().nextInt(900) + 100;
          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": num1 + num2,
            "sign": "+",
          };
        },
      },
      {
        "title": "Addition of Three 3-Digit Numbers",
        "Grade": 3,
        "generateNumbers": () {
          int num1 = Random().nextInt(900) + 100;
          int num2 = Random().nextInt(900) + 100;
          int num3 = Random().nextInt(900) + 100;
          int result = num1 + num2 + num3;
          return {
            "number1": num1,
            "number2": num2,
            "number3": num3,
            "number4": null,
            "result": result,
            "sign": "+",
          };
        },
      },
      {
        "title": "Addition of Four 3-Digit Numbers",
        "Grade": 3,
        "generateNumbers": () {
          int num1 = Random().nextInt(900) + 100;
          int num2 = Random().nextInt(900) + 100;
          int num3 = Random().nextInt(900) + 100;
          int num4 = Random().nextInt(900) + 100;
          int result = num1 + num2 + num3 + num4;
          return {
            "number1": num1,
            "number2": num2,
            "number3": num3,
            "number4": num4,
            "result": result,
            "sign": "+",
          };
        },
      },

      {
        "title": "Add Two 4-Digit Numbers",
        "Grade": 3,
        "generateNumbers": () {
          int num1 = Random().nextInt(9000) + 1000;
          int num2 = Random().nextInt(9000) + 1000;
          int result = num1 + num2;
          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": result,
            "sign": "+",
          };
        },
      },
      {
        "title": "Addition Of Decimal Number",
        "Grade": 3,
        "generateNumbers": () {
          double num1 = double.parse((Random().nextDouble() * 10).toStringAsFixed(2));
          double num2 = double.parse((Random().nextDouble() * 10).toStringAsFixed(2));
          double result = num1 + num2;
          return {
            "number1": num1.toStringAsFixed(2),
            "number2": num2.toStringAsFixed(2),
            "number3": null,
            "number4": null,
            "result": result.toStringAsFixed(2),
            "sign": "+",
          };

        },
      },

      {
        "title": "Fraction Addition",
        "Grade": 4,
        "generateNumbers": () {
          int numerator1 = Random().nextInt(10) + 1;
          int denominator1 = Random().nextInt(10) + 1;
          int numerator2 = Random().nextInt(10) + 1;
          int denominator2 = Random().nextInt(10) + 1;

          int resultNumerator = (numerator1 * denominator2) + (numerator2 * denominator1);
          int resultDenominator = denominator1 * denominator2;

          int gcd(int a, int b) => b == 0 ? a : gcd(b, a % b);
          int commonFactor = gcd(resultNumerator, resultDenominator);
          resultNumerator ~/= commonFactor;
          resultDenominator ~/= commonFactor;

          return {
            "number1": "$numerator1/$denominator1",
            "number2": "$numerator2/$denominator2",
            "number3": null,
            "number4": null,
            "result": "$resultNumerator/$resultDenominator",
            "sign": "+",
          };
        }
      },
      {
        "title": "Negative Number Addition",
        "Grade": 4,
        "generateNumbers": () {
          int digit1 = Random().nextInt(15) - 10;
          int digit2 = Random().nextInt(20) - 10;
          int result = digit1 + digit2;
          return {
            "number1": digit1,
            "number2": digit2,
            "number3": null,
            "number4": null,
            "result": result,
            "sign": "+",
          };
        },
      },
      {
        "title": "Add Two Four-Digit Numbers",
        "Grade": 4,
        "generateNumbers": () {
          int num1 = Random().nextInt(9000) + 1000;
          int num2 = Random().nextInt(9000) + 1000;
          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": num1 + num2,
            "sign": "+",
          };
        },
      },
      {
        "Grade": 4,
        "title": "Addition of Three 4-Digit Numbers",
        "generateNumbers": () {
          int num1 = Random().nextInt(9000) + 1000;
          int num2 = Random().nextInt(9000) + 1000;
          int num3 = Random().nextInt(9000) + 1000;
          int result = num1 + num2 + num3;
          return {
            "number1": num1,
            "number2": num2,
            "number3": num3,
            "number4": null,
            "result": result,
            "sign": "+",
          };
        },
      },
      {
        "title": "Addition of Four 4-Digit Numbers",
        "Grade": 4,
        "generateNumbers": () {
          int num1 = Random().nextInt(9000) + 1000;
          int num2 = Random().nextInt(9000) + 1000;
          int num3 = Random().nextInt(9000) + 1000;
          int num4 = Random().nextInt(9000) + 1000;
          int result = num1 + num2 + num3 + num4;
          return {
            "number1": num1,
            "number2": num2,
            "number3": num3,
            "number4": num4,
            "result": result,
            "sign": "+",
          };
        },
      },

      {
        "title": "Add Three Four-Digit Numbers",
        "Grade": 4,
        "generateNumbers": () {
          int num1 = Random().nextInt(9000) + 1000;
          int num2 = Random().nextInt(9000) + 1000;
          int num3 = Random().nextInt(9000) + 1000;
          return {
            "number1": num1,
            "number2": num2,
            "number3": num3,
            "number4": null,
            "result": num1 + num2 + num3,
            "sign": "+",
          };
        },
      },
      {
        "title": "Add Three Numbers Each Up to Four Digits",
        "Grade": 4,
        "generateNumbers": () {
          int num1 = Random().nextInt(10000);
          int num2 = Random().nextInt(10000);
          int num3 = Random().nextInt(10000);
          return {
            "number1": num1,
            "number2": num2,
            "number3": num3,
            "number4": null,
            "result": num1 + num2 + num3,
            "sign": "+",
          };
        },
      },
      {
        "title": "Multi-Digit Addition",
        "Grade": 4,
        "generateNumbers": () {
          int num1 = Random().nextInt(9000) + 1000;
          int num2 = Random().nextInt(9000) + 1000;
          int result = num1 + num2;
          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": result,
            "sign": "+",
          };
        },
      },
      {
        "title": "Add Two 5-Digit Numbers",
        "Grade": 4,
        "generateNumbers": () {
          int num1 = Random().nextInt(90000) + 10000;
          int num2 = Random().nextInt(90000) + 10000;
          int result = num1 + num2;
          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": result,
            "sign": "+",
          };
        },
      },
      {
        "title": "Addition of Three 5-Digit Numbers",
        "Grade": 4,
        "generateNumbers": () {
          int num1 = Random().nextInt(90000) + 10000;
          int num2 = Random().nextInt(90000) + 10000;
          int num3 = Random().nextInt(90000) + 10000;
          int result = num1 + num2 + num3;
          return {
            "number1": num1,
            "number2": num2,
            "number3": num3,
            "number4": null,
            "result": result,
            "sign": "+",
          };
        },
      },
      {
        "title": "Addition of Four 5-Digit Numbers",
        "Grade": 4,
        "generateNumbers": () {
          int num1 = Random().nextInt(90000) + 10000;
          int num2 = Random().nextInt(90000) + 10000;
          int num3 = Random().nextInt(90000) + 10000;
          int num4 = Random().nextInt(90000) + 10000;
          int result = num1 + num2 + num3 + num4;
          return {
            "number1": num1,
            "number2": num2,
            "number3": num3,
            "number4": num4,
            "result": result,
            "sign": "+",
          };
        },
      },


      {
        "title": "Complex Number Addition",
        "Grade": 5,
        "generateNumbers": () {
          int real1 = Random().nextInt(10);
          int imaginary1 = Random().nextInt(10);
          int real2 = Random().nextInt(10);
          int imaginary2 = Random().nextInt(10);
          return {
            "number1": "${real1}+${imaginary1}i",
            "number2": "${real2}+${imaginary2}i",
            "number3": null,
            "number4": null,
            "result": "${real1 + real2}+${imaginary1 + imaginary2}i",
            "sign": "+",
          };
        },
      },
      {
        "title": "Binary Addition",
        "Grade": 5,
        "generateNumbers": () {
          String num1 = (Random().nextInt(64)).toRadixString(2).padLeft(4, '0');
          String num2 = (Random().nextInt(64)).toRadixString(2).padLeft(4, '0');
          int intResult = int.parse(num1, radix: 2) + int.parse(num2, radix: 2);
          String binaryResult = intResult.toRadixString(2).padLeft(4, '0');
          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": binaryResult,
            "sign": "+",
          };
        },
      },
      {
        "title": "Add Two 6-Digit Numbers",
        "Grade": 5,
        "generateNumbers": () {
          int num1 = Random().nextInt(900000) + 100000;
          int num2 = Random().nextInt(900000) + 100000;
          int result = num1 + num2;
          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": result,
            "sign": "+",
          };
        },
      },
      {
        "title": "Addition of Three 6-Digit Numbers",
        "Grade": 5,
        "generateNumbers": () {
          int num1 = Random().nextInt(900000) + 100000;
          int num2 = Random().nextInt(900000) + 100000;
          int num3 = Random().nextInt(900000) + 100000;
          int result = num1 + num2 + num3;
          return {
            "number1": num1,
            "number2": num2,
            "number3": num3,
            "number4": null,
            "result": result,
            "sign": "+",
          };
        },
      },
    ].where((op) => op["Grade"] == grade).toList();
  }
  //#endregion

  //#region Minus Operation
  static List<Map<String, dynamic>> getSubtractionOperations(int grade) {
    return [
      {
        "title": "Single Digit Subtraction",
        "Grade": 1,
        "generateNumbers": () {
          int num1 = Random().nextInt(9) + 1;
          int num2 = Random().nextInt(num1) + 1;

          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": num1 - num2,
            "sign": "-",
          };
        }
      },
      {
        "title": "Subtract a 1-Digit Number from 2-Digit Number Without Borrowing",
        "Grade": 1,
        "generateNumbers": () {
          int num1 = Random().nextInt(90) + 10;
          int num2 = Random().nextInt(10);
          if ((num1 % 10) < num2) {
            num1 += 10;
          }
          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": num1 - num2,
            "sign": "-",
          };
        },
      },
      {
        "title":
        "Subtract a 2-Digit Number from 2-Digit Number Without Borrowing",
        "Grade": 1,
        "generateNumbers": () {
          int num1 = Random().nextInt(90) + 10;
          int num2 = Random().nextInt(90) + 10;
          if ((num1 % 10) < (num2 % 10)) {
            num1 += 10;
          }
          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": num1 - num2,
            "sign": "-",
          };
        },
      },
      {
        "title": "Subtraction with Borrowing Over Three Zeros",
        "Grade": 1,
        "generateNumbers": () {
          int num1 = 1000; // Force leading zeros
          int num2 = Random().nextInt(900) + 100;
          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": num1 - num2,
            "sign": "-",
          };
        },
      },
      {
        "title": "Subtract Whole Tens",
        "Grade": 1,
        "generateNumbers": () {
          int num1 = (Random().nextInt(10) + 1) * 10;
          int num2 = (Random().nextInt(10) + 1) * 10;
          if (num1 < num2) {
            int temp = num1;
            num1 = num2;
            num2 = temp;
          }
          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": num1 - num2,
            "sign": "-",
          };
        },
      },


      {
        "title": "Subtract a 1-Digit Number from 2-Digit Number With Borrowing",
        "Grade": 2,
        "generateNumbers": () {
          int num1 = Random().nextInt(90) + 10;
          int num2 = Random().nextInt(10);
          if ((num1 % 10) >= num2) {
            num1 -= 10; // Force borrowing
          }
          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": num1 - num2,
            "sign": "-",
          };
        },
      },
      {
        "title": "Subtract a 2-Digit Number from 2-Digit Number With Borrowing",
        "Grade": 2,
        "generateNumbers": () {
          int num1 = Random().nextInt(90) + 10;
          int num2 = Random().nextInt(90) + 10;
          if ((num1 % 10) >= (num2 % 10)) {
            num1 -= 10; // Force borrowing
          }
          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": num1 - num2,
            "sign": "-",
          };
        },
      },
      {
        "title": "Subtract a 1-Digit Number from 2-Digit Number With Borrowing for 3-Digit",
        "Grade": 2,
        "generateNumbers": () {
          int num1 = Random().nextInt(900) + 100; // Three-digit number
          int num2 = Random().nextInt(10); // One-digit number
          if ((num1 % 10) >= num2) {
            num1 -= 10; // Force borrowing
          }
          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": num1 - num2,
            "sign": "-",
          };
        },
      },
      {
        "title":
        "Subtract a 2-Digit Number from 2-Digit Number With Borrowing for 3-Digit",
        "Grade": 3,
        "generateNumbers": () {
          int num1 = Random().nextInt(900) + 100;
          int num2 = Random().nextInt(90) + 10;
          if ((num1 % 10) >= (num2 % 10)) {
            num1 -= 10; // Force borrowing
          }
          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": num1 - num2,
            "sign": "-",
          };
        },
      },
      {
        "title": "Subtraction of Whole Hundreds",
        "Grade": 2,
        "generateNumbers": () {
          int num1 = (Random().nextInt(10) + 1) * 100;
          int num2 = (Random().nextInt(10) + 1) * 100;
          if (num1 < num2) {
            int temp = num1;
            num1 = num2;
            num2 = temp;
          }
          int result = num1 - num2;
          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": result,
            "sign": "+",
          };
        },
      },
      {
        "title": "Borrowing Over Zeros (2-Digit and 3-Digit)",
        "Grade": 3,
        "generateNumbers": () {
          int num1 = Random().nextInt(900) + 100; // Three-digit number
          int num2 = Random().nextInt(90) + 10; // Two-digit number
          if (num1 % 10 != 0) num1 = (num1 ~/ 10) * 10; // Force trailing zero
          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": num1 - num2,
            "sign": "-",
          };
        },
      },
      {
        "title": "Subtract Two Numbers up to 3-Digits Each",
        "Grade": 3,
        "generateNumbers": () {
          int num1 = Random().nextInt(900) + 100;
          int num2 = Random().nextInt(900) + 100;
          if (num1 < num2) {
            int temp = num1;
            num1 = num2;
            num2 = temp;
          }
          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": num1 - num2,
            "sign": "-",
          };
        },
      },
      {
        "title": "Subtraction for 3-Digit Numbers",
        "Grade": 3,
        "generateNumbers": () {
          int num1 = Random().nextInt(900) + 100; // Three-digit number (100-999)
          int num2 = Random().nextInt(num1 - 99) + 100; // Ensures num2 <= num1

          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": num1 - num2,
            "sign": "-",
          };
        }
      },
      {
        "title": "Subtraction for 3-Digit Numbers with Borrow",
        "Grade": 3,
        "generateNumbers": () {
          int num1 = Random().nextInt(900) + 100; // Three-digit number (100-999)
          int num2 = Random().nextInt(num1 - 99) + 100; // Ensures num2 <= num1

          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": num1 - num2,
            "sign": "-",
          };
        }
      },
      {
        "title": "Subtract Two 4-Digit Numbers",
        "Grade": 4,
        "generateNumbers": () {
          int num1 = Random().nextInt(9000) + 1000;
          int num2 = Random().nextInt(9000) + 1000;
          if (num1 < num2) {
            int temp = num1;
            num1 = num2;
            num2 = temp;
          }
          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": num1 - num2,
            "sign": "-",
          };
        },
      },


      {
        "title": "Subtract Two Numbers up to 5-Digits",
        "Grade": 4,
        "generateNumbers": () {
          int num1 = Random().nextInt(90000) + 10000;
          int num2 = Random().nextInt(90000) + 10000;
          if (num1 < num2) {
            int temp = num1;
            num1 = num2;
            num2 = temp;
          }
          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": num1 - num2,
            "sign": "-",
          };
        },
      },
      {
        "title": "Subtract Two 5-Digit Numbers",
        "Grade": 4,
        "generateNumbers": () {
          int num1 = Random().nextInt(90000) + 10000;
          int num2 = Random().nextInt(90000) + 10000;
          if (num1 < num2) {
            int temp = num1;
            num1 = num2;
            num2 = temp;
          }
          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": num1 - num2,
            "sign": "-",
          };
        },
      },
      {
        "title": "Subtract Two 6-Digit Numbers",
        "Grade": 5,
        "generateNumbers": () {
          int num1 = Random().nextInt(900000) + 100000;
          int num2 = Random().nextInt(900000) + 100000;
          if (num1 < num2) {
            int temp = num1;
            num1 = num2;
            num2 = temp;
          }
          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": num1 - num2,
            "sign": "-",
          };
        },
      },
      {
        "title": "Subtract Three 4-Digit Numbers",
        "Grade": 5,
        "generateNumbers": () {
          int num1 = Random().nextInt(5000) + 5000; // 5000 - 9999
          int num2 = Random().nextInt(3000) + 1000;
          int num3 = Random().nextInt(1000) + 1000;

          int result = num1 - num2 - num3;
          if (result < 0) {
            return null; // skip if too low, or regenerate
          }

          return {
            "number1": num1,
            "number2": num2,
            "number3": num3,
            "number4": null,
            "result": result,
            "sign": "-",
          };
        },
      },
      {
        "title": "Subtract Four 4-Digit Numbers",
        "Grade": 5,
        "generateNumbers": () {
          int num1 = Random().nextInt(2000) + 8000;
          int num2 = Random().nextInt(1000) + 1000;
          int num3 = Random().nextInt(1000) + 1000;
          int num4 = Random().nextInt(1000) + 1000;

          int result = num1 - num2 - num3 - num4;
          if (result < 0) {
            return null;
          }

          return {
            "number1": num1,
            "number2": num2,
            "number3": num3,
            "number4": num4,
            "result": result,
            "sign": "-",
          };
        },
      },
      {
        "title": "Subtract a 6-Digit Number with Two Smaller Numbers",
        "Grade": 5,
        "generateNumbers": () {
          int num1 = Random().nextInt(400000) + 600000;
          int num2 = Random().nextInt(90000) + 10000;
          int num3 = Random().nextInt(9000) + 1000;

          int result = num1 - num2 - num3;
          if (result < 0) return null;

          return {
            "number1": num1,
            "number2": num2,
            "number3": num3,
            "number4": null,
            "result": result,
            "sign": "-",
          };
        },
      },

      {
        "title": "Subtraction Of Decimal Number",
        "Grade": 5,
        "generateNumbers": () {
          double num1 =
          double.parse((Random().nextDouble() * 10).toStringAsFixed(2));
          double num2 =
          double.parse((Random().nextDouble() * 10).toStringAsFixed(2));
          if (num1 < num2) {
            double temp = num1;
            num1 = num2;
            num2 = temp;
          }
          return {
            "number1": num1.toStringAsFixed(2),
            "number2": num2.toStringAsFixed(2),
            "number3": null,
            "number4": null,
            "result": (num1 - num2).toStringAsFixed(2),
            "sign": "-",
          };
        }
      },
    ].where((op) => op["Grade"] == grade).toList();
  }
  //#endregion

  //#region Multiplication Operation
  static List<Map<String, dynamic>> getMultiplicationOperations(int grade) {
    return [
      {
        "title": "Multiply a 1-Digit Number by Another 1-Digit Number",
        "Grade": 1,
        "generateNumbers": () {
          int num1 = Random().nextInt(10);
          int num2 = Random().nextInt(10);

          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": num1 * num2,
            "sign": "X",
          };
        }
      },
      {
        "title": "Multiply a 2-Digit Number by a 1-Digit Number",
        "Grade": 1,
        "generateNumbers": () {
          int num1 = Random().nextInt(90) + 10; // Two-digit numbers
          int num2 = Random().nextInt(9) + 1;

          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": num1 * num2,
            "sign": "X",
          };
        }
      },
      {
        "title": "Multiplication Of Two Digit Number With Three Digit Answer",
        "Grade": 2,
        "generateNumbers": () {
          int num1 = Random().nextInt(90) + 10;
          int num2 = Random().nextInt(90) + 10;

          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": num1 * num2,
            "sign": "X",
          };
        }
      },
      {
        "title": "Multiplication of Whole Tens",
        "Grade": 1,
        "generateNumbers": () {
          int num1 = (Random().nextInt(9) + 1) * 10; // Whole tens
          int num2 = (Random().nextInt(9) + 1) * 10;

          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": num1 * num2,
            "sign": "X",
          };
        }
      },
      {
        "title":
        "Multiply a 2-Digit Number by Another 2-Digit Number Without Carry",
        "Grade": 2,
        "generateNumbers": () {
          int num1 = Random().nextInt(90) + 10; // Two-digit numbers
          int num2 = Random().nextInt(90) + 10;

          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": num1 * num2,
            "sign": "X",
          };
        }
      },
      {
        "title": "Multiply a 3-Digit Number by a 1-Digit Number",
        "Grade": 3,
        "generateNumbers": () {
          int num1 = Random().nextInt(900) + 100; // Three-digit number
          int num2 = Random().nextInt(9) + 1; // Single-digit number

          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": num1 * num2,
            "sign": "X",
          };
        }
      },
      {
        "title": "Multiplication of Whole Hundreds",
        "Grade": 2,
        "generateNumbers": () {
          int num1 = (Random().nextInt(9) + 1) * 100; // Whole hundreds
          int num2 = (Random().nextInt(9) + 1) * 100;

          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": num1 * num2,
            "sign": "X",
          };
        }
      },
      {
        "title": "Multiply a 3-Digit Number by a 2-Digit Number",
        "Grade": 3,
        "generateNumbers": () {
          int num1 = Random().nextInt(900) + 100; // Three-digit number
          int num2 = Random().nextInt(90) + 10; // Two-digit number

          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": num1 * num2,
            "sign": "X",
          };
        }
      },
      {
        "title": "Multiply a 3-Digit Number by Another 3-Digit Number",
        "Grade": 3,
        "generateNumbers": () {
          int num1 = Random().nextInt(900) + 100; // Three-digit number
          int num2 = Random().nextInt(900) + 100; // Three-digit number

          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": num1 * num2,
            "sign": "X",
          };
        }
      },
      {
        "title": "Multiplication of Whole Thousands",
        "Grade": 3,
        "generateNumbers": () {
          int num1 = (Random().nextInt(9) + 1) * 1000; // Whole thousands
          int num2 = (Random().nextInt(9) + 1) * 1000; // Whole thousands

          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": num1 * num2,
            "sign": "X",
          };
        }
      },
      {
        "title": "Multiply a 2-Digit Number by Another 2-Digit Number With Carry",
        "Grade": 2,
        "generateNumbers": () {
          int num1 = Random().nextInt(90) + 10; // Two-digit number
          int num2 = Random().nextInt(90) + 10; // Two-digit number

          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": num1 * num2,
            "sign": "X",
          };
        }
      },
      {
        "title": "Multiply a 4-Digit Number by a 1-Digit Number",
        "Grade": 4,
        "generateNumbers": () {
          int num1 = Random().nextInt(9000) + 1000; // Four-digit number
          int num2 = Random().nextInt(9) + 1; // One-digit number

          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": num1 * num2,
            "sign": "X",
          };
        }
      },
      {
        "title": "Multiplication of Whole Ten Thousands",
        "Grade": 3,
        "generateNumbers": () {
          int num1 = (Random().nextInt(9) + 1) * 10000; // Whole ten thousands
          int num2 = (Random().nextInt(9) + 1) * 10000; // Whole ten thousands

          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": num1 * num2,
            "sign": "X",
          };
        }
      },
      {
        "title": "Multiply a 4-Digit Number by a 2-Digit Number",
        "Grade": 4,
        "generateNumbers": () {
          int num1 = Random().nextInt(9000) + 1000; // 4-digit number
          int num2 = Random().nextInt(90) + 10; // 2-digit number

          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": num1 * num2,
            "sign": "X",
          };
        }
      },
      {
        "title": "Multiply a 4-Digit Number by a 3-Digit Number",
        "Grade": 4,
        "generateNumbers": () {
          int num1 = Random().nextInt(9000) + 1000; // 4-digit number
          int num2 = Random().nextInt(900) + 100; // 3-digit number

          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": num1 * num2,
            "sign": "X",
          };
        }
      },
      {
        "title": "Multiply a 4-Digit Number by Another 4-Digit Number",
        "Grade": 4,
        "generateNumbers": () {
          int num1 = Random().nextInt(9000) + 1000; // 4-digit number
          int num2 = Random().nextInt(9000) + 1000; // 4-digit number

          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": num1 * num2,
            "sign": "X",
          };
        }
      },
      {
        "title": "Multiply a 5-Digit Number by Another 1-Digit Number",
        "Grade": 5,
        "generateNumbers": () {
          int num1 = Random().nextInt(90000) + 10000; // 5-digit number
          int num2 = Random().nextInt(9) + 1; // 1-digit number

          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": num1 * num2,
            "sign": "X",
          };
        }
      },
      {
        "title": "Multiply a 5-Digit Number by Another 2-Digit Number",
        "Grade": 5,
        "generateNumbers": () {
          int num1 = Random().nextInt(90000) + 10000; // 5-digit number
          int num2 = Random().nextInt(90) + 10; // 2-digit number

          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": num1 * num2,
            "sign": "X",
          };
        }
      },
      {
        "title": "Multiply a 5-Digit Number by Another 3-Digit Number",
        "Grade": 5,
        "generateNumbers": () {
          int num1 = Random().nextInt(90000) + 10000; // Five-digit number
          int num2 = Random().nextInt(900) + 100; // Three-digit number

          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": num1 * num2,
            "sign": "X",
          };
        }
      },
      {
        "title": "Multiply a 5-Digit Number by Another 4-Digit Number",
        "Grade": 5,
        "generateNumbers": () {
          int num1 = Random().nextInt(90000) + 10000; // Five-digit number
          int num2 = Random().nextInt(9000) + 1000; // Four-digit number

          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": num1 * num2,
            "sign": "X",
          };
        }
      },
      {
        "title": "Multiply a 5-Digit Number by Another 5-Digit Number",
        "Grade": 5,
        "generateNumbers": () {
          int num1 = Random().nextInt(90000) + 10000; // Five-digit number
          int num2 = Random().nextInt(90000) + 10000; // Five-digit number

          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": num1 * num2,
            "sign": "X",
          };
        }
      },
      {
        "title": "Multiplication Of Decimal Number",
        "Grade": 5,
        "generateNumbers": () {
          double num1 =
          double.parse((Random().nextDouble() * 10).toStringAsFixed(2));
          double num2 =
          double.parse((Random().nextDouble() * 10).toStringAsFixed(2));

          double result = num1 * num2;

          return {
            "number1": num1.toStringAsFixed(2),
            "number2": num2.toStringAsFixed(2),
            "number3": null,
            "number4": null,
            "result": result.toStringAsFixed(2),
            "sign": "X",
          };
        }
      },
    ].where((op) => op["Grade"] == grade).toList();
  }
  //#endregion

  //#region Division Operation
  static List<Map<String, dynamic>> getDivisionOperations(int grade) {
    return [
      {
        "title": "Divide a 1-Digit Number by Another 1-Digit Number",
        "Grade": 1,
        "generateNumbers": () {
          int num1 = Random().nextInt(9) + 1; // 1 to 9
          int num2 = Random().nextInt(9) + 1; // 1 to 9
          double result = num1 / num2;
          return {
            "number1": num1.toString(),
            "number2": num2.toString(),
            "number3": null,
            "number4": null,
            "result": result.toStringAsFixed(2),
            "sign": "/",
          };
        }
      },
      {
        "title": "Divide a 2-Digit Number by a 1-Digit Number",
        "Grade": 1,
        "generateNumbers": () {
          int num1 = Random().nextInt(90) + 10;
          int num2 = Random().nextInt(9) + 1;

          double result = num1 / num2;
          return {
            "number1": num1.toStringAsFixed(2),
            "number2": num2.toStringAsFixed(2),
            "number3": null,
            "number4": null,
            "result": result.toStringAsFixed(2),
            "sign": "/",
          };
        }
      },
      {
        "title": "Division of Whole Tens",
        "Grade": 1,
        "generateNumbers": () {
          int num1 = (Random().nextInt(9) + 1) * 10; // Multiples of 10
          int num2 = Random().nextInt(9) + 1; // 1 to 9
          double result = num1 / num2;
          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": result.toStringAsFixed(2),
            "sign": "/",
          };
        }
      },
      {
        "title": "Division By Two Digit Number",
        "Grade": 2,
        "generateNumbers": () {
          int num1 = Random().nextInt(900) + 100;
          int num2 = Random().nextInt(90) + 10;
          double result = num1 / num2;
          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": result.toStringAsFixed(2),
            "sign": "/",
          };
        }
      },
      {
        "title": "Divide a 2-Digit Number by Another 2-Digit Number",
        "Grade": 2,
        "generateNumbers": () {
          int num1 = Random().nextInt(90) + 10; // 10 to 99
          int num2 = Random().nextInt(90) + 10; // 10 to 99
          double result = num1 / num2;
          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": result.toStringAsFixed(2),
            "sign": "/",
          };
        }
      },
      {
        "title": "Divide a 3-Digit Number by a 1-Digit Number",
        "Grade": 2,
        "generateNumbers": () {
          int digit1 = Random().nextInt(900) + 100;
          int digit2 = Random().nextInt(9) + 1;
          double result = digit1 / digit2;
          return {
            "number1": digit1,
            "number2": digit2,
            "number3": null,
            "number4": null,
            "result": result,
            "sign": "/",
          };
        },
      },
      {
        "title": "Division of Whole Hundreds",
        "Grade": 2,
        "generateNumbers": () {
          int num1 = (Random().nextInt(9) + 1) * 100;
          int num2 = Random().nextInt(9) + 1;

          double result = num1 / num2;
          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": result.toStringAsFixed(2),
            "sign": "/",
          };
        }
      },
      {
        "title": "Divide a 3-Digit Number by a 2-Digit Number",
        "Grade": 3,
        "generateNumbers": () {
          int num1 = Random().nextInt(900) + 100;
          int num2 = Random().nextInt(90) + 10;

          double result = num1 / num2;
          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": result.toStringAsFixed(2),
            "sign": "/",
          };
        }
      },
      {
        "title": "Divide a 3-Digit Number by a 3-Digit Number",
        "Grade": 3,
        "generateNumbers": () {
          int num1 = Random().nextInt(900) + 100;
          int num2 = Random().nextInt(900) + 100;

          double result = num1 / num2;
          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": result.toStringAsFixed(2),
            "sign": "/",
          };
        }
      },
      {
        "title": "Divide a Number by a 2-Digit Number",
        "Grade": 3,
        "generateNumbers": () {
          int num1 = Random().nextInt(900) + 100;
          int num2 = Random().nextInt(90) + 10;

          double result = num1 / num2;
          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": result.toStringAsFixed(2),
            "sign": "/",
          };
        }
      },
      {
        "title": "Divide a Number by a 3-Digit Number",
        "Grade": 3,
        "generateNumbers": () {
          int num1 = Random().nextInt(900) + 100;
          int num2 = Random().nextInt(900) + 100;

          double result = num1 / num2;
          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": result.toStringAsFixed(2),
            "sign": "/",
          };
        }
      },
      {
        "title": "Division of Whole Thousands",
        "Grade": 4,
        "generateNumbers": () {
          int num1 = (Random().nextInt(9) + 1) * 1000;
          int num2 = Random().nextInt(9) + 1;

          double result = num1 / num2;
          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": result.toStringAsFixed(2),
            "sign": "/",
          };
        }
      },
      {
        "title": "Divide a 4-Digit Number by a 1-Digit Number",
        "Grade": 4,
        "generateNumbers": () {
          int num1 = Random().nextInt(9000) + 1000;
          int num2 = Random().nextInt(9) + 1;

          double result = num1 / num2;
          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": result.toStringAsFixed(2),
            "sign": "/",
          };
        }
      },
      {
        "title": "Divide a 4-Digit Number by a 2-Digit Number",
        "Grade": 4,
        "generateNumbers": () {
          int num1 = Random().nextInt(9000) + 1000;
          int num2 = Random().nextInt(90) + 10;

          double result = num1 / num2;
          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": result.toStringAsFixed(2),
            "sign": "/",
          };
        }
      },
      {
        "title": "Divide a 4-Digit Number by a 3-Digit Number",
        "Grade": 4,
        "generateNumbers": () {
          int num1 = Random().nextInt(9000) + 1000;
          int num2 = Random().nextInt(900) + 100;

          double result = num1 / num2;
          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": result.toStringAsFixed(2),
            "sign": "/",
          };
        }
      },
      {
        "title": "Divide a 4-Digit Number by Another 4-Digit Number",
        "Grade": 4,
        "generateNumbers": () {
          int num1 = Random().nextInt(9000) + 1000;
          int num2 = Random().nextInt(9000) + 1000;

          double result = num1 / num2;
          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": result.toStringAsFixed(2),
            "sign": "/",
          };
        }
      },
      {
        "title": "Divide a 5-Digit Number by a 1-Digit Number",
        "Grade": 5,
        "generateNumbers": () {
          int num1 = Random().nextInt(90000) + 10000;
          int num2 = Random().nextInt(9) + 1;

          double result = num1 / num2;
          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": result.toStringAsFixed(2),
            "sign": "/",
          };
        }
      },
      {
        "title": "Divide a 5-Digit Number by a 2-Digit Number",
        "Grade": 5,
        "generateNumbers": () {
          int num1 = Random().nextInt(90000) + 10000;
          int num2 = Random().nextInt(90) + 10;

          double result = num1 / num2;
          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": result.toStringAsFixed(2),
            "sign": "/",
          };
        }
      },
      {
        "title": "Divide a 5-Digit Number by a 3-Digit Number",
        "Grade": 5,
        "generateNumbers": () {
          int num1 = Random().nextInt(90000) + 10000;
          int num2 = Random().nextInt(900) + 100;

          double result = num1 / num2;
          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": result.toStringAsFixed(2),
            "sign": "/",
          };
        }
      },
      {
        "title": "Divide a 5-Digit Number by a 4-Digit Number",
        "Grade": 5,
        "generateNumbers": () {
          int num1 = Random().nextInt(90000) + 10000;
          int num2 = Random().nextInt(9000) + 1000;

          double result = num1 / num2;
          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": result.toStringAsFixed(2),
            "sign": "/",
          };
        }
      },
      {
        "title": "Divide a 5-Digit Number by a 5-Digit Number",
        "Grade": 5,
        "generateNumbers": () {
          int num1 = Random().nextInt(90000) + 10000;
          int num2 = Random().nextInt(90000) + 10000;

          double result = num1 / num2;
          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": result.toStringAsFixed(2),
            "sign": "/",
          };
        }
      },
      {
        "title": "Divide Two Numbers Up to 5-Digits Each",
        "Grade": 5,
        "generateNumbers": () {
          int num1 = Random().nextInt(90000) + 10000;
          int num2 = Random().nextInt(90000) + 10000;

          double result = num1 / num2;
          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": result.toStringAsFixed(2),
            "sign": "/",
          };
        }
      },
      {
        "title": "Divide Two Numbers Up to 6-Digits Each",
        "Grade": 5,
        "generateNumbers": () {
          int num1 = Random().nextInt(900000) + 100000;
          int num2 = Random().nextInt(900000) + 100000;

          double result = num1 / num2;
          return {
            "number1": num1,
            "number2": num2,
            "number3": null,
            "number4": null,
            "result": result.toStringAsFixed(2),
            "sign": "/",
          };
        }
      },
      {
        "title": "Division By Decimal Number",
        "Grade": 5,
        "generateNumbers": () {
          double num1 = (Random().nextDouble() * 100).toDouble();
          double num2 = (Random().nextDouble() * 10).toDouble() + 0.1;
          double result = num1 / num2;
          return {
            "number1": num1.toStringAsFixed(2),
            "number2": num2.toStringAsFixed(2),
            "number3": null,
            "number4": null,
            "result": result.toStringAsFixed(2),
            "sign": "/",
          };
        }
      },
    ].where((op) => op["Grade"] == grade).toList();
  }
  //#endregion
}