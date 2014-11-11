require 'spec_helper'
require 'rake'

describe 'home' do
  let(:twitter_profile_image) {"http://a0.twimg.com/profile_images/447958234/Lichtenstein_normal.jpg"}
  let(:twitter_media_image) {"https://pbs.twimg.com/media/BoqqU1wIMAAr_zO.jpg"}
  let(:instagram_profile_image) {"http://images.ak.instagram.com/profiles/profile_33110152_75sq_1380185157.jpg"}
  let(:instagram_media_image) {"http://scontent-a.cdninstagram.com/hphotos-xfa1/t51.2885-15/10684067_323739034474097_279647979_n.jpg"}

  it "should display post in db" do
    post = FactoryGirl.create(:post)

    visit '/'
    page.should have_content(post.text)
    page.should have_content(post.screen_name)
  end

  it 'should auto update only when on top of page', js: true do

    visit '/'

    page.should have_content("Thee Namaste Nerdz. ##{ENV['HASHTAG']}")
    page.should have_content('@bullcityrecords')
    page.should have_image(twitter_profile_image)
    page.should have_image(twitter_media_image)

    page.should have_content("#elevator #kiss #love #budapest #basilica #tired")
    page.should have_content('@pollywoah')
    page.should have_image(instagram_profile_image)
    page.should have_image(instagram_media_image)

    page.execute_script('window.scrollTo(0,100000)')

    sleep 5

    page.should_not have_content("DAT ISH CRAY AIN'T IT ##{ENV['HASHTAG']}")

    page.execute_script('window.scrollTo(0,0)')

    page.should have_content("DAT ISH CRAY AIN'T IT ##{ENV['HASHTAG']}")
  end

end

module Capybara
  class Session
    def has_image?(src)
      has_xpath?("//img[contains(@src,\"#{src}\")]")
    end
  end
end

