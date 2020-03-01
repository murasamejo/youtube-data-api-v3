require 'dotenv/load'
require 'google/apis/youtube_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'

class YouTubeDataApiV3Auth
  REDIRECT_URI      = 'urn:ietf:wg:oauth:2.0:oob'.freeze
  CREDENTIALS_PATH  = 'credentials'.freeze
  CREDENTIAL        = Pathname.new(CREDENTIALS_PATH).join('credentials.yml')
  CLIENT_SECRET     = Pathname.new(CREDENTIALS_PATH).join(ENV['CLIENT_SECRET_JSON_FILENAME'])
  SCOPES            = %w[
    https://www.googleapis.com/auth/youtube
    https://www.googleapis.com/auth/youtube.upload
  ].freeze

  def initialize(user_id)
    @user_id = user_id
  end

  def credential
    authorizer.get_credentials(@user_id)
  end

  def authorize
    puts '以下のURLにアクセスしてトークンを取得してください（安全でない旨が表示されることがあります）'
    puts 'トークンが取得できたら、以下に貼り付けて Enter を入力してください'
    puts authorizer.get_authorization_url(base_url: REDIRECT_URI)

    authorizer.get_and_store_credentials_from_code(user_id: user_id, code: gets, base_url: REDIRECT_URI)

    puts "credential ファイルとして #{CREDENTIAL} を作成しました"
  end

  def client_secret
    @client_secret ||= Google::Auth::ClientId.from_file(CLIENT_SECRET)
  end

  def token
    @token ||= Google::Auth::Stores::FileTokenStore.new(file: CREDENTIAL)
  end

  def authorizer
    @authorizer ||= Google::Auth::UserAuthorizer.new(client_secret, SCOPES, token)
  end
end

# トークンを取得するときに実行する
# user_id = 'foobar'
# YouTubeDataApiV3Auth.new(user_id).authorize
