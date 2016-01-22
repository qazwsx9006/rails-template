class PageController < ApplicationController
  def index
  end


  def social_meta_default
    set_fb_og_if_empty( 'fb title' , 'fb desc ', 'fb image' )
    set_twitter_card( 'twitter title'  , 'twitter desc' , 'twitter image' )
  end
  private
    def set_fb_og_if_empty(title, desc, image)
      if @fb_og.empty? 
        @fb_og = FbMetum.new(key:url_for, description:desc, title:title).attributes
        @fb_og["image"]="#{image.url}" if image.present?
      end
    end  
    
    def set_twitter_card(title, description, image)
      if @twitter["title"].nil?
        @twitter["title"] = title
        @twitter["description"] = description
        @twitter["image"] = image
      end
    end  


    def set_site_blocks
      keys = ['footer']
      @site_blocks = Hash[SiteBlock.where(key: keys).map{|sb| [sb.key,sb]}]
    end
end
