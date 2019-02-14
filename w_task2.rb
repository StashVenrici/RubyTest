require "rubygems"
require "watir"
require 'open-uri'

browser = Watir::Browser.new :firefox
browser.goto "https://my.fibank.bg/oauth2-server/login?client_id=E_BANK"

browser.window.maximize

//TODO