require "spec_helper"

describe Lita::Handlers::WolframAlpha, lita_handler: true do

  before do
    registry.config.handlers.wolfram_alpha.app_id = ENV["WA_APP_ID"]
  end

  it { is_expected.to route_command("wa pi").to(:query) }

  describe "#query" do

    it "returns the primary pod's plaintext" do
      send_command "wa pi"
      expect(replies.count).to eq 2
      expect(replies.first).to match(/^3\.14159/)
      expect(replies.last).to match(/^Learn more: http:\/\/www\.wolframalpha\.com\/input\/\?i=pi$/)
    end

    it "returns the first subpod containing plaintext when the primary pod has multiple subpods" do
      send_command "wa sky chart"
      expect(replies.count).to eq 2
      expect(replies.first).to match(/^\d+\^h \d+\^m [\d\.]+\^s$/)
      expect(replies.last).to match(/^Learn more: http:\/\/www\.wolframalpha\.com\/input\/\?i=sky\+chart$/)
    end

    it "returns the first non-input, non-empty pod's plaintext when no primary pod exists" do
      send_command "wa U+00F8"
      expect(replies.count).to eq 2
      expect(replies.first).to match(/^Latin small letter o with stroke/)
      expect(replies.last).to match(/^Learn more: http:\/\/www\.wolframalpha\.com\/input\/\?i=U%2B00F8$/)
    end

    it "does not return a link if hide_link is true" do
      registry.config.handlers.wolfram_alpha.hide_link = true
      send_command "wa pi"
      expect(replies.count).to eq 1
      expect(replies.first).to match(/^3\.14159/)
    end

    it "returns a shrug emoticon for an unrecognized query" do
      send_command "wa lkasdjflkajelkfa"
      expect(replies.count).to eq 1
      expect(replies.first).to match(/_\(/)
    end

  end

end
