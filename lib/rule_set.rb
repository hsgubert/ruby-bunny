module Bunny
  class RuleSet

    DEFAULT_URL = "https://www.google.com/search?q=%{query_string}"
    QUERY_STRING_SEPARATOR= '+'

    def method_missing(command, *query_params)
      DEFAULT_URL % {query_string: join_query_string(command, *query_params)}
    end

    def get_redirect_location(bunny_cmd)
      query_string_tokens = bunny_cmd.to_s.split(QUERY_STRING_SEPARATOR)

      if query_string_tokens[0] != __method__
        self.send(query_string_tokens[0], query_string_tokens[1..-1])
      else
        self.method_missing(query_string_tokens[0], query_string_tokens[1..-1])
      end
    end

  protected

    def join_query_string(*params)
      params.join(QUERY_STRING_SEPARATOR)
    end

  end
end
