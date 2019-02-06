require 'mechanize'

agent = Mechanize.new
agent.user_agent_alias = 'Windows Chrome'

page = agent.get "http://www.google.com/"
search_form = page.form_with :name => "f"
search_form.field_with(:name => "q").value = "Hello"

search_results = agent.submit search_form
puts search_results.body