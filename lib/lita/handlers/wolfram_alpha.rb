require "cgi"
require "nokogiri"

module Lita
  module Handlers
    class WolframAlpha < Handler

      API_URL = "http://api.wolframalpha.com/v2/query"

      config :app_id, type: String, required: true
      config :hide_link, types: [TrueClass, FalseClass], default: false

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
        link = "Learn more: http://www.wolframalpha.com/input/?i=#{CGI.escape(input)}"
        xml = Nokogiri::XML(http_response.body)
        primary = xml.at_xpath("//pod[@primary='true']//plaintext[string-length(text()) > 0]")
        if primary
          response.reply primary.content
          response.reply link unless config.hide_link
        else
          secondary = xml.at_xpath("//pod[not(@id='Input')]//plaintext[string-length(text()) > 0]")
          if secondary
            response.reply secondary.content
            response.reply link unless config.hide_link
          else
            response.reply "¯\\_(ツ)_/¯"
          end
        end
      end

    end

    Lita.register_handler(WolframAlpha)
  end
end
