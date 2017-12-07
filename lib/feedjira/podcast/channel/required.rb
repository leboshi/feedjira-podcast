module Feedjira
  module Podcast
    module Channel
      module Required
        def self.included(base)
          base.element :link do |link|
            UrlParser.parse link
          end

          base.element :title
          base.element :description
        end
      end
    end
  end
end
