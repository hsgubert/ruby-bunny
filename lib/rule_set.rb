module Bunny
  class RuleSet

    QUERY_STRING_SEPARATOR= '+'

    def self.define_rule(command, rule_lambda)
      @@rules ||= {}
      @@rules[command.to_sym] = rule_lambda
    end

    def self.define_default(rule_lambda)
      @@default_rule_lambda = rule_lambda
    end

    def self.get_redirect_location(bunny_cmd)
      query_string_tokens = bunny_cmd.to_s.split(QUERY_STRING_SEPARATOR)
      run_rule(query_string_tokens[0], *query_string_tokens[1..-1])
    end

  protected

    def self.join_query_string(*params)
      params.join(QUERY_STRING_SEPARATOR)
    end

  private

    def self.run_rule(command, *query_params)
      if @@rules.has_key? command.to_sym
        @@rules[command.to_sym].call(*query_params)
      else
        @@default_rule_lambda.call(command, *query_params)
      end
    end

    DEFAULT_URL = "https://www.google.com/search?q=%{query_string}"
    define_default ->(*query_params) do
      DEFAULT_URL % {query_string: join_query_string(*query_params)}
    end
  end
end
