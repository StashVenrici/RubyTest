require "watir"

browser = Watir::Browser.new :chrome
browser.goto "http://www.mail.ru"


print "end program"