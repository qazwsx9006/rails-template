$( ".delete_btn" ).click(function() {
  var btn = $(this);
  var img = $(this).siblings('.preview_image');
  var flg = $(this).siblings('.remove_flag');
  if(flg.attr('value') == 'false'){
    img.hide();
    flg.attr('value','true');
    btn.text('復原');
  }else{
    img.show();
    flg.attr('value','false');
    btn.text('刪除');
  }
});

$(document).on('change','.form-control.image_input',function(){
    var image = $(this).siblings('.preview_image');
    //console.log(image);
    readURL(this,image);
});  

function readURL(input,image) {
  if (input.files && input.files[0]) {
      var reader = new FileReader();
      reader.onload = function (e) {
          image.attr('src', e.target.result);
      }
      reader.readAsDataURL(input.files[0]);
  }
}