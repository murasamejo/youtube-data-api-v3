require './operator'

client = Operator.new(ENV['CLIENT_USER_ID'])

# my_videos = client.search_my_videos
# p my_videos.to_h

# client.upload_video(
#   '~/Movies/20201224_151709.mp4',
#   '動画のタイトル',
#   '動画の説明文'
# )
