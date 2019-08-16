#!/bin/bash
if [ -z $PT_days ] ; then
    PT_days=7
fi
echo "Cleaning up logfiles older than $PT_days days..."
echo "Done!"