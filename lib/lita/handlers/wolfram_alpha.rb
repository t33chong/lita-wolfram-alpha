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
        link = "http://www.wolframalpha.com/input/?i=#{CGI.escape(input)}"
        xml = Nokogiri::XML(http_response.body)
        primary = xml.at_xpath("//pod[@primary='true']//plaintext[string-length(text()) > 0]")
        if primary
          response.reply format_reply(primary)
          response.reply link unless config.hide_link
        else
          secondary = xml.at_xpath("//pod[not(@id='Input')]//plaintext[string-length(text()) > 0]")
          if secondary
            response.reply format_reply(secondary)
            response.reply link unless config.hide_link
          else
            response.reply "¯\\_(ツ)_/¯"
          end
        end
      end

      private

      # pod: plaintext
      # pod -> subpod: plaintext
      # subpod: plaintext
      # plaintext
      def format_reply(node)
        subpod = node.parent
        subpod_title = subpod.attribute("title").content
        pod = subpod.parent
        pod_title = pod.attribute("title").content
        title = [pod_title, subpod_title].select {|t| t.length > 0 && t !~ /^Results?$/}.join(" -> ")
        colon = title.length > 0 ? ":" : ""
        whitespace = node.content =~ /\n/ ? "\n" : " "
        "#{title}#{colon}#{whitespace}#{node.content}".strip
      end

    end

    Lita.register_handler(WolframAlpha)
  end
end
