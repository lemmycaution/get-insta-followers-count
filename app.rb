require 'sinatra'
require 'anemone'
require 'json'

CSS_SELECTOR = "span.-cx-PRIVATE-FollowedByStatistic__count".freeze

get '/:user' do
  @followers = nil
  content_type :json 
  Anemone.crawl("https://www.instagram.com/#{params[:user]}/", {depth_limit: 1}) do |anemone|
    anemone.on_every_page do |page|
      if match = page.doc.to_s.match(/"followed_by\":{\"count\":(\d+)}/)
        @followers = match[1]
      end
    end
  end
  JSON.dump({followers: @followers.to_i})
end