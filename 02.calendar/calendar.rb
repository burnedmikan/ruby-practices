#!/usr/bin/env ruby

require 'optparse'
require 'date'

opt = OptionParser.new
params = {}

=begin
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
=end

class Calendar

    # 日本語の曜日表記はクラス変数としてもたせておく
    @@japanese_wday_of_week = ["日","月","火","水","木","金","土"] 

    def initialize(year: , month:)

        @year = year
        @month = month

        # 月初の曜日
        @first_wday_of_month = Date.new(year, month, 1).wday
        # 月末の日にち
        @end_day_of_month = Date.new(year, month, -1).day

        # 月初の日曜日
        @first_sunday_of_month = search_weekday(0)
        # 月初の土曜日
        @first_saturday_of_month = search_weekday(6)

    end

    # 指定された月初の曜日の日付を返すメソッド
    def search_weekday(targetday)
        search_day = Date.new(@year, @month, 1)
        7.times do 
            if search_day.wday == targetday
                return search_day.day
            end
            search_day = search_day.next
        end
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

        # 月初までのスペース埋めの数の計算
        first_count_of_space = case @first_wday_of_month
        when 0,1
            2 * @first_wday_of_month
        else
            2 + (@first_wday_of_month - 1) * 3
        end

        # 描画
        print("\s" * first_count_of_space)
    end

    # 週初(日曜日)かどうかの判定。
    def first_weekday?(day)
        (day - @first_sunday_of_month) % 7 == 0 
    end

    # 週末(土曜日)かどうかの判定。
    def weekend_day?(day)
        (day - @first_saturday_of_month) % 7 == 0
    end

    # カレンダーの本体部分描画
    def draw_body()
        (1..@end_day_of_month).each do |day|
            # 日付の前に必要となるスペースの数の管理用の変数
            count_of_space = 0

            # 週初(日曜日)かどうかの判定。日曜日以外であればスペースを追加
            count_of_space += 1 unless first_weekday?(day)  

            # 日付が1桁であれば、スペースを追加
            count_of_space += 1 if day < 10

            # 週末(土曜日)かどうかの判定。土曜日かつ最終日でなければ改行出力。それ以外であれば改行なしの出力
            if weekend_day?(day) && day != @end_day_of_month
                puts("\s" * count_of_space + day.to_s)
            else
                print("\s" * count_of_space + day.to_s)
            end
        end
        #描画が終わったら最後に改行をいれておく
        puts "" 
    end


    def draw_calendar()
        draw_header
        draw_pre_body
        draw_body
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

# カレンダーオブジェクトの用意と描画
calendar = Calendar.new(year: params[:y], month: params[:m])
calendar.draw_calendar
