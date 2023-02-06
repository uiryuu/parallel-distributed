#!/bin/bash

extract_time() {
  sed 's@<[^<]*>@@g' | grep took | sed 's@took \([0-9]*\) nsec@\1@g' | awk -F'[:.]' '{printf "%-15d\t%s::%s\n", $6, $2, $4}' | sort -nk1
}

g() {
  awk -F$'\t' '{s[$2] += $1; n[$2] += 1; }END{
    printf "%s\t%s\t%s\t%s\n", "N", "TOT", "AVG", "FUNC";
    for(i in s){
      printf "%d\t%d\t%d\t%s\n", n[i], s[i]/1000, s[i] / n[i] / 1000, i;
    }
  }' "$1" | sort -nk3
}

g2() {
  awk -F$'\t' '
  ARGIND==1{s1[$2] += $1; n1[$2] += 1}
  ARGIND==2{s2[$2] += $1; n2[$2] += 1}
  END{
    printf "%10s\t%10s\t%10s\t%s\n", "AVG", "AVGBASE", "ACCEL", "FUNC";
    for(i in s1){
      avg1 = s1[i] / n1[i] / 1000.
      avg2 = s2[i] / n2[i] / 1000.
      printf "%10d\t%10d\t%10.2f x\t%s\n", avg1, avg2, avg2 / avg1, i;
    }
  }' "$1" "$2" | sort -nk3
}

if [ $# -eq 2 ]; then
  g2 <(cat "$1" | extract_time) <(cat "$2" | extract_time)
elif [ $# -eq 1 ]; then
  g <(cat "$1" | extract_time)
else
  echo "$0 mnist.log [baseline.log]"
fi
