#!/bin/sh

# This script prints monitor infos in following order:

# name of the primary monitor,
# total number of connected monitors,
# name of first connected monitor,
# name of second connected monitor,
# ... so on and so forth

echo $(xrandr | grep primary | awk '{print $1}')

CNT=0
MONITORS=$(xrandr | grep [^dis]connected | awk '{print $1}')
for MONITOR in $MONITORS
do
    CNT=$((CNT + 1))
done
echo $CNT

for MONITOR in $MONITORS
do
    echo $MONITOR
done
