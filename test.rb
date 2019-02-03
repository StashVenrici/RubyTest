require "open-uri"
web_date = open("http://www.mail.ru").read
my_file = open("my-downloaded-page.html", "w")
my_file.write(web_date)
my_file.close