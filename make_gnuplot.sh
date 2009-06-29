#!/bin/sh

for f in "$@"; do
    basename=`basename $f .xml|sed -e 's/_[0-9]_[a-z]*$//'`
    echo $basename
    ./ext-linkdepth.rb $f > $basename.txt
    ./ext-bookmark.rb $f > $basename.bookmark.txt
    ./ext-submit.rb $f > $basename.submit.txt
    if [ -s $basename.submit.txt ]; then 
	submitplot=", \"${basename}.submit.txt\" using 2:1 title \"submit\" w point pt 5"
    else
        submitplot=""
    fi
    ./ext-search.rb $f $basename > search
    echo "set term png size 800,800 font \"/usr/share/fonts/ja/TrueType/tlgothic.ttc\" 16" >> search
    echo "set xtics font \"/usr/share/fonts/ja/TrueType/tlgothic.ttc,16\"" >> search
    echo "set x2tics font \"/usr/share/fonts/ja/TrueType/tlgothic.ttc,16\"" >> search
    echo "set ytics font \"/usr/share/fonts/ja/TrueType/tlgothic.ttc,16\"" >> search
    echo "set size square" >> search
    echo "set xrange [-6:19.5]" >> search
    echo "set yrange [0:1200] reverse" >> search
    : echo "set xrange [-6:13.5]" >> search       # for fi2009 (sub3 & sub24)
    : echo "set yrange [0:940] reverse" >> search # for fi2009 (sub3 & sub24)
    echo "set zeroaxis" >> search
    #echo "set xtics 0,1" >> search
    echo "set xtics ('SE' -1, 'SR' 0)" >> search
    echo "set xtics ('SE' -1, 'SR' 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19)" >> search
    echo "set x2tics ('SE' -1, 'SR' 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19)" >> search
    echo "set ytics 60" >> search
    echo "set pointsize 2.0" >> search
    echo "plot \
        \"${basename}.txt\" using 2:1 title \"$basename\" w fsteps lw 3, \
        \"${basename}.txt\" using 2:1 title \"$basename\" w points, \
	\"${basename}.search.txt\" using 2:1 title \"search\" w point pt 7, \
	\"${basename}.bookmark.txt\" using 2:1 title \"bookmark\" w point pt 9 \
	$submitplot
     " >> search
    # echo "set multiplot" >> search
    gnuplot search > $basename.png
done
