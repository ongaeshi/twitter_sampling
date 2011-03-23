# -*- coding: utf-8 -*-
#
# @file 
# @brief
# @author ongaeshi
# @date   Twitterからデータをサンプリング

require 'rubygems'
require 'twitterstream'
require 'sequel'

# --- setup database
DB = Sequel.connect("sqlite://#{ARGV[0]}")

class User < Sequel::Model
  one_to_many :tweets
end

class Tweet < Sequel::Model
  many_to_one :user
end

# --- sampling function
def twitter_sampling(db_name, username, password)
  TwitterStream.new({:username => username, :password => password}).sample do |status|
  # TwitterStream.new({:username => username, :password => password}).follow([26497130]) do |status|
    next unless status['text']

    # ユーザー
    u = status['user']
    user = User[:tw_id => u['id']] || User.new
    user.tw_id = u['id']
    user.name = u['name']
    user.screen_name = u['screen_name']
    user.profile_image_url = u['profile_image_url']
    user.save

    # つぶやき
    tweet = Tweet[:tw_id => status['id']] || Tweet.new
    tweet.tw_id = status['id']
    tweet.text = status['text']
    tweet.created_at = status['created_at']
    tweet.user = user
    tweet.save
    
    # 定期的にデバッグ表示
    if (Tweet.count % 100 == 0)
      puts "#{Time.now.strftime("%Y/%m/%d %H:%M:%S")} #{Tweet.count} tweets #{File.size? db_name} byte"
    end
  end
end

# --- main
data = Marshal.load(open('test.db'))
twitter_sampling(ARGV[0], data[0], data[1])
