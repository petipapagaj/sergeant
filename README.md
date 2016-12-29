# What is Sergeant?
* Sergeant keep the schema synchronized in all database
* Return with status code which show whether or not the schema is identical to the schema in repository
* Sergeant is able to show the list of different objects
* Provide help in release process to make sure the schema has been released as it is in repository
* Generating schema version which is a snapshot of the actual state of the database
 
### Object types
Sergeant validate any differences on the following object types
* FN (function)
* FTI (full text index)
* IDX 	(index)
* IF	(inline function)
* P	(procedure)
* T	(table)
* TF	(table function)
* TVP	(table valued parameter)
* VW	(view)
 
# Usage

```
EXEC Sergeant.HashMatch [ [@version = ] { value }, [@showObjects =]  { 1 | 0 }]
```
 
# Example
```
DECLARE @ret INT
EXEC @ret = Sergeant.HashMatch @version = '10.2', @showObjects = 1
SELECT @ret
```

# Schema Version
Before every release new schema version have to be generated by calling the following procedure

``` 
EXEC Sergeant.CreateDataVersion @version = {@version}
```
 
Generated data version will be traveling with the release so it can be use as benchmark in comparison.
 
Data versions historically stored in table:

``` 
SELECT * FROM Sergeant.DataVersion AS dv
```
 
# Schema format
 

```
<objects>
  <object name="function1">
    <Type>FN </Type>
    <MD5>2ErNoE+4/sKD9wpDKKgGzw==</MD5>
  </object>
  <object name="fti1">
    <Type>FTI</Type>
    <MD5>60C/sicCPQMjK3fHcpoQaw==</MD5>
  </object>
  <object name="table.index1">
    <Type>IDX</Type>
    <MD5>yQy8K05nezuSSOFlbfzW2w==</MD5>
  </object>
  ...
</objects>
``` 