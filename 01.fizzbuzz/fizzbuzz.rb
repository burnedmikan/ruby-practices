#!/usr/bin/env ruby

# numberがdivisorで割り切れたときに、messageを応答するメソッド
def message_for_divisible(number:, divisor:, message:)
    
    if number % divisor == 0
        message
    else 
        ""
    end

end

(1..20).each do |n|
    output = ""
    output += message_for_divisible(number: n, divisor: 3, message: "Fizz")
    output += message_for_divisible(number: n, divisor: 5, message: "Buzz")

    if output == ""
        puts n.to_s
    else 
        puts output
    end
end
