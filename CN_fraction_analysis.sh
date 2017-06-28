#!/bin/bash

# In order to find out the association between family length and their hits mapped to genome

# First step
# Calculate the total bp that overlapped with genome based on same consensus sequences,
##calculate the overlap for each hits, then add them up if they are belong to same family

# $i = species (e.g. anolis)
#!/bin/bash

# In order to find out the association between family length and their hits mapped to genome

# First step
# Calculate the total bp that overlapped with genome based on same consensus sequences,
##calculate the overlap for each hits, then add them up if they are belong to same family
arr=( 'anolis' 'bg'  'gal'  'hg'  'mdo'  'oana'  'tachy' )
for i in "${arr[@]}"
do
    awk '{len=$3-$2+1}{print $0 "\t" len}' "$i"_unknown.rmk.map | 
    awk '{a[$4]+=$13}END{for(i in a) print i,a[i]}' > total_overlap_"$i"
done

# Second step
# Calculate the length for each family
for i in "${arr[@]}"
do
awk '/^>/ {if (seqs_id){print seqs_id, seqlen}; seqs_id=substr($1,2); seqlen=0}/^[^>]/{ seqlen += length($0)}END{print seqs_id, seqlen}' $i.lib.fa > length_$i
done

# Third step
# Merge two files based on the same family (consensus sequences)
for i in "${arr[@]}"
do
    echo $i
    awk 'FNR==NR{a[$1]=$2;next} ($1 in a) {print $1 "\t" $2 "\t" a[$1]}' length_"$i" total_overlap_"$i" > fraction_length_"$i"
#    awk 'FNR==NR{a[$1]=$2;next} ($1 in a) {print $1 "\t" $2 "\t" a[$1]}' times_"$i" total_overlap_"$i" > fraction_times_"$i"
done

# Calculate the proportion for each family that overlapped with genome
for i in "${arr[@]}"
do
    awk '{prop=$2/$3}{print $0 "\t" prop}' fraction_length_"$i" > prop_"$i"
done


