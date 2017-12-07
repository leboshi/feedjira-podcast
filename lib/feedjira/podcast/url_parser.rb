module Feedjira
  module Podcast
    module UrlParser
      def self.parse(url)
        stripped_url = url.to_s.strip.gsub(/\A\W+/, '')
        begin
          Addressable::URI.parse stripped_url
        rescue
          stripped_url
        end
      end
    end
  end
end