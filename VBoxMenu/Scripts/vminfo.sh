#!/bin/sh

#  vminfo.sh
#  VBoxMenu
#
#  Created by Francesc Vila on 07/08/2012.
#  Copyright (c) 2012 __MyCompanyName__. All rights reserved.

VBoxManage showvminfo "$1" --machinereadable | grep ostype | cut -d\" -f2 | tr '[A-Z]' '[a-z]' | sed 's/windows/win/g' | tr -d '\n'
