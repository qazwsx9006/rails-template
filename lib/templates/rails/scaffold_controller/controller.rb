# coding: utf-8
<% @controller_class_path.size > 1 ? admin_path = @controller_class_path[0] + '_' + @controller_class_path[1] : admin_path = @controller_class_path[0] -%>
<% if namespaced? -%>
require_dependency "<%= namespaced_file_path %>/application_controller"
<% end -%>
<% module_namespacing do -%>
class <%= controller_class_name %>Controller < AdminController
  before_action :set_<%= singular_table_name %>, only: [:show, :edit, :update, :destroy]

  # GET /admins<%= route_url %>
  def index
    search_filter = search_key(<%= class_name -%>) #(參數說明 要搜尋的Model , *排除搜尋的欄位)
    @search_key = search_filter.last
    @search_not_text_key = search_filter.first

    @f_sql = f_to_sql(<%= class_name -%>,params[:f])
    if @f_sql.blank?
      @search = <%= class_name -%>.search(params[:q])
    else
      @search = <%= class_name -%>.where(@f_sql).search(params[:q])
    end
    @<%= plural_table_name %> = @search.result.page(params[:page])
  end

  # GET /admins<%= route_url %>/1
  def show
  end

  # GET /admins<%= route_url %>/new
  def new
    @<%= singular_table_name %> = <%= orm_class.build(class_name) %>
  end

  # GET /admins<%= route_url %>/1/edit
  def edit
  end

  # POST /admins<%= route_url %>
  def create
    @<%= singular_table_name %> = <%= orm_class.build(class_name, "#{singular_table_name}_params") %>

    if @<%= orm_instance.save %>
      redirect_to <%= admin_path %>_<%= singular_table_name %>_path(@<%= singular_table_name %>.id), notice: t('admin.<%= singular_table_name %>.<%= singular_table_name %>') + t('admin.created_done')
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /admins<%= route_url %>/1
  def update
    if @<%= orm_instance.update("#{singular_table_name}_params") %>
      redirect_to <%= admin_path %>_<%= singular_table_name %>_path, notice: t('admin.<%= singular_table_name %>.<%= singular_table_name %>') + t('admin.updated_done')
    else
      render action: 'edit'
    end
  end

  # DELETE /admins<%= route_url %>/1
  def destroy
    @<%= orm_instance.destroy %>
    redirect_to <%= admin_path %>_<%= table_name %>_path, notice: t('admin.<%= singular_table_name %>.<%= singular_table_name %>') + t('admin.deleted_done')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_<%= singular_table_name %>
      @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
    end

    # Only allow a trusted parameter "white list" through.
    def <%= "#{singular_table_name}_params" %>
      <%- if attributes_names.empty? -%>
      params[<%= ":#{singular_table_name}" %>]
      <%- else -%>
      params.require(<%= ":#{singular_table_name}" %>).permit(<%= attributes_names.map { |name| ":#{name}" }.join(', ') %>)
      <%- end -%>
    end
end
<% end -%>
