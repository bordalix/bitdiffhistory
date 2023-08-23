#!/usr/bin/env ruby
#
# Scrapes https://btc.com/stats/diff

require 'json'
require 'nokogiri'
require 'open-uri'

class String
  def add_middle_space
    self[0..9] + ' ' + self[10..-1]
  end
  def cleaned
    self.gsub(/\s/,'').gsub('%','').gsub(',','.')
  end
  def extract_diff
    self.split('-')[0].gsub('.','')
  end
  def to_units
    case self
    when /M/
      (self.to_f * 10**6).to_i
    when /G/
      (self.to_f * 10**9).to_i
    when /T/
      (self.to_f * 10**12).to_i
    when /P/
      (self.to_f * 10**15).to_i
    when /E/
      (self.to_f * 10**18).to_i
    end
  end
  def remove_dots
    self.sub('.','')
  end
  def remove_plus_signs
    self.sub('+','')
  end
end

adjustments = []

# get html page
page = Nokogiri::HTML(URI.open('https://btc.com/stats/diff'))

# find rows in table
rows = page.at_css('table.table').css('tr')

# for each row, clean
rows.each do |row|
  columns = row.css('td').map(&:text).map(&:cleaned)
  if columns.size > 0
    adjustments.push({
      block_height: columns[0].remove_dots,
      block_timestamp: columns[1].add_middle_space,
      difficulty_absolute: columns[2].extract_diff.to_i,
      difficulty_change_percentage: columns[3].remove_plus_signs,
      bits: columns[4],
      time_between_blocks: columns[5],
      hashrate_pretty: columns[6],
      hashrate_units: columns[6].to_units,
      difficulty_abs_change: 0,
      hashrate_u_abs_change: 0,
    })
  end
end

exit "Something went wrong" if adjustments.size === 0

puts adjustments[0].keys.join(',')

adjustments.each_with_index do |adjustment, index|
  if index < adjustments.size - 1
    previous_adjustment = adjustments[index + 1] # array in inverse cronological order
    adjustment[:difficulty_abs_change] = adjustment[:difficulty_absolute] - previous_adjustment[:difficulty_absolute]
    adjustment[:hashrate_u_abs_change] = adjustment[:hashrate_units] - previous_adjustment[:hashrate_units]
  end
  puts adjustment.values.join(',')
end