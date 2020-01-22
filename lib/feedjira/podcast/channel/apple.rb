module Feedjira
  module Podcast
    module Channel
      module Apple
        module InstanceMethods
          def itunes
            @itunes ||= Struct.new(
              :author,
              :block?,
              :categories,
              :image,
              :explicit?,
              :clean?,
              :complete?,
              :new_feed_url,
              :owner,
              :subtitle,
              :summary,
              :keywords,
              :type
            ).new(
              itunes_author,
              itunes_block,
              itunes_categories,
              itunes_image,
              itunes_explicit,
              itunes_clean,
              itunes_complete,
              itunes_new_feed_url,
              itunes_owner,
              itunes_subtitle,
              itunes_summary,
              itunes_keywords,
              itunes_type
            )
          end

          private

          def itunes_image
            @itunes_image ||= Struct.new(:href).new(itunes_image_href)
          end

          def itunes_block
            @itunes_block ||= (_itunes_block == "yes")
          end

          def itunes_categories
            @itunes_categories ||= _itunes_categories.select(&:valid?)
          end

          def itunes_complete
            @itunes_complete ||= (_itunes_complete == "yes")
          end

          def itunes_explicit
            @itunes_explicit ||= ["yes", "explicit", "true"].include?(_itunes_explicit)
          end

          def itunes_clean
            @itunes_clean ||= ["no", "clean", "false"].include?(_itunes_explicit)
          end

          def itunes_owner
            @itunes_owner ||= Struct.new(:email, :name).new(
              _itunes_owner && _itunes_owner.email,
              _itunes_owner && _itunes_owner.name,
            )
          end

          def itunes_type
            @itunes_type ||= _itunes_type.to_s.strip.downcase == 'serial' ? 'serial' : 'episodic'
          end
        end

        def self.included(base)
          base.include(InstanceMethods)

          itunes_xml_ns = "itunes"

          base.element :"#{itunes_xml_ns}:author", as: :itunes_author

          base.element :"#{itunes_xml_ns}:block", as: :_itunes_block

          base.elements :"#{itunes_xml_ns}:category", as: :_itunes_categories, class: AppleCategory

          base.element :"#{itunes_xml_ns}:image", as: :itunes_image_href, value: :href do |href|
            UrlParser.parse href
          end

          base.element :"#{itunes_xml_ns}:explicit", as: :_itunes_explicit
          base.element :"#{itunes_xml_ns}:complete", as: :_itunes_complete

          base.element :"#{itunes_xml_ns}:new_feed_url", as: :itunes_new_feed_url do |url|
            UrlParser.parse url
          end

          base.element :"#{itunes_xml_ns}:owner", as: :_itunes_owner, class: AppleOwner
          base.element :"#{itunes_xml_ns}:subtitle", as: :itunes_subtitle
          base.element :"#{itunes_xml_ns}:summary", as: :itunes_summary

          base.element :"#{itunes_xml_ns}:type", as: :_itunes_type

          # Legacy support

          base.element :"#{itunes_xml_ns}:keywords", as: :itunes_keywords, default: "" do |keywords|
            keywords.split(",").map(&:strip).select { |k| !k.empty? }
          end
        end
      end
    end
  end
end
