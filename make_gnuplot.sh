#!/bin/sh

for f in "$@"; do
    basename=`basename $f .xml|sed -e 's/_[0-9]_[a-z]*$//'`
    echo $basename
    ./ext-linkdepth.rb $f > $basename.txt
    ./ext-bookmark.rb $f > $basename.bookmark.txt
    ./ext-search.rb $f $basename > search
    echo "set term png size 800,800" >> search
    echo "set size square" >> search
    echo "set xrange [-6:13.5]" >> search
    echo "set yrange [0:1200] reverse" >> search
    echo "set zeroaxis" >> search
    echo "set xtics 0,1" >> search
    echo "set ytics 60" >> search
    echo "plot \
        \"${basename}.txt\" using 2:1 title \"$basename\" w linespoint, \
	\"${basename}.search.txt\" using 2:1 title \"search\" w point pt 7, \
	\"${basename}.bookmark.txt\" using 2:1 title \"bookmark\" w point pt 8 \
     " >> search
    # echo "set multiplot" >> search
    gnuplot search > $basename.png
done
