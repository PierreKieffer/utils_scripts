#!/bin/bash 
echo """
  ___ ___ _____
 / __| _ )_   _|
 \__ \ _ \ | |
 |___/___/ |_| 
 
"""

projectName=$1

if [ -z "$projectName" ]; then
        echo "You have to pass project name as arg"
        echo "Usage ./sbt-init projectName"
        exit 1

fi

formattedName='"'$1'"'

mkdir -p src/{main,test}/{resources,scala}
mkdir project 

echo "Init build.properties file"
echo 'sbt.version = 1.3.7' > project/build.properties 

echo "Init assembly.sbt file" 
echo 'addSbtPlugin("com.eed3si9n" % "sbt-assembly" % "0.14.10")' > project/assembly.sbt

echo "Init build.sbt file"

version='"'0.1'"'
scalaVersion='"'2.11.8'"'

echo "name := $formattedName

version := $version 

scalaVersion := $scalaVersion 


assemblyMergeStrategy in assembly := {
  entry: String => {
    val strategy = (assemblyMergeStrategy in assembly).value(entry)
    if (strategy == MergeStrategy.deduplicate) MergeStrategy.first
    else strategy
  }
}" > build.sbt

