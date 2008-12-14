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
   puts %Q[set label "#{ e.elements["./行動_詳細2"].text.toeuc }" at #{y_axis},#{ e.elements["./Position"].text } font "/usr/share/fonts/ja/TrueType/tlgothic.ttc,8"]
   search_dat.puts [ e.elements["./Position"].text,
                     -0.5
                   ].join("\t")
end
