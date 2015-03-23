$('.search-form-btn').click(function(){
    $('.search-form').toggleClass('search_form_show');
    //fa-angle-double-left
    $(this).find('.fa').toggleClass('fa-angle-double-left').toggleClass('fa-angle-double-right');
});