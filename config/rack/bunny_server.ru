# Loads gems
Bundler.require(:default)

# loads development gems
if ENV['RACK_ENV'] == 'development'
  Bundler.require(:development)
end

def redirect(location)
  [301, {'Location' => location, 'Content-Type' => 'text/html'}, ['Moved Permanently']]
end

# loads rule set
require 'active_support'
require 'active_support/core_ext'

bunny_config = YAML::load_file('bunny_config.yml')

rule_set_filepath = './rules/' + bunny_config["rule_set"] + '.rb'
require rule_set_filepath

begin
  rule_set = bunny_config["rule_set"].camelize.constantize
rescue NameError => e
  puts "Expected #{rule_set_filepath} to define #{bunny_config["rule_set"].camelize} class"
  raise e
end

if !rule_set.ancestors.include?(Bunny::RuleSet)
  raise RuntimeError.new("Expected #{rule_set} to derive from #{Bunny::RuleSet}")
end

# A rack application is a proc with a single input and 3 outputs:
# input
# => env: a hash
# output is an array of:
# => 0: status code
# => 1: headers hash
# => 2: body (array of strings)
app = proc do |env|
  if env['REQUEST_METHOD'] != 'GET'
    content = 'Method Not Allowed'
    return [405, {'Content-Type' => 'text/html', 'Content-Length' => content.size.to_s}, [content]]
  end

  redirect rule_set.get_redirect_location(env['QUERY_STRING'])
end

run app
