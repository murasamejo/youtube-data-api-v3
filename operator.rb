require 'dotenv/load'
require './you_tube_data_api_v3_auth'
require 'google/apis/youtube_v3'

class Operator
  def initialize(user_id)
    @youtube                = Google::Apis::YoutubeV3::YouTubeService.new
    @youtube.authorization  = YouTubeDataApiV3Auth.new(user_id).credential
  end

  def search_my_videos
    # for_mine を指定する場合は channel_id を指定してはいけない
    @youtube.list_searches(
      :snippet,
      type: 'video',
      max_results: 50,
      for_mine: true
    )
  end

  def search_specific_channnel_videos
    @youtube.list_searches(
      :snippet,
      type: 'video',
      max_results: 50,
      channel_id: ENV['CHANNEL_ID']
    )
  end

  def fetch_video_details(video_id_array)
    @youtube.list_videos(
      'snippet, statistics',
      id: video_id_array
    )
  end

  def upload_video(filepath, title, description)
    snippet = {
      snippet: {
        title: title,
        description: description,
        # 変数名はスネークケースで記述する
        # https://github.com/googleapis/google-api-ruby-client/blob/master/generated/google/apis/youtube_v3/representations.rb
        # 公開（public）/ 限定公開（unlisted）
        # 有効な値は public、private、および unlisted です。
        # https://developers.google.com/youtube/v3/guides/uploading_a_video?hl=ja
        privacy_status: 'private'
      }
    }

    @youtube.insert_video(
      'snippet',
      snippet,
      upload_source: filepath,
      content_type: 'video/*'
    )
  end
end
