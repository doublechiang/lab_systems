require_relative '../lib/system.rb'

RSpec.describe "System" do
    context "system" do
        it "valid mac address" do
            sys = System.new
            sys.bmc_mac = "123"
            expect(sys.mac_valid?).to eq(false)
            sys.bmc_mac = "12:34:56:78:90:"
            expect(sys.mac_valid?).to eq(false)
            sys.bmc_mac = "12:34:56:78:90:ab"
            expect(sys.mac_valid?).to eq(true)
            sys.bmc_mac = "12-34-56-78-90-ab"
            expect(sys.mac_valid?).to eq(false)
        end
    end
end