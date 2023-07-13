# Project README

## Course Details
- Course: Programming Languages
- University: Bicocca University of Milan
- Academic Year: 2nd Year of Bachelor's Degree

## Project Overview
The goal of this project is to develop two libraries, one in Prolog and the other in Common Lisp, for parsing and constructing JSON objects from their string representation. JSON (JavaScript Object Notation) is a widely used standard for data interchange between applications.

The project involves implementing a JSON parser in Prolog and Common Lisp that can recursively analyze JSON strings and construct appropriate data structures to represent them. The parser should be able to handle JSON objects, arrays, strings, numbers, and values.

## Language
The project is implemented in two languages:
- Prolog
- Common Lisp

Prolog and Common Lisp belong to different programming paradigms, which influence their approach to problem-solving and programming style. Understanding these paradigms is essential for working with the project files.

### Prolog - Logic Programming
Prolog is a logic programming language based on formal logic. In Prolog, you define facts and rules as logical statements and then query the program to find solutions based on logical inference. Prolog programs consist of a set of predicates and relationships between them.

The key features of Prolog include:
- Logic-based programming: Programs are built by defining logical facts and rules and using logical inference to solve problems.
- Backtracking: Prolog explores multiple possible solutions by backtracking through the search space.
- Unification: Prolog uses a powerful unification mechanism to match and bind variables.

### Common Lisp - Functional Programming
Common Lisp, on the other hand, is a multi-paradigm language that supports various programming styles, including functional programming. In functional programming, programs are built by composing functions and expressing computations as the evaluation of mathematical-like expressions.

The key features of Common Lisp include:
- Functional programming: Functions are first-class citizens, allowing higher-order functions and functional composition.
- Immutable data: Functional programming promotes immutability, where data is treated as immutable, leading to more predictable and robust programs.
- Macros: Common Lisp provides powerful macro capabilities for metaprogramming and language extension.

## Topics Covered
The project covers the following topics:
- JSON parsing and construction
- Recursive parsing algorithms
- Handling JSON objects, arrays, strings, numbers, and values
- File input/output operations

## Project Files
The project consists of the following files:

### Prolog
- `jsonparse.pl`: Prolog source code file containing the implementation of the JSON parser and related predicates.
- `README.md`: Instructions and information about the Prolog implementation.

### Common Lisp
- `jsonparse.lisp`: Common Lisp source code file containing the implementation of the JSON parser and related functions.
- `README.md`: Instructions and information about the Common Lisp implementation.

## Example Usage
Here are some examples of how to use the JSON parsing libraries:

### Prolog
```prolog
?- jsonparse('{"nome" : "Arthur", "cognome" : "Dent"}', Object),
   jsonaccess(Object, ["nome"], Result).
   
Object = jsonobj([("nome", "Arthur"), ("cognome", "Dent")]),
Result = "Arthur"
```

### Common Lisp
```lisp
CL-USER> (defparameter x (jsonparse "{\"nome\" : \"Arthur\", \"cognome\" : \"Dent\"}"))
x
;; Output: (JSONOBJ ("nome" "Arthur") ("cognome" "Dent"))

CL-USER> (jsonaccess x "cognome")
;; Output: "Dent"
```

## File Input/Output
Both implementations provide functions for reading from and writing to files:

### Prolog
- `jsonread(FileName, JSON)`: Reads JSON data from the specified file and returns the parsed JSON object.
- `jsondump(JSON, FileName)`: Writes the JSON object to the specified file in JSON syntax.

### Common Lisp
- `(jsonread filename)`: Reads JSON data from the specified file and returns the parsed JSON object.
- `(jsondump JSON filename)`: Writes the JSON object to the specified file in JSON syntax.

Please refer to the respective README files in the Prolog and Common Lisp directories for more information on how to use these functions.


