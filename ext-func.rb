#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
# $Id$

require "rexml/document"

def load_file( file )
   begin
      fileio = file.respond_to?(:read) ? file : open(file)
      doc = REXML::Document.new( fileio )
      raise REXML::ParseException.new("document not found in #{file}") if doc.nil? or doc.root.nil?
      raise ArgumentError.new("document root is not '行動プロトコル'") if not doc.root.name == "行動プロトコル"
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
