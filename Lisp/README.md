### Common Lisp JSON Parsing Library - README.md

This README file provides instructions and information about using the Common Lisp JSON Parsing Library.

**Files:**
- `jsonparse.lisp`: Common Lisp source code file containing the implementation of the JSON parsing library.
- `README.md`: This file, providing instructions and information about the Common Lisp implementation.

**Usage:**
1. Load the `jsonparse.lisp` file into your Common Lisp environment.
2. Use the `jsonparse` function to parse a JSON string and construct the corresponding JSON object representation. The function takes one argument: the JSON string, and returns the JSON object.
3. Use the `jsonaccess` function to access specific fields or elements within a JSON object. The function takes multiple arguments: the JSON object followed by a series of fields representing the path to the desired element, and returns the resulting value.

**Example Usage:**
```lisp
CL-USER> (defparameter x (jsonparse "{\"nome\" : \"Arthur\", \"cognome\" : \"Dent\"}"))
x
;; Output: (JSONOBJ ("nome" "Arthur") ("cognome" "Dent"))

CL-USER> (jsonaccess x "cognome")
;; Output: "Dent"
```

For more examples and details on using the Common Lisp JSON Parsing Library, please refer to the source code comments and documentation within the `jsonparse.lisp` file.
