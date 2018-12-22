RSpec.describe ProcessHelper do
  WRONG_LEVEL_DIF = 'dedmoroz'
  let(:player_double) {double('Player', assign_name: 'Gilly')}
  subject { described_class.new(player: player_double) }
  describe '#new' do
    context 'when screate subject' do
      it {expect(subject.instance_variable_get(:@player)).to eq(player_double)}
    end
  end

  describe '#setup_player' do
    context 'set player name' do
      it 'when inputed right name' do
        player_double.stub(:errors_store) {[]}
        player_double.stub(:name) {'Gilly'}
        allow(subject).to receive_message_chain(:gets, :chomp).and_return('Gilly')
        expect(subject).to receive(:puts).with(I18n.t(:ask_name))
        expect(subject.setup_player).to eq(player_double)
      end

      it 'when inputed wrong name' do
        player_double.stub(:errors_store) {[I18n.t(:when_wrong_name)]}
        player_double.stub(:name) {'Gilly'}
        allow(subject).to receive_message_chain(:gets, :chomp).and_return('Gilly')
        expect(subject).to receive(:puts).with([I18n.t(:when_wrong_name)])
        expect(subject).to receive(:puts).with(I18n.t(:ask_name))
        expect(subject.setup_player).to eq(player_double)
      end
    end
  end

  describe '#setup_difficulty' do
    context 'when set level difficulty' do
      it do
        allow(subject).to receive_message_chain(:gets, :chomp).and_return(WRONG_LEVEL_DIF,'easy')
        expect(subject).to receive(:puts).with(I18n.t(:select_difficulty)).exactly(3).times
        expect(subject.setup_difficulty).to eq('easy')
        subject.setup_difficulty
      end
    end
  end

  describe '.input' do
    context 'when input value' do
      it 'while play game' do
        allow(subject).to receive_message_chain(:gets, :chomp).and_return('snegurka')
        expect(subject.send(:input)).to eq('snegurka')
      end

      it 'when want to exit' do
        allow(subject).to receive_message_chain(:gets, :chomp).and_return('exit')
        expect(subject.send(:input)).to eq(exit)
      end
    end
  end
end
