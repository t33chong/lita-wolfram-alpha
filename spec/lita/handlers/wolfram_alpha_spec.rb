require "spec_helper"

describe Lita::Handlers::WolframAlpha, lita_handler: true do

  before do
    registry.config.handlers.wolfram_alpha.app_id = ENV["WA_APP_ID"]
  end

  it { is_expected.to route_command("wa pi").to(:query) }

  describe "#query" do

    it "returns the primary pod's title and plaintext" do
      send_command "wa pi"
      expect(replies.count).to eq 2
      expect(replies.first).to match(/^Decimal approximation: 3\.14159/)
      expect(replies.last).to match(/^http:\/\/www\.wolframalpha\.com\/input\/\?i=pi$/)
    end

    it "returns the title and plaintext of the first subpod containing plaintext when the primary pod has multiple subpods, omitting the pod's title when it contains 'Result'" do
      send_command "wa sky chart"
      expect(replies.count).to eq 2
      expect(replies.first).to match(/^Local sidereal time: \d+\^h \d+\^m [\d\.]+\^s$/)
      expect(replies.last).to match(/^http:\/\/www\.wolframalpha\.com\/input\/\?i=sky\+chart$/)
    end

    it "returns the first non-input, non-empty pod's title and plaintext when no primary pod exists" do
      send_command "wa U+00F8"
      expect(replies.count).to eq 2
      expect(replies.first).to match(/^Name: Latin small letter o with stroke/)
      expect(replies.last).to match(/^http:\/\/www\.wolframalpha\.com\/input\/\?i=U%2B00F8$/)
    end

    it "returns the concatenated pod and subpod titles when they exist, separating the titles from the answer with a newline when the answer contains multiple lines" do
      send_command "wa weather forecast for san francisco"
      expect(replies.count).to eq 2
      expect(replies.first).to match(/^Weather forecast for San Francisco, California -> Today:\nbetween/)
      expect(replies.last).to match(/^http:\/\/www\.wolframalpha\.com\/input\/\?i=weather\+forecast\+for\+san\+francisco$/)
      end

    it "returns only the plaintext when the pod and subpod titles contain 'Result' or do not exist" do
      send_command "wa warp speed"
      expect(replies.count).to eq 2
      expect(replies.first).to match(/^speed/)
      expect(replies.last).to match(/^http:\/\/www\.wolframalpha\.com\/input\/\?i=warp\+speed$/)
    end

    it "does not return a link if hide_link is true" do
      registry.config.handlers.wolfram_alpha.hide_link = true
      send_command "wa pi"
      expect(replies.count).to eq 1
      expect(replies.first).to match(/^Decimal approximation: 3\.14159/)
    end

    it "returns a shrug emoticon for an unrecognized query" do
      send_command "wa lkasdjflkajelkfa"
      expect(replies.count).to eq 1
      expect(replies.first).to match(/_\(/)
    end

  end

end
