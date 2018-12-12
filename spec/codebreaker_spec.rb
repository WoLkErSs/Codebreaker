RSpec.describe Console do
  let(:current_subject) { described_class.new }
  describe '.choose_action' do

    after do
      current_subject.choose_action
    end

    it 'call registration' do
      allow(current_subject).to receive(:input?).and_return('start')
      # allow(current_subject).to receive_message_chain(:gets) {'start'}
      expect(current_subject).to receive(:call_registration)
    end

    it "call rules" do
      # allow(current_subject).to receive(:input?)('rules')
      allow(current_subject).to receive(:input?).and_return('rules')
      # allow(current_subject).to receive_message_chain(:gets) {'rules'}
      expect(current_subject).to receive(:rules_call)
    end

    # it "call statistics" do
    #   allow(current_subject).to receive_message_chain(:gets) {'stats'}
    #   expect(current_subject).to receive(:statistics)
    # end

    # it "called enother action" do
    #   allow(current_subject).to receive_message_chain(:gets, :chomp) {'XXXTANTION'}
    #   expect(current_subject.choose_action(enother_input)).to eq('XXXTANTION')
    #
    # end
  end
end
