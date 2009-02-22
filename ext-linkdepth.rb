#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
# $Id$

$KCODE = "utf-8"

require "../ext-func.rb"

table = load_file( ARGV[0] )
table.each_with_index do |e, i|
   position = e.elements["./Position"].text
   target = e.elements["./対象"]
   action = e.elements["./行動"]
   utterance = e.elements["./発話"]
   next if target.nil?
   next if action and action.text and action.text.size > 0
   next if utterance and utterance.text and utterance.text.size > 0

   target = target.text
   next if target.nil?
   next if target == "一覧ﾍﾟｰｼﾞ_視線"

   link_depth = e.elements["./対象_詳細6"]
   if link_depth.nil?
      if target == "一覧ﾍﾟｰｼﾞ"
         link_depth = 0
      elsif i == 0
         link_depth = -1
      else
         prev_action = table[i - 1].elements["./行動"]
         prev_action_note = table[i - 1].elements["./行動_詳細2"]
         prev2_link_depth = table[i - 1].elements["./対象_詳細6"]
         last_target = table[0...i].reverse.find{|tmp| tmp.elements["./対象_詳細6"] and tmp.elements["./対象_詳細6"].text }
         last_target_link_depth = last_target.elements["./対象_詳細6"]
         STDERR.puts e.elements["./Position"].text
         if prev_action.text == "link"
            link_depth = prev2_link_depth.text.to_i + 1
         elsif prev_action.text == "jump" and e.elements["./対象_詳細4"].text =~ %r[http://www.(yahoo|google).co.jp/]
            link_depth = -1
         elsif prev_action.text == "jump" and prev_action_note.text == /ブックマーク|bookmark/
            link_depth = prev2_link_depth.text.to_i + 1
         elsif prev_action.text == "return" and last_target and last_target_link_depth
            link_depth = last_target_link_depth.text.to_i - 1
            elsif prev_action.text == "submit" and last_target and last_target_link_depth
            link_depth = last_target_link_depth.text.to_i + 1
         else
            STDERR.puts e
            raise
         end
      end
   else
      link_depth = link_depth.text
      if link_depth.nil? or link_depth.empty?
         if target == "一覧ﾍﾟｰｼﾞ"
            link_depth = 0
         elsif target == "特定のﾍﾟｰｼﾞ"
            link_depth = -1
         else
            next
         end
      else
         link_depth.sub!(/\s*\(.*\)\s*$/, "")
      end
   end
   puts [ e.elements["./Position"].text.to_f,
          link_depth
        ].join("\t")
end
