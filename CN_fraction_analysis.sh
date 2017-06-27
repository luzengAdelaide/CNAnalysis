#!/bin/bash

# In order to find out the association between family length and their hits mapped to genome

# First step
# Calculate the total bp that overlapped with genome based on same consensus sequences,
##calculate the overlap for each hits, then add them up if they are belong to same family

# $i = species (e.g. anolis)

for i in *map
do
    awk '{len=$3-$2+1}{print $0 "\t" len}' $i | 
    awk '{a[$4]+=$13}END{for(i in a) print i,a[i]}' > total_overlap_$i
done

# Second step
# Calculate the length for each family
for i in *.lib
do
awk '/^>/ {if (seqs_id){print seqs_id, seqlen}; seqs_id=substr($1,2); seqlen=0}/^[^>]/{ seqlen += length($0)}END{print seqs_id, seqlen}' $i > length_$i
done

# Extract the same family name from previous two outputs and merge them together
awk 'FNR==NR{a[$1]=$2;next} ($1 in a) {print $1 "\t" $2 "\t" a[$1]}' length_$i total_overlap_$i > fraction_length_$i

# Calculate the proportion for each family that overlapped with genome
for i in fraction_length_*
do
awk '{prop=$2/$3}{print $0 "\t" prop}' $i > prop_$i
done