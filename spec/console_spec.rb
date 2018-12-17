
RSpec.describe Console do
  CHOOSE_ACTION = "Choose actions: start, rules, stats or exit\n"

  WROGN_INPUTS = {
                  wrong_input_action: "You have passed unexpected command.\n Please choose one from listed commands\n",
                  when_wrong_name: 'Name length must be from 3 to 20 words',
                  wrong_input_code: 'You should enter one of the valid commands - one more time.'}.freeze
  let(:outputs) {'You have passed unexpected command.Please choose one from listed commands'}
  subject { described_class.new }

  describe '#process' do
    context 'with call choose action' do
      it do
        # subject.send(:choose_action)
        expect(subject).to receive(:choose_action)
        subject.process
      end
    end

    context 'with call start' do
      it do
        expect(subject).to receive(:start_game)
        subject.process
      end
    end

    context 'with call guess input' do
      it do
        expect(subject).to receive(:guess_code)
        subject.process
      end
    end
  end

  describe '#choose_action' do

    after do
      subject.choose_action
    end

    context 'call registration' do
      it do
        allow(subject).to receive(:input).and_return('start')
        expect(subject).to receive(:call_registration)
      end
    end

    context 'call rules' do
      it do
        allow(subject).to receive(:input).and_return('rules', 'start')
        allow(subject).to receive(:call_registration)
        expect(subject).to receive(:rules_call)
      end
    end

    context 'call stats' do
      it do
        allow(subject).to receive(:input).and_return('stats', 'start')
        allow(subject).to receive(:call_registration)
        expect(subject).to receive(:statistics)
      end
    end


    context 'with wrong input' do
      it do
        allow(subject).to receive_message_chain(:gets, :chomp).and_return('staawdawdts', 'start')
        allow(subject).to receive(:call_registration)
        expect(subject).to receive(:puts).with(I18n.t(:greeting))
        expect(subject).to receive(:puts).with(CHOOSE_ACTION).twice
        expect(subject).to receive(:puts).with(WROGN_INPUTS[:wrong_input_action])
      end
    end
  end
end
