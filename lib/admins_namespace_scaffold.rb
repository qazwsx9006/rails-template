#!/usr/bin/env ruby
# coding: utf-8
require 'active_support/inflector'
require 'pry'
# how to use?
# $ruby lib/admins_sacffold_controller.rb
# 待修：view內，欄位相關不會生成。  controller內 parameter "white list" through. 不會生成。




  #binding.pry

puts "controller name ?   \n"
name = gets.chomp.downcase
if name.gsub(" ","").length == 0
  #name 必填
  puts "you can't skip this."
else

  #0.5. 輸入namespace
  puts "\n 請輸入namespace \n"
  namespace = gets.chomp.downcase
  puts "失敗 \n" unless namespace.gsub(" ","").length > 0


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
      controller_command = "rails g scaffold_controller admins::#{namespace}::#{name} #{columns} --model-name=#{name.capitalize} "
    else
      controller_command = "rails g scaffold_controller admins::#{namespace}::#{name} --model-name=#{name.capitalize}"
    end
    system(controller_command)
  else
    puts "you skip generate controller.\n"
  end


  #3 建立 route
  route_file = File.new('config/routes.rb','r')
  unsplit_data = route_file.read
  route_data = unsplit_data.split("\n")
  route_file.close
  if unsplit_data.gsub(/\s+/,"").include?("namespace:#{namespace}do")
    route_data.each_with_index do |line,index|
      if line.gsub(/\s+/,"") == "namespace:#{namespace}do"
        @place = index
        break
      end
    end
    route_data.insert(@place+1,"        resources :#{name.pluralize}")
  else 
    route_data.each_with_index do |line,index|
      if line.gsub(/\s+/,"") == 'namespace:adminsdo'
        @place = index
        break
      end
    end
    route_data.insert(@place+1,
      "      namespace :#{namespace} do
          resources :#{name.pluralize}
      end"
      )
  end
  File.open('config/routes.rb','w') do |tar|
    route_data.each do |line|
      tar << line
      tar << "\n"
    end
  end

  #4 yml 建立字串
  File.open('config/locales/admin.zh-TW.yml','a') do |f|
    f.puts "\n"
    f.puts "    #{name}:"
    f.puts "      #{name}: #{name}"
    columns.split(" ").each do |c|
      col_name = c.split(":")[0]
      f.puts "      #{col_name}: #{"temp_"+col_name}"
    end
  end


  #5.成功提示
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

