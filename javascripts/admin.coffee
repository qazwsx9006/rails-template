# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#= require jquery
#= require jquery_ujs
#= require bootstrap-sprockets
#= require_directory ./admin
#= require ckeditor/init
#= require moment
#= require bootstrap-datepicker/core
#= require bootstrap-datepicker/locales/bootstrap-datepicker.zh-TW.js
#= require bootstrap-datetimepicker
#= require select2
#

# select2
$ ->
  $('select').select2()
