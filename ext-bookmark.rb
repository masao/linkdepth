#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
# $Id$

require "../ext-func.rb"

t = load_file( ARGV[0] )
t.select{|e, i|
   e.elements["./行動"] and e.elements["./行動"].text == "bookmark"
}.each_with_index do |e, i|
   y_axis = 5.5
   puts [ e.elements["./Position"].text,
          y_axis
        ].join("\t")
end
