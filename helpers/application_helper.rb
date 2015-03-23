module ApplicationHelper
  def javascript_embed_file(file)
    raw('<script>' + Rails.application.assets.find_asset(file + '.js').source + '</script>')
  end

  def url_decode(string)
    begin
      URI.unescape(string)
    rescue
      string
    end
  end

  def column_to_model(string)
    begin
      string.titleize.gsub(' ','').constantize
    rescue
      nil
    end
  end

  def string_encode(string="",show=1)
    string_length = string.length
    encode_num = string_length - (show * 2)
    return "#{string[0..show-1]}#{'*'*encode_num.abs}#{string[string_length-show..-1]}"
  end

  def paginate_show_ten
    #for kaminari
    current_page = params[:page].to_i <= 0 ? 1 : params[:page].to_i
    ( page_for_window = 10 - current_page ) if current_page < 6

    return page_for_window
  end
end
