### Prolog JSON Parsing Library - README.md

This README file provides instructions and information about using the Prolog JSON Parsing Library.

**Files:**
- `jsonparse.pl`: Prolog source code file containing the implementation of the JSON parsing library.
- `README.md`: This file, providing instructions and information about the Prolog implementation.

**Usage:**
1. Load the `jsonparse.pl` file into your Prolog interpreter.
2. Use the `jsonparse/2` predicate to parse a JSON string and construct the corresponding JSON object representation. The predicate takes two arguments: the JSON string and the resulting JSON object.
3. Use the `jsonaccess/3` predicate to access specific fields or elements within a JSON object. The predicate takes three arguments: the JSON object, a list of fields representing the path to the desired element, and the resulting value.

**Example Usage:**
```prolog
?- jsonparse('{"nome" : "Arthur", "cognome" : "Dent"}', Object),
   jsonaccess(Object, ["nome"], Result).

Object = jsonobj([("nome", "Arthur"), ("cognome", "Dent")]),
Result = "Arthur"
```

For more examples and details on using the Prolog JSON Parsing Library, please refer to the source code comments and documentation within the `jsonparse.pl` file.