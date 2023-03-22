Parsing JSON
README - jsonparse.pl

GROUP COMPONENT:

885925 Yzeiri Flavio
887525 Falbo Andrea

GOAL OF THE PROJECT:

The goal of this project is to make a prolog library that builds data structures 
representing JSON objects, starting from their representation as strings.

BASIC PREDICATES:

1) JSONPARSE\2:
	 Call jsonparse(JSONString, Object) to parse a json string.
2) JSONACCESS\3:
	 Call jsonaccess(Jsonobj, Fields, Result) to access an array or an object
3) JSONREAD\2:
	Call jsonread(FileName, JSON) to read from a json file
4) JSONDUMP\2:
	Call jsondump(JSON, FileName) to write in a json file
