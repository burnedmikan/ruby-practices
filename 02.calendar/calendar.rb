#!/usr/bin/env ruby

require 'optparse'
require 'date'

opt = OptionParser.new
params = {}

def draw_calendar(year: , month:)

    japanese_wday_of_week = ["日","月","火","水","木","金","土"]

    first_wday_of_month = Date.new(year, month, 1).wday
    end_day_of_month = Date.new(year, month, -1).day

    # カレンダーのヘッダー部分
    # 月数が二桁かどうかで、半角スペースの数を変える
    if month < 10 
        puts "\s" * 6 +  "#{month}月 #{year}"
    else 
        puts "\s" * 5 +  "#{month}月 #{year}"
    end

    # 曜日の日本語名を表示する
    puts japanese_wday_of_week.join(" ")

    # 描画前の準備
    # 月初までのスペース埋めの数の計算
    first_count_of_space = case first_wday_of_month
    when 0,1
        2 * first_wday_of_month
    else
        2 + (first_wday_of_month - 1) * 3
    end

    print("\s" * first_count_of_space)

    # 描画本体
    (1..end_day_of_month).each do |day|
        # 日付の前に必要となるスペースの数の管理用の変数
        count_of_space = 0

        # 週初(日曜日)かどうかの判定。日曜日以外であればスペースを追加
        if (day - (8- first_wday_of_month)) % 7 == 0
            count_of_space = 0
        else
            count_of_space += 1
        end 

        # 日付が1桁であれば、スペースを追加
        if day < 10
            count_of_space += 1
        end

        # 週末(土曜日)かどうかの判定。土曜日であれば改行出力。土曜日以外であれば改行なしの出力
        if (day - (7- first_wday_of_month)) % 7 == 0
            puts("\s" * count_of_space + day.to_s)
        else
            print("\s" * count_of_space + day.to_s)
        end 

    end
end

# オプションのブロック登録
opt.on('-y year') {|v|  v }
opt.on('-m month') {|v| v }

# オプションをparamsにパース
opt.parse!(ARGV, into: params)

# 月の入力チェックおよび変換と代入
if params.has_key?(:m)
    params[:m] = params[:m].to_i
    if params[:m].to_i < 1 || params[:m].to_i > 12
        puts "#{params[:m]} is neither a month number (1..12)"
        return
    end
else 
    params[:m] = Date.today.month
end 

# 年の入力チェックおよび変換と代入
if params.has_key?(:y)
    params[:y] = params[:y].to_i
else 
    params[:y] = Date.today.year
end 

# カレンダー描画
draw_calendar(year: params[:y], month: params[:m])
