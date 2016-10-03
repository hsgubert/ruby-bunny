require './lib/rule_set'

class Default < Bunny::RuleSet

  define_rule :g, ->(*query_params) do
    "https://www.google.com/search?q=%{query_string}" % {query_string: join_query_string(*query_params)}
  end

  define_rule :wiki, ->(*query_params) do
    "https://www.wikipedia.org/wiki/?search=%{query_string}" % {query_string: join_query_string(*query_params)}
  end

  define_rule :so, ->(*query_params) do
    "http://stackoverflow.com/search?q=%{query_string}" % {query_string: join_query_string(*query_params)}
  end

end
