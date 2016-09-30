require './lib/rule_set'

class Default < Bunny::RuleSet

  def g(*query_params)
    "https://www.google.com/search?q=%{query_string}" % {query_string: join_query_string(*query_params)}
  end

  def wiki(*query_params)
    "https://www.wikipedia.org/wiki/?search=%{query_string}" % {query_string: join_query_string(*query_params)}
  end

  def so(*query_params)
    "http://stackoverflow.com/search?q=%{query_string}" % {query_string: join_query_string(*query_params)}
  end

end
