REM  A script to invoke some sample curl commands on a Windows machine
REM  against a running container image of the app-specific Gilhari microservice 
REM  gilhari_relationships_example:1.0.
REM
REM  This scripts populates some data but does not delete them.
REM
REM  The responses are recorded in a log file (curl.log).
REM
REM  Note that these curl commands use a default mapped port number of 80
REM  even though the port number exposed by the app-specific
REM  microservice may be different (e.g., 8081) inside the container shell.
REM
REM  You may optionally specify a non-default port number as the first 
REM  command line argument to this script. For example, to spceify a 
REM  port number of 8899, use the following command:
REM     curlCommands 8899

IF %1.==. GOTO DefaultPort
SET port=%1
GOTO Proceed

:DefaultPort
SET port=80
GOTO Proceed

:Proceed

echo ** BEGIN OUTPUT ** > curl.log
echo. >> curl.log
echo. >> curl.log

echo Using PORT number %port% >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Check the health of the Gilhari microservice >> curl.log
curl -X GET "http://localhost:%port%/gilhari/v1/health/check" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Delete all A objects (and their referenced B and C objects)  to start fresh >> curl.log
curl -X DELETE "http://localhost:%port%/gilhari/v1/A" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Insert one A object with one referenced B object and a referenced array of two C objects >> curl.log
curl -X POST "http://localhost:%port%/gilhari/v1/A"  -H "Content-Type: application/json"  -d "{""entity"":{""aId"":1,""aString"":""aString_1"",""aBoolean"":true,""aFloat"":1.1,""aDate"":347184000001,""aB"":{""bId"":100,""aId"":1,""bInt"":100,""bString"":""bString_1""},""aCs"":[{""cId"":1000,""aId"":1,""cInt"":100,""cString"":""cString_1""},{""cId"":2000,""aId"":1,""cInt"":200,""cString"":""cString_2""}]}}" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Query all A objects (and their referenced B and C objects) >> curl.log
curl -X GET "http://localhost:%port%/gilhari/v1/A"  -H "Content-Type: application/json" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Shallow Query all A objects (without their referenced B and C objects) >> curl.log
curl -X GET "http://localhost:%port%/gilhari/v1/A?deep=false"  -H "Content-Type: application/json" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Query all C objects >> curl.log
curl -X GET "http://localhost:%port%/gilhari/v1/C"  -H "Content-Type: application/json" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Insert one A object with one referenced B object but no C objects >> curl.log
curl -X POST "http://localhost:%port%/gilhari/v1/A"  -H "Content-Type: application/json"  -d "{""entity"":{""aId"":2,""aString"":""aString_2"",""aBoolean"":false,""aFloat"":2.2,""aDate"":347184000002,""aB"":{""bId"":200,""aId"":2,""bInt"":200,""bString"":""bString_2""}}}" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Insert one A object without any referenced B or C objects >> curl.log
curl -X POST "http://localhost:%port%/gilhari/v1/A"  -H "Content-Type: application/json"  -d "{""entity"":{""aId"":3,""aString"":""aString_3"",""aBoolean"":false,""aFloat"":3.3,""aDate"":347184000003}}" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Query all A objects (and their referenced B and C objects) objects >> curl.log
curl -X GET "http://localhost:%port%/gilhari/v1/A"  -H "Content-Type: application/json" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Shallow Query all A objects (without their referenced B and C objects) >> curl.log
curl -X GET "http://localhost:%port%/gilhari/v1/A?deep=false"  -H "Content-Type: application/json" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo "** Query all A objects (and their referenced B and C objects) objects where aId>1" >> curl.log
curl -X GET "http://localhost:%port%/gilhari/v1/A?filter=aId>1"  -H "Content-Type: application/json" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo "** Query all A objects (and their referenced B and C objects) objects where the related B object's bInt > 100 (using a path-expression)" >> curl.log
curl -X GET "http://localhost:%port%/gilhari/v1/A?filter=jdxObject.aB.bInt>100"  -H "Content-Type: application/json" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Query the count of A objects >> curl.log
curl -X GET "http://localhost:%port%/gilhari/v1/A/getAggregate?attribute=aId&aggregateType=COUNT"  -H "Content-Type: application/json" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Query all B objects >> curl.log
curl -X GET "http://localhost:%port%/gilhari/v1/B"  -H "Content-Type: application/json" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Query the count of all A objects >> curl.log
curl -X GET "http://localhost:%port%/gilhari/v1/A/getAggregate?attribute=aId&aggregateType=COUNT"  -H "Content-Type: application/json" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Shallow query all A objects with only aId, and aString (using projections operation type with operationDetails parameter)>> curl.log
curl -G "http://localhost:%port%/gilhari/v1/A?deep=false" --data-urlencode "operationDetails=[{\"opType\": \"projections\", \"projectionsDetails\": [{\"type\": \"A\", \"attribs\": [ \"aId\", \"aString\" ]}]}]" -H "Content-Type: application/json" >> curl.log
echo. >> curl.log
echo. >> curl.log


echo ** Shallow query all A objects but follow aB attribute of the A class (using follow operation type with operationDetails parameter) >> curl.log
curl -G "http://localhost:%port%/gilhari/v1/A?deep=false" --data-urlencode "operationDetails=[{\"opType\": \"follow\", \"references\": [\"A\", \"aB\"]}]" -H "Content-Type: application/json" >> curl.log
echo. >> curl.log
echo. >> curl.log


echo ** Shallow query all A objects but follow aB attribute of the A class (using follow operation type with operationDetails parameter) >> curl.log
curl -G "http://localhost:%port%/gilhari/v1/A" --data-urlencode "deep=false" --data-urlencode "operationDetails=[{\"opType\": \"follow\", \"references\": [\"A\", \"aB\"]}]" -H "Content-Type: application/json" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Shallow query all A objects with only aId and aString attributes (using projections operation type with operationDetails parameter) but also follow aB attribute of the A class (using follow operation type with operationDetails parameter) >> curl.log
curl -G "http://localhost:%port%/gilhari/v1/A" --data-urlencode "deep=false" --data-urlencode "operationDetails=[{\"opType\": \"projections\", \"projectionsDetails\": [{\"type\": \"A\", \"attribs\": [\"aId\", \"aString\"]}]}, {\"opType\": \"follow\", \"references\": [\"A\", \"aB\"]}]" -H "Content-Type: application/json"  >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Shallow query only one (maxObjects=1)  A objects with only aId and aString attributes (using projections operation type with operationDetails parameter) but also follow aB attribute of the A class (using follow operation type with operationDetails parameter) >> curl.log
curl -G "http://localhost:%port%/gilhari/v1/A" --data-urlencode "maxObjects=1" --data-urlencode "deep=false" --data-urlencode "operationDetails=[{\"opType\": \"follow\", \"references\": [\"A\", \"aB\"]}, {\"opType\": \"projections\", \"projectionsDetails\": [{\"type\": \"A\", \"attribs\": [ \"aId\", \"aString\" ]}]}]" -H "Content-Type: application/json" >> curl.log
echo. >> curl.log
echo. >> curl.log


type curl.log

