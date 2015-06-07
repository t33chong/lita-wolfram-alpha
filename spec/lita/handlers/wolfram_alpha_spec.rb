require "spec_helper"

describe Lita::Handlers::WolframAlpha, lita_handler: true do

  before do
    registry.config.handlers.wolfram_alpha.app_id = ENV["WA_APP_ID"]
  end

  it { is_expected.to route_command("wa pi").to(:query) }

  describe "#query" do

    it "returns the primary pod's plaintext for a valid query" do
      send_command "wa pi"
      expect(replies.count).to eq 1
      expect(replies.first).to match(/^3\.14159/)
    end

    it "returns the first non-input, non-empty pod's plaintext for a valid query when no primary pod exists" do
      send_command "wa U+00F8"
      expect(replies.count).to eq 1
      expect(replies.first).to match(/^Latin small letter o with stroke/)
    end

    it "returns a shrug emoticon for an unrecognized query" do
      send_command "wa lkasdjflkajelkfa"
      expect(replies.count).to eq 1
      expect(replies.first).to match(/_\(/)
    end

  end

end
