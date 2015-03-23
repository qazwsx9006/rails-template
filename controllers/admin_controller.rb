class AdminController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :authenticate_admin!

  def index
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

end
