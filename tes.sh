#!/bin/bash

PREV_CPU_USE=0
PREV_CPU_IDLE=0
PREV_EPOCH_TIME=0

# Setting the delimiter
IFS=$'\n'
counter=0

while true; do
  # Getting the total CPU usage
  CPU_USAGE=$(head -n 1 /proc/stat)

  # Getting the Linux Epoch time in seconds
  EPOCH_TIME=$(date +%s)

  # Splitting the /proc/stat output
  IFS=" " read -ra USAGE_ARRAY <<< "$CPU_USAGE"

  # Calculating the used CPU time, CPU idle time and CPU total time
  CPU_USE=$((USAGE_ARRAY[1] + USAGE_ARRAY[2] + USAGE_ARRAY[3] + USAGE_ARRAY[6] + USAGE_ARRAY[7] + USAGE_ARRAY[8] ))
  CPU_IDLE=$((USAGE_ARRAY[4] + USAGE_ARRAY[5]))

  # Calculating the differences
  DIFF_USE=$((CPU_USE - PREV_CPU_USE))
  DIFF_IDLE=$((CPU_IDLE - PREV_CPU_IDLE))
  DIFF_TOTAL=$((DIFF_USE + DIFF_IDLE))
  DIFF_TIME=$((EPOCH_TIME - PREV_EPOCH_TIME))

  printf "\r%s%s Usage: %d (counter = %d)\n" "$(tput el)" "${USAGE_ARRAY[0]}" "$((DIFF_USE*100/(DIFF_TOTAL*DIFF_TIME)))" "$counter"
  printf "\r%s%s Idle: %d (counter = %d)" "$(tput el)" "${USAGE_ARRAY[0]}" "$((DIFF_IDLE*100/(DIFF_TOTAL*DIFF_TIME)))" "$counter"
  counter=$((counter + 1))

  tput cuu 1

  # Assigning the old values to the PREV_* values
  PREV_CPU_USE=$CPU_USE
  PREV_CPU_IDLE=$CPU_IDLE
  PREV_EPOCH_TIME=$EPOCH_TIME

  # Sleep for one second 
  sleep 1
done
I added an extra counter variable for debugging purposes. It's incremented after each print to inform user that the old lin
