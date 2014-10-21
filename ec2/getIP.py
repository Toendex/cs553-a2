#!/usr/bin/env python

import os
import sys
import random

from libcloud.compute.types import Provider
from libcloud.compute.providers import get_driver
from libcloud.compute.base import NodeSize, NodeImage
from libcloud.compute.types import NodeState
import libcloud.compute.types

NODESTATES = { NodeState.RUNNING    : "RUNNING",
               NodeState.REBOOTING  : "REBOOTING",
               NodeState.TERMINATED : "TERMINATED",
               NodeState.STOPPED    : "STOPPED",
               NodeState.PENDING    : "PENDING",
               NodeState.UNKNOWN    : "UNKNOWN" }


def list_resources(driver):
    resources = driver.list_nodes()
    if not resources:
        print "No active resources"
    else:
        for resource in resources:
            if resource.public_ips:
                if resource.name=="i-30ced03d":
                    continue
                if resource.name=="headnode":
                    print " ",resource.private_ips[0], #" ", resource.public_ips[0],
        for resource in resources:
            if resource.public_ips:
                if resource.name=="i-30ced03d":
                    continue
                if resource.name!="headnode":
                    print " ",resource.private_ips[0], #" ", resource.public_ips[0],

    return resources


def init():
    #configurator.pretty_configs(configs)
    driver     = get_driver(Provider.EC2_US_WEST_OREGON) # was EC2
    ec2_driver = driver("AKIAICQJUMM626IDQ5LA", "8k0B165YHIDH7biRuVatBQdfng2uLB19Yy8xgJN+")
    return ec2_driver

# Main driver section
driver = init()
list_resources(driver)

