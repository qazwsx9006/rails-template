module AdminHelper
  
  def allow_no_tag(str)
    sanitize( str ,tags: %w(), attributes: %w() )
  end
  
  def solution_text (width=nil,height=nil)
    width.present? ?
    "建議上傳尺寸大於 #{width} x #{height}"
    :
    ""
  end

  def t_text (str,opt={})
    
    size = opt[:font_size] ? "font-size:" + opt[:font_size] + ";" : ""
    color = opt[:color] ? "color:" + opt[:color] + ";" : ""

    raw "<div class='form-group' style='" + size + color + "'>
           <div class='col-sm-1 control-label'></div>
           <div class='col-sm-10'>"+str+"</div>
         </div>"
  end

  def t_file_input(f,sym,opt={})
    label_name = opt[:label_name] || "image"
    is_require = false || opt[:required]
    
    opt[:no_delete] ? 
    (
      delete_btn = '' 
      delete_flag = ''
    )
    : 
    (
      delete_btn = "<a href='javascript: void;' class='btn btn-danger delete_btn'>刪除</a>" 
      delete_flag = hidden_field_tag("remove_#{sym.to_s}".to_sym, false, class:'remove_flag') 
    )

    fake_image_data = "data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9InllcyI/PjxzdmcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB3aWR0aD0iMjAwIiBoZWlnaHQ9IjE1MCIgdmlld0JveD0iMCAwIDIwMCAxNTAiIHByZXNlcnZlQXNwZWN0UmF0aW89Im5vbmUiPjxkZWZzLz48cmVjdCB3aWR0aD0iMjAwIiBoZWlnaHQ9IjE1MCIgZmlsbD0iI0VFRUVFRSIvPjxnPjx0ZXh0IHg9IjYwLjczNDM3NSIgeT0iNzUiIHN0eWxlPSJmaWxsOiNBQUFBQUE7Zm9udC13ZWlnaHQ6Ym9sZDtmb250LWZhbWlseTpBcmlhbCwgSGVsdmV0aWNhLCBPcGVuIFNhbnMsIHNhbnMtc2VyaWYsIG1vbm9zcGFjZTtmb250LXNpemU6MTBwdDtkb21pbmFudC1iYXNlbGluZTpjZW50cmFsIj5TdGF0aWMgaW1hZ2U8L3RleHQ+PC9nPjwvc3ZnPg=="
    raw "<div class='row'>
      <div class='col-sm-12'>
        <div class='form-group'>
          <div class='col-xs-12'>" + 
             f.label(sym, label_name)+
             f.file_field(sym, :class => 'form-control image_input', :required => is_require)+
             image_tag(f.object.try(sym)|| fake_image_data , alt: "no image", style: 'width: 250px; height: 150px;', class:'preview_image'  )+
             solution_text(opt[:width],opt[:height])+
             delete_flag+
             delete_btn+
          "</div>
        </div>
      </div>
    </div>"

  end

  def t_file_field(f,sym,opt={})
    label_name = opt[:label_name] || "file_field"
    is_require = false || opt[:required]

    raw "<div class='row'>
      <div class='col-sm-12'>
        <div class='form-group'>
          <div class='col-xs-12'>" + 
             f.label(sym,label_name)+
             f.file_field(sym, :class => 'form-control', :required => is_require)+
          "</div>
        </div>
      </div>
    </div>"
  end
  
  def t_select(f,sym,colle,colle_opt={},opt={})
    label_name = opt[:label_name] || "select"
    is_require = false || opt[:required]
    can_blank = opt[:include_blank].present?

    raw "<div class='row'>
      <div class='col-sm-12'>
        <div class='form-group'>
          <div class='col-xs-12'>" + 
             f.label(sym, label_name )+
             f.select(sym, colle , colle_opt , :required => is_require, class: "form-control",id:opt[:id])+
          "</div>
        </div>
      </div>
    </div>"
  end

  def t_text_area(f,sym,opt={})
    label_name = opt[:label_name] || "text_area"

    raw "<div class='row'>
      <div class='col-sm-12'>
        <div class='form-group'>
          <div class='col-xs-12'>" + 
             f.label(sym, label_name)+
             f.text_area(sym, :class => 'form-control')+
          "</div>
        </div>
      </div>
    </div>"
  end

  def t_text_field(f,sym,opt={})
    label_name = opt[:label_name] || "text_field"
    is_require = false || opt[:required]  
    
    raw "<div class='row'>
      <div class='col-sm-12'>
        <div class='form-group'>
          <div class='col-xs-12'>" + 
             f.label(sym, label_name)+
             f.text_field(sym,:class => 'form-control', :required => is_require)+
          "</div>
        </div>
      </div>
    </div>"
  end

  def t_number_field(f,sym,opt={})
    label_name = opt[:label_name] || "number_field"
    is_require = false || opt[:required]  

    raw "<div class='row'>
      <div class='col-sm-12'>
        <div class='form-group'>
          <div class='col-xs-12'>" + 
             f.label(sym, label_name)+
             f.number_field(sym, :class => 'form-control', :required => is_require)+
          "</div>
        </div>
      </div>
    </div>"
  end
  

  def t_check_box(f,sym,opt={})
    label_name = opt[:label_name] || "check_box"

    raw "<div class='row'>
      <div class='col-sm-12'>
        <div class='form-group'>
          <div class='col-xs-12'>" + 
             f.label(sym, label_name)+
             f.check_box(sym)+
          "</div>
        </div>
      </div>
    </div>"
  end
  def t_datetime_select(f,sym,opt={})
    label_name = opt[:label_name] || "datetime_select"
    is_require = false || opt[:required]  
    default = opt[:default]
    picker = opt[:picker]

    raw "<div class='row'>
      <div class='col-sm-12'>
        <div class='form-group'>
          <div class='col-xs-12'>" + 
             f.label(sym, label_name)+
             f.datetime_select(sym, :class => 'form-control', :required => is_require, picker: picker)+
          "</div>
        </div>
      </div>
    </div>"
  end
  def t_date_select(f,sym,opt={})
    label_name = opt[:label_name] || "date_select"
    is_require = false || opt[:required]  
    default = opt[:default]
    picker = opt[:picker]

    raw "<div class='row'>
      <div class='col-sm-12'>
        <div class='form-group'>
          <div class='col-xs-12'>" + 
             f.label(sym, label_name)+ 
             f.date_select(sym, :class => 'form-control', :required => is_require, picker: picker)+
          "</div>
        </div>
      </div>
    </div>"
  end
  def t_time_select(f,sym,opt={})
    label_name = opt[:label_name] || "time_select"
    is_require = false || opt[:required]  
    default = opt[:default]

    raw "<div class='row'>
      <div class='col-sm-12'>
        <div class='form-group'>
          <div class='col-xs-12'>" + 
             f.label(sym, label_name) +
             f.time_select(sym, :class => 'form-control', :required => is_require,default:default)+
          "</div>
        </div>
      </div>
    </div>"
  end
  
  def t_cktext_area(f, sym,ck_opt={},opt={})
    label_name = opt[:label_name] || "cktext_area"
    is_require = false || opt[:required]  

    raw "<div class='row'>
      <div class='col-sm-12'>
        <div class='form-group'>
          <div class='col-xs-12'>" + 
             f.label(sym, label_name)+
             f.cktext_area(sym, :class => 'form-control', :ckeditor => ck_opt, :required => is_require)+
          "</div>
        </div>
      </div>
    </div>"

  end

  def t_password_field(f,sym,opt={})
    label_name = opt[:label_name] || "password_field"
    is_require = false || opt[:required]  
   
   raw "<div class='row'>
      <div class='col-sm-12'>
        <div class='form-group'>
          <div class='col-xs-12'>" + 
             f.label(sym, label_name)+
             f.password_field(sym, :class => 'form-control', :required => is_require)+
          "</div>
        </div>
      </div>
    </div>"
  end

  def t_submit(f,back_path,opt={})
      sub_btn = opt[:sub_btn] || t('admin.submit')
      back_btn = opt[:back_btn] || t('admin.cancel')

      raw "<div class='form-group'>
            <div class='col-xs-12'>"+
               f.submit(sub_btn, :class => 'btn btn-primary')+ "\n" +
               link_to(back_btn, back_path, :class => 'btn btn-default')+
            "</div>
          </div>"
  end
end
