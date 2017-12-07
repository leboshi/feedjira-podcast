module Feedjira
  module Podcast
    module Item
      class Source
        include SAXMachine
        include FeedUtilities

        value :source, as: :name

        attribute :url do |url|
          UrlParser.parse url
        end
      end
    end
  end
end
