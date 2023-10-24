#!/usr/bin/env ruby
#
# Queries https://blockstream.info/api

require 'json'
require 'net/http'

class Api
  def get(url)
    Net::HTTP.get(URI(url))
  end
  def getBlockHash(height)
    self.get("https://blockstream.info/api/block-height/#{height}")
  end
  def getBlockInfo(hash)
    JSON.parse(self.get("https://blockstream.info/api/block/#{hash}"))
  end
  def getTipHeight
    self.get('https://blockstream.info/api/blocks/tip/height').to_i
  end
end

api = Api.new

currentBlockHeight = 0 

# find last block height to query
chainTipHeight = api.getTipHeight
maxBlockHeight = chainTipHeight - (chainTipHeight % 2016) - 2016

puts "Block Height,Date,Difficulty";

while currentBlockHeight <= maxBlockHeight
  currentBlockHash = api.getBlockHash(currentBlockHeight)
  currentBlockInfo = api.getBlockInfo(currentBlockHash)
  puts [
    currentBlockHeight,
    Time.at(currentBlockInfo['timestamp']).strftime("%Y-%m-%d"),
    currentBlockInfo['difficulty'],
  ].join(',')
  currentBlockHeight += 2016
end