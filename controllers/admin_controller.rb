class AdminController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  rescue_from Exception, :with => :show_errors
  protect_from_forgery with: :exception
  before_filter :authenticate_admin!

  def index
  end

  def delete_image(record,arr)
    arr.each do |t|
      token = 'remove_' + t 
      delete_method = 'remove_' + t + '!'
      record.send(delete_method) if params[token.to_sym] == 'true'
    end
  end

  def search_key(object,*argv)
    argv = *argv
    search_text_column = []
    search_other_column = {}
    object_columns = object.column_names - ['id', 'created_at', 'updated_at'] - argv.map { |i| i.to_s }
    object_columns.each do |column|
      if (object.columns_hash[column].type == :string || object.columns_hash[column].type == :text)
        search_text_column << column
      else
        search_other_column[column.to_sym] = object.columns_hash[column].type
      end
    end

    return search_other_column, search_text_column.join('_or_') + '_cont'
  end

  def f_to_sql(model,params='')
    if !params.methods.include?(:each)
      return ""
    end
    columns=model.column_names
    sql_string = []
    params.each do |k,v|
      next if v.blank?
      next if !columns.include?(k)
      if v.class == String
        sql_string << "#{k} = '#{v.to_i}'"
      elsif v.class == Array
        sql_string << "#{k}> '#{v.first.to_time}'" if !v.first.blank? && v.first.to_time
        sql_string << "#{k}< '#{v.last.to_time}'" if !v.last.blank? && v.last.to_time
      end
    end
    return sql_string.join(' AND ')
  end

  def show_errors(exception)
    if exception.to_s == "ActionController::InvalidAuthenticityToken"
      redirect_to request.referrer ,notice: "驗證碼失效，請重試登入"
      return
    elsif exception.class.to_s == "Net::SMTPSyntaxError"#"Net::SMTPAuthenticationError"
      params[:mail_to_id] = session[:mail_to_id] if session[:mail_to_id]
    end
    params[:err_class] =  exception.class.to_s
    a = "#{exception}:#{request.ip}:#{params}:#{request.url}::::#{exception.backtrace[0..10]}"
    post_url(exception.message,request.ip,request.url,exception.backtrace[0..10].join(','),params)
    raise exception
  end
  def post_url(exception,ip,url,backtrace,params)
    begin
      token = Rails.configuration.project_monitor_token;
      monitor_url = Rails.configuration.project_monitor_url;
      uri = URI.parse(monitor_url)
      data = {
        "token" => token,
        "exception" => exception,
        "ip" => ip,
        "url" => url,
        "backtrace" => backtrace,
        "params" => params
      }

      # Shortcut
      response = Net::HTTP.post_form(uri, data)
      ## Full control
      # http = Net::HTTP.new(uri.host, uri.port)

      # request = Net::HTTP::Post.new(uri.request_uri)
      # request.set_form_data({"q" => "My query", "per_page" => "50"})

      # response = http.request(request)
    rescue
      puts 'if you want to monitor this app, please setting token and url from your monitor app'
      nil
    end
  end

end
