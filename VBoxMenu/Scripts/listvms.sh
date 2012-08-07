#!/bin/sh

#  listvms.sh
#  VBoxMenu
#
#  Created by Francesc Vila on 07/08/2012.
#  Copyright (c) 2012 __MyCompanyName__. All rights reserved.

VBoxManage list vms | cut -d\" -f2