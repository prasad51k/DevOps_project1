#! /bin/bash
# this is a testing script for next installation
cd /var/lib/jenkins/workspace/newtest/
npm install next
npm run build 
npm run start
