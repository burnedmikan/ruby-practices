#!/usr/bin/env ruby

require 'optparse'
require 'date'

class Calendar
  def initialize(year: , month:)
    @start_date = Date.new(year, month, 1)
    @end_date = Date.new(year, month, -1)
  end

  private

  # カレンダーのヘッダー部分描画
  def draw_header()
    puts "#{@start_date.strftime('%B')} #{@start_date.strftime('%Y')}".center(20)
    puts ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"] .join(" ")
  end

  # カレンダーの本体部分描画
  def draw_body()
    day_array = []

    # 月初曜日までのスペース埋め
    @start_date.wday.times { day_array.push("  ") }

    @start_date.step(@end_date) do |target_date|
      day_array.push(target_date.day.to_s.rjust(2))

      if target_date.saturday? || target_date == @end_date
        puts(day_array.join(" "))
        day_array.clear
      end
    end
  end

  public
  # カレンダー描画するメソッド
  def draw_calendar()
    draw_header
    draw_body
  end
end

opt = OptionParser.new
params = {}

# オプションのブロック登録
opt.on('-y year') {|v|  v }
opt.on('-m month') {|v| v }

# オプションをparamsにパース
opt.parse!(ARGV, into: params)

# monthの入力チェックおよび変換と省略時の代入
if params.has_key?(:m)
  params[:m] = params[:m].to_i
else 
  params[:m] = Date.today.month
end 

# yearの入力チェックおよび変換と省略時の代入
if params.has_key?(:y)
  params[:y] = params[:y].to_i
else 
  params[:y] = Date.today.year
end 

# カレンダーインスタンスの用意と描画
calendar = Calendar.new(year: params[:y], month: params[:m])
calendar.draw_calendar
