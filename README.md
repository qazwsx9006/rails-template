rails-template
==============

四點設計 Rails Template

### 使用方式
(先確定系統有裝 node.js)

	$ rails new <project_name> -d mysql -m template.rb

### 資安說明

- 以下兩個已新增在 application_controller，這樣可以依據開發環境不同，正確顯示 url，且防止 ip spoofing

	    @_root_url = request.protocol + host
    	@_full_url = @_root_url + request.fullpath

## TODO
1. 後台表單 generator 綁定 parseley 驗證 user 有送出正確格式的資料
2. 面板減肥 or 更換面板
3. 製作靜態頁面產生器
4. 自定後台 /admins 等安全 route 的設定方式
5. 使用 brakeman 自我驗證
6. 錯誤回報機制綁定
7. 其他自動化綁定

## 其他模版 TODO
1. CMS Template
2. Blog Template
3. One Page Layout Template
4. Epaper Template
5. 購物車 Template 
