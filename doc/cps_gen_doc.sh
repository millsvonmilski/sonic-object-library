#!/bin/bash
#
# Copyright (c) 2015 Dell Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# THIS CODE IS PROVIDED ON AN *AS IS* BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING WITHOUT
# LIMITATION ANY IMPLIED WARRANTIES OR CONDITIONS OF TITLE, FITNESS
# FOR A PARTICULAR PURPOSE, MERCHANTABLITY OR NON-INFRINGEMENT.
#
# See the Apache Version 2.0 License for specific language governing
# permissions and limitations under the License.
#

CPS_DOC_FILE="OS10.1.0B-cps-api-doc.zip"
CPS_DOC_DIR="workspace/cps-api-doc"
# File used to generate doxygen documentation for CPS C bindings
PSEUDO_CPS_FILE=workspace/cps.py
PYTHON_CPS_CBINDINGS=cps-api/src/python_extension/cps_api_python.cpp

if [ ! -d cps-api ]; then
   echo "Cannot find cps_api directory"
   exit 1
fi

rm -rf $CPS_DOC_DIR
mkdir -p $CPS_DOC_DIR


### Generate documentation for the C CPS API
doxygen cps-api/doc/doxygen_c.cfg

### Generate documentation for the Python CPS API
echo '"""@package cps' > $PSEUDO_CPS_FILE
echo '' >> $PSEUDO_CPS_FILE
echo 'Python API for the OS10 Control Plane Services' >>  $PSEUDO_CPS_FILE
echo '' >> $PSEUDO_CPS_FILE
echo '"""' >> $PSEUDO_CPS_FILE
### extract documentation from C Python bindings
cat $PYTHON_CPS_CBINDINGS | cps-api/doc/cps_py.awk | sed  's#\\n##g' >> $PSEUDO_CPS_FILE
doxygen cps-api/doc/doxygen_python.cfg


### Copy the Dell footer GIF file to the html directories
cp cps-api/doc/dell-footer-logo.gif $CPS_DOC_DIR/c-cpp-doc/html
cp cps-api/doc/dell-footer-logo.gif $CPS_DOC_DIR/python-doc/html
cp cps-api/doc/User_README.txt $CPS_DOC_DIR/README.txt

rm -f $PSEUDO_CPS_FILE

cd workspace

rm $CPS_DOC_FILE
zip -r $CPS_DOC_FILE cps-api-doc

echo ""
echo ""
echo "***"
echo "CPS API Documentation is in workspace/$CPS_DOC_FILE"
echo "***"

