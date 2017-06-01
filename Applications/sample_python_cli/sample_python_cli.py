#!/usr/bin/env python
# -*- coding: utf-8 -*-

###############################################################################
#  Copyright Kitware Inc.
#
#  Licensed under the Apache License, Version 2.0 ( the "License" );
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
###############################################################################

import logging
logging.basicConfig(level=logging.CRITICAL)

from ctk_cli import CLIArgumentParser

def printVectorParameter(vec, name):

    print name, " = ",

    for i in range(len(vec)):
        if i > 0:
            print ", ",
        else:
            print vec[i],

    print


def main(args):

    # scalar parameters
    print "Integer Parameter = ", args.integerVariable
    print "Double Parameter = ", args.doubleVariable

    # vector parameters
    printVectorParameter("Float Vector Parameter", args.floatVector)
    printVectorParameter("String Vector Parameter", args.stringVector)

    # enumeration parameters
    print "String Enumeration Parameter = ", args.stringChoice

    # boolean parameters
    print "Boolean 1 = ", args.boolean1
    print "Boolean 2 = ", args.boolean2
    print "Boolean 3 = ", args.boolean3

    # file, directory, and image parameters
    print "Input file = ", args.file1
    printVectorParameter("Input Files", args.files)

    print "Input Directory = ", args.directory1

    print "Input Image = ", args.image1
    print "Output Image = ", args.image2

    # Indexed parameters
    print "First index argument = ", args.arg0
    print "Second index argument = ", args.arg1

    # Write out the return parameters in "name = value" form
    if len(args.returnParameterFile) > 0 :

        with open(args.returnParameterFile, 'w') as rparamfile:

            rparamfile.write("anintegerreturn =  10\n")
            rparamfile.write("abooleanreturn = true\n")
            rparamfile.write("afloatreturn = 34.2\n")
            rparamfile.write("adoublereturn = 102.7\n")
            rparamfile.write("astringreturn = Good-bye\n")
            rparamfile.write("anintegervectorreturn = 4,5,6,7\n")
            rparamfile.write("astringchoicereturn = Ron\n")


if __name__ == "__main__":
    main(CLIArgumentParser().parse_args())
