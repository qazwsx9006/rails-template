class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  rescue_from Exception, :with => :show_errors
  protect_from_forgery with: :exception
  layout :layout_by_resource

  before_filter :set_root_url
  before_filter :set_fb

  protected

  def set_root_url
    # do not use HTTP_X_FORWARDED_HOST, will cause ip spoofing
    host = env['HTTP_HOST'] || "#{env['SERVER_NAME'] || env['SERVER_ADDR']}:#{env['SERVER_PORT']}"
    @_root_url = request.protocol + host
    @_full_url = @_root_url + request.fullpath
  end

  def layout_by_resource
    if devise_controller?
      "devise"
    elsif request.path.include?("admin/")
      "admin"
    else
      "application"
    end
  end
  def set_fb
    if !request.path.include?("admin")
      @meta ||= {}
      @fb_og_images=[]
      @fb_og = FbMetum.find_by_key(request.path).as_json || {}
      @fb_og["image"]="#{root_url[0..-2]}#{@fb_og["image"]["url"]}" if @fb_og["image"]
    end
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
