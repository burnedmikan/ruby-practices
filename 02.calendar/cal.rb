#!/usr/bin/env ruby

require 'optparse'
require 'date'

class Calendar
  def initialize(year, month)
    @start_date = Date.new(year, month, 1)
    @end_date = Date.new(year, month, -1)
  end

  def draw
    draw_header
    draw_body
  end

  private

  def draw_header
    puts @start_date.strftime('%B %Y').center(20)
    puts "Su Mo Tu We Th Fr Sa"
  end

  def draw_body
    days = Array.new(@start_date.wday, "  ")

    @start_date.step(@end_date) do |target_date|
      days.push(target_date.day.to_s.rjust(2))

      if target_date.saturday? || target_date == @end_date
        puts days.join(" ")
        days.clear
      end
    end
  end
end

opt = OptionParser.new
params = {}

opt.on('-y year') {|v| v }
opt.on('-m month') {|v| v }

opt.parse!(ARGV, into: params)

year = params[:y] ? params[:y].to_i : Date.today.year
month = params[:m] ? params[:m].to_i : Date.today.month

calendar = Calendar.new(year, month)
calendar.draw
