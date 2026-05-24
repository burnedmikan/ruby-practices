#!/usr/bin/env ruby

require 'optparse'
require 'date'

class Calendar

    # 日本語の曜日表記はクラス変数としてもたせておく
    @@japanese_wday_of_week = ["日","月","火","水","木","金","土"] 

    def initialize(year: , month:)

        @year = year
        @month = month

        # 月初の日
        @start_date = Date.new(year, month, 1)
        #　月末の日
        @end_date = Date.new(year, month, -1)

    end

    # カレンダーのヘッダー部分描画
    def draw_header()
        
        # 月数が二桁かどうかで、半角スペースの数を変えて描画
        if @month < 10 
            puts "\s" * 6 +  "#{@month}月 #{@year}"
        else 
            puts "\s" * 5 +  "#{@month}月 #{@year}"
        end

        # 曜日の日本語名を描画
        puts @@japanese_wday_of_week.join("\s")

    end

    # 本体描画前の開始位置までのスペース埋め描画
    def draw_pre_body()

        # 月初の曜日を取得
        start_wday_of_month = @start_date.wday

        # 月初までのスペース埋めの数の計算
        first_count_of_space = case start_wday_of_month
        when 0,1
            2 * start_wday_of_month
        else
            2 + (start_wday_of_month - 1) * 3
        end

        # 描画
        print("\s" * first_count_of_space)
    end

    # カレンダーの本体部分描画
    def draw_body()
        # 月初から月末まで1日ずつ処理していく
        @start_date.step(@end_date) do |target_date|
            # 日付の前に必要となるスペースの数の管理用の変数
            count_of_space = 0

            # 週初(日曜日)かどうかの判定。日曜日以外であればスペースを追加
            count_of_space += 1 unless target_date.wday == 0  

            # 日付が1桁であれば、スペースを追加
            count_of_space += 1 if target_date.day < 10

            # 週末(土曜日)かどうかの判定。土曜日かつ最終日でなければ改行出力。それ以外であれば改行なしの出力
            if target_date.wday == 6  && target_date != @end_date
                puts("\s" * count_of_space + target_date.day.to_s)
            else
                print("\s" * count_of_space + target_date.day.to_s)
            end
        end
        #月末まで処理が終わったら最後に改行をいれておく
        puts "" 
    end

    # カレンダー描画するメソッド
    def draw_calendar()
        draw_header
        draw_pre_body
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
    if params[:m].to_i < 1 || params[:m].to_i > 12
        puts "#{params[:m]} is neither a month number (1..12)"
        return
    end
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
