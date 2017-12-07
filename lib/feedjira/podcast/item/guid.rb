module Feedjira
  module Podcast
    module Item
      class GUID
        include SAXMachine
        include FeedUtilities

        value :guid do |guid|
          guid && perma_link? ? UrlParser.parse(guid) : guid
        end

        attribute :isPermaLink, as: :is_perma_link

        def perma_link?
          is_perma_link == "false" ? false : true
        end
      end
    end
  end
end
