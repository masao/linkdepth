#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
# $Id$

require "kconv"

require "../ext-func.rb"

file = ARGV[0]
basename = ARGV[1]
search_dat = open( basename + ".search.txt", "w" )
t = load_file( file )
t.select{|e|
   e.elements["./行動"] and e.elements["./行動"].text == "search"
}.each_with_index do |e, i|
   y_axis = -5.5
   # y_axis = -1.9 if i % 2 == 1
   query = e.elements["./行動_詳細2"].text.toeuc
   fontsize = 14
   fontsize = 12 if query.size > 16
   fontsize = 10 if query.size > 20
   fontsize = 8 if query.size > 24
   puts %Q[set label "#{ e.elements["./行動_詳細2"].text.toeuc }" at #{y_axis},#{ e.elements["./Position"].text } font "/usr/share/fonts/ja/TrueType/tlgothic.ttc,#{fontsize}"]
   search_dat.puts [ e.elements["./Position"].text,
                     -0.5
                   ].join("\t")
end
