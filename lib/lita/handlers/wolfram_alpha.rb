require "nokogiri"

module Lita
  module Handlers
    class WolframAlpha < Handler

      API_URL = "http://api.wolframalpha.com/v2/query"

      config :app_id, type: String, required: true

      route(/^wa\s+(.+)/i, :query, command: true,
                    help: {t("help.query_key") => t("help.query_value")})

      def query(response)
        input = response.matches.first.first
        http_response = http.get(
          API_URL,
          input: input,
          format: "plaintext",
          appid: config.app_id
        )
        return if http_response.status != 200
        xml = Nokogiri::XML(http_response.body)
        result = xml.at_xpath("//pod[@primary='true']//plaintext")
        return response.reply result.content if result
        result = xml.at_xpath("//pod[not(@title='Input interpretation')]//plaintext[string-length(text()) > 0]")
        response.reply result ? result.content : "¯\\_(ツ)_/¯"
      end

    end

    Lita.register_handler(WolframAlpha)
  end
end
