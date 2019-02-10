require "rubygems"
require "watir"
require 'uri'
browser = Watir::Browser.new :chrome
browser.goto "https://my.fibank.bg/oauth2-server/login?client_id=E_BANK"
#browser = Watir::Browser.start "https://my.fibank.bg/oauth2-server/login?client_id=E_BANK"

browser.window.maximize

#account array
acc_arr=[]

#entering account
browser.text_field(name: 'username').set 'pib123'
browser.text_field(name: 'password').set 'pib123'
browser.button(id: 'submitBtn').click

lang_select_xpath = "/html[@class='ng-scope']/body[@class='ng-scope info-footer']/div[@class='body-wrapper']/nav[@class='navbar navbar-default']/div[@class='container-fluid']/div[@class='collapse navbar-collapse']/ul[@class='nav navbar-nav']/li[1]/a[@class='ng-binding']"

#set english
if browser.element(:xpath, lang_select_xpath).text !='English'
    browser.element(:xpath, lang_select_xpath).click
end
#save acc name
acc_arr.push(browser.h5(id: 'user--identificator').text)

#click on account with bgn currency
browser.element(:xpath, "/html[@class='ng-scope']/body[@class='ng-scope']/div[@id='app']/div[@class='ng-scope']/div[@class='container ng-scope']/div[@class='layout-content-col']/div[3]/div[@class='sg-view']/div[@class='ng-scope']/div[@class='dashboard-main ng-scope']/div[@id='dashStep1']/div[@class='box-border ng-scope']/div[@class='dash-acc ng-scope ng-isolate-scope']/div[@class='acc-list']/div[@class='ng-isolate-scope']/div[@class='ng-scope']/table[@id='dashboardAccounts']/tbody/tr[@id='step1']/td[@class='ng-scope icon-two-line-col']/div[@class='first-cell cellText ng-scope']/div[@class='info-wrapper']/a/span").click

#save acc currency
acc_arr.push(browser.element(:xpath, "/html[@class='ng-scope']/body[@class='ng-scope']/div[@id='app']/div[@class='ng-scope']/div[@class='container ng-scope']/div[@class='layout-content-col']/div[3]/div[@class='sg-view']/div[@class='ng-scope']/div[@class='iban-tab acc-tab ng-scope']/div/div[@class='sg-view']/div[@class='ng-scope']/div[@class='ng-scope']/div[@class='sg-view']/div[@class='ng-scope']/div[@class='acc-detail ng-scope']/div[@class='col-md-6'][2]/div[1]/div[@class='box-border acc-info']/dl[@class='dl-horizontal']/dd[@class='grey-bg ng-binding'][1]").text)

acc_arr.push(browser.element(:xpath, "/html[@class='ng-scope']/body[@class='ng-scope']/div[@id='app']/div[@class='ng-scope']/div[@class='container ng-scope']/div[@class='layout-content-col']/div[3]/div[@class='sg-view']/div[@class='ng-scope']/div[@class='iban-tab acc-tab ng-scope']/div/div[@class='sg-view']/div[@class='ng-scope']/div[@class='ng-scope']/div[@class='sg-view']/div[@class='ng-scope']/div[@class='acc-detail ng-scope']/div[2]/div[@class='acc-bal-directive']/div[@class='grey-bg ng-scope'][3]/h3[@class='ng-binding']").text)

acc_arr.push(browser.element(:xpath, "/html[@class='ng-scope']/body[@class='ng-scope']/div[@id='app']/div[@class='ng-scope']/div[@class='container ng-scope']/div[@class='layout-content-col']/div[3]/div[@class='sg-view']/div[@class='ng-scope']/div[@class='iban-tab acc-tab ng-scope']/div/div[@class='sg-view']/div[@class='ng-scope']/div[@class='ng-scope']/div[@class='sg-view']/div[@class='ng-scope']/div[@class='acc-detail ng-scope']/div[@class='col-md-6'][2]/div[1]/div[@class='box-border acc-info']/dl[@class='dl-horizontal']/dd[@class='ng-scope']").text)



puts acc_arr.join(', ')
