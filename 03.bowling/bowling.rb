#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = []

scores.each do |s|
  if s == 'X'
    shots << 10
    shots << 0 if shots.size < 18
  else
    shots << s.to_i
  end
end

first_9_frames_shots = shots[0...18]
last_frame_shots = shots[18..]

frames = first_9_frames_shots.each_slice(2).to_a
frames << last_frame_shots

points = 0.upto(9).sum do |idx|
  frame = frames[idx]
  frame_number = idx + 1

  next frame.sum if frame_number == 10

  next_frame = frames[idx + 1]

  if frame[0] == 10 # strike
    if frame_number < 9 && next_frame[0] == 10
      10 + 10 + frames[idx + 2][0]
    else
      10 + next_frame[0..1].sum
    end
  elsif frame.sum == 10 # spare
    10 + next_frame[0]
  else
    frame.sum
  end
end

puts points
