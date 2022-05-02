#!/usr/bin/env bash

# while loop
{
  cnt=10
  while [ $cnt -gt 0 ]; do
    echo "while loop $cnt"
    let cnt--
  done
}

# for loop
{
  for i in {1..10}; do
    echo "for loop $i"
  done
}

#until loop
{
  cnt=10
  until [ $cnt -lt 0 ]; do
    echo "util loop $cnt"
    let cnt--
  done
}
