#!/usr/bin/env ruby
# coding: utf-8
require 'active_support/inflector'

# how to use?
# $ruby lib/admins_sacffold_controller.rb
# 待修：view內，欄位相關不會生成。  controller內 parameter "white list" through. 不會生成。

puts "controller name ?   \n"
name = gets.chomp.downcase
if name.gsub(" ","").length == 0
  #name 必填
  puts "you can't skip this."
else
  #1.建立model
  puts "\ninsert model column:type     ex(title:string name:string)      --you can skip this step by input nothing\n"
  columns = gets.chomp.downcase

  if columns.gsub(" ","").length > 0
    model_command = "rails g model #{name} #{columns}"
    system(model_command)
  else
    puts "you skip genera model.\n"
  end


  #2.建立admin底下的 controller
  if name.gsub(" ","").length > 0
    if columns.gsub(" ","").length > 0
      controller_command = "rails g scaffold_controller admins/#{name} #{columns} --model-name=#{name.capitalize}"
    else
      controller_command = "rails g scaffold_controller admins/#{name} --model-name=#{name.capitalize}"
    end
    system(controller_command)
  else
    puts "you skip generate controller.\n"
  end


  #3.成功提示
  if name.gsub(" ","").length > 0
    begin
      puts "\n####Success! Final step is add #{name.pluralize} to routes.rb : \n\n"\
        "namespace :admins do \n"\
          "    resources :#{name.pluralize} \n"\
          "end \n\n"
    rescue
      puts "you need to install [ActiveSuppt] for final step tips (about routes)."
    end
  end
end

