#!/bin/sh
# A shell script to invoke some sample curl commands on a Linux machine 
# against a running container image of the app-specific Gilhari microservice 
# gilhari_relationships_example:1.0
# 
# The responses are recorded in a log file (curl.log).
#
# Note that these curl commands use a mapped port number of 80
# even though the port number exposed by the app-specific 
# microservice may be different (e.g., 8081) inside the container shell.
# If you want to use these curl commands from inside the
# container shell on the host machine, you may have to use
# the exposed port number (e.g., 8081) instead.

echo -e "** BEGIN OUTPUT **" > curl.log

echo "** Delete all A objects (and their referenced B and C objects) to start fresh" >> curl.log
curl -X DELETE "http://localhost:80/gilhari/v1/A" >> curl.log
echo "" >> curl.log

echo "** Insert one A object with one referenced B object and a referenced array of two C objects" >> curl.log
curl -X POST "http://localhost:80/gilhari/v1/A"  -H 'Content-Type: application/json' -d '{"entity":{"aId":1,"aString":"aString_1","aBoolean":true,"aFloat":1.1,"aDate":347184000001,"aB":{"bId":100,"aId":1,"bInt":100,"bString":"bString_1"},"aCs":[{"cId":1000,"aId":1,"cInt":100,"cString":"cString_1"},{"cId":2000,"aId":1,"cInt":200,"cString":"cString_2"}]}}' >> curl.log
echo -e "" >> curl.log

echo "** Query all A objects (and their referenced B and C objects)" >> curl.log
curl -X GET "http://localhost:80/gilhari/v1/A"  -H "Content-Type: application/json" >> curl.log
echo "" >> curl.log

echo "** Shallow Query all A objects (without their referenced B and C objects)" >> curl.log
curl -X GET "http://localhost:80/gilhari/v1/A?deep=false"  -H "Content-Type: application/json" >> curl.log
echo "" >> curl.log

echo "** Query all C objects" >> curl.log
curl -X GET "http://localhost:80/gilhari/v1/C"  -H "Content-Type: application/json" >> curl.log
echo "" >> curl.log

echo "** Insert one A object with one referenced B object but no C objects" >> curl.log
curl -X POST "http://localhost:80/gilhari/v1/A"  -H "Content-Type: application/json"  -d '{"entity":{"aId":2,"aString":"aString_2","aBoolean":false,"aFloat":2.2,"aDate":347184000002,"aB":{"bId":200,"aId":2,"bInt":200,"bString":"bString_2"}}}' >> curl.log
echo "" >> curl.log

echo "** Insert one A object without any referenced B or C objects" >> curl.log
curl -X POST "http://localhost:80/gilhari/v1/A"  -H "Content-Type: application/json"  -d '{"entity":{"aId":3,"aString":"aString_3","aBoolean":false,"aFloat":3.3,"aDate":347184000003}}' >> curl.log
echo "" >> curl.log

echo "** Query all A objects (and their referenced B and C objects) objects" >> curl.log
curl -X GET "http://localhost:80/gilhari/v1/A"  -H "Content-Type: application/json"
echo "" >> curl.log

echo "** Shallow Query all A objects (without their referenced B and C objects)" >> curl.log
curl -X GET "http://localhost:80/gilhari/v1/A?deep=false"  -H "Content-Type: application/json" >> curl.log
echo "" >> curl.log

echo "** Query all A objects (and their referenced B and C objects) objects where aId>1" >> curl.log
curl -X GET "http://localhost:80/gilhari/v1/A?filter=aId>1"  -H "Content-Type: application/json" >> curl.log
echo "" >> curl.log

echo "** Query all A objects (and their referenced B and C objects) objects where the related B object's bInt > 100 (using a path-expression)" >> curl.log
curl -X GET "http://localhost:80/gilhari/v1/A?filter=jdxObject.aB.bInt>100"  -H "Content-Type: application/json" >> curl.log
echo "" >> curl.log

echo "** Query the count of A objects" >> curl.log
curl -X GET "http://localhost:80/gilhari/v1/A/getAggregate?attribute=aId&aggregateType=COUNT"  -H "Content-Type: application/json" >> curl.log
echo "" >> curl.log

echo "** Query all B objects" >> curl.log
curl -X GET "http://localhost:80/gilhari/v1/B"  -H "Content-Type: application/json" >> curl.log
echo "" >> curl.log

echo ** Delete all B objects >> curl.log
curl -X DELETE "http://localhost:80/gilhari/v1/B" >> curl.log
echo "" >> curl.log

echo "** Query the count of B objects" >> curl.log
curl -X GET "http://localhost:80/gilhari/v1/B/getAggregate?attribute=bId&aggregateType=COUNT"  -H "Content-Type: application/json" >> curl.log
echo "" >> curl.log

echo "** Query all C objects" >> curl.log
curl -X GET "http://localhost:80/gilhari/v1/C"  -H "Content-Type: application/json" >> curl.log
echo "" >> curl.log

echo "** Delete all A objects (and their referenced B and C objects)"  >> curl.log
curl -X DELETE "http://localhost:80/gilhari/v1/A" >> curl.log
echo "" >> curl.log

echo "** Query all C objects" >> curl.log
curl -X GET "http://localhost:80/gilhari/v1/C"  -H "Content-Type: application/json" >> curl.log
echo "" >> curl.log

echo "** Query the count of all A objects" >> curl.log
curl -X GET "http://localhost:80/gilhari/v1/A/getAggregate?attribute=aId&aggregateType=COUNT"  -H "Content-Type: application/json" >> curl.log
echo "" >> curl.log

echo "** END OUTPUT **" >> curl.log
echo "" >> curl.log

cat curl.log
