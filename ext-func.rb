#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
# $Id$

require "rexml/document"

def load_file( file )
   begin
      file = open(file) unless file.respond_to? :read
      doc = REXML::Document.new( file )
      next unless doc or doc.root.name == "行動プロトコル"
      start, finish = nil
      tables = doc.elements.to_a("/行動プロトコル/行動プロトコルテーブル")
      tables = tables.sort_by do |table|
         table.elements["./Position"].text.to_f
      end
   #rescue REXML::ParseException
   end
   tables
end

if $0 == __FILE__
   ARGV.each do |f|
      user, pat, order, topic, = f.split( /[_\.]/ )
      #puts f
      data = load_file f
      puts data.first
   end
end
