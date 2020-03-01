require './operator'

client = Operator.new(ENV['CLIENT_USER_ID'])
my_videos = client.search_my_videos

p my_videos.to_h
