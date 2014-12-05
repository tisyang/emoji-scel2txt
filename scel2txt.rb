#!/usr/bin/env ruby

OFFSET = 0x26c4
HEADER_LEN = 0x11

def parse_scel(filename)
    lines = []
    open(filename, "rb") do |f|
        f.seek(OFFSET)
        while true do
            header = f.read(HEADER_LEN)
            break if header == nil

            pinyin_len = f.read(2).unpack("s*")[0]
            pinyin = f.read(pinyin_len)
            pinyin.force_encoding("utf-16le").encode!("utf-8")

            emoji_len = f.read(2).unpack("s*")[0]
            emoji = f.read(emoji_len)
            emoji.force_encoding("utf-16le").encode!("utf-8")

            lines << "#{pinyin}\t#{emoji}"
        end
    end
    lines.uniq
end

if ARGV.count != 2 then
    puts "Usage: ruby scel2txt.rb sample.scel output.txt"
    exit
end

lines = parse_scel(ARGV[0])
open(ARGV[1], "w") do |f|
    lines.each { |l| f.puts(l)}
end