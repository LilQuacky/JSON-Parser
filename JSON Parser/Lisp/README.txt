Parsing JSON
README - jsonparse.lisp

GROUP COMPONENT:

885925 Yzeiri Flavio
887525 Falbo Andrea

GOAL OF THE PROJECT:

The goal of this project is to make a lisp library that builds data structures 
representing JSON objects, starting from their representation as strings.

BASIC PREDICATES:

1) JSONPARSE\1:
	Call (jsonparse JSONString) to return the parsed json string
2) JSONACCESS\3:
	Call (jsonaccess jsonobj &rest Result) to return the access of an array or an object
3) JSONREAD\1:
	Call (jsonread filename) to return the JSON and read from a json file
4) JSONDUMP\2:
	Call (jsondump JSON filename) to return the filename and write in a json file

