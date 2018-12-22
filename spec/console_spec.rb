RSpec.describe Console do
  CHOOSE_ACTION = "Choose actions: start, rules, stats or exit\n"
  PLAYER_NAME = 'Gilly'
  POSITIVE_NUMBER = 2
  NOT_POSITIVE_NUMBER = 0
  let(:player_double) {double('Player', name: PLAYER_NAME)}
  let(:game_double) {double('Game', difficulty: 'easy', attempts_total: 10, attempts_used: 2, hints_total: 2, hints_used: 4, try: [1], attempts_left: 5, winner: true, name: PLAYER_NAME)}
  let(:processhelper_double) {double('ProcessHelper', setup_difficulty: 'easy', setup_player: player_double)}
  # let(:console_double) { double('Console',process_helper: processhelper_double, set_game: game_double)}
  let(:statistics_double) { double('Statistics', winners: []) }

  subject { described_class.new(process_helper: processhelper_double, set_game: game_double, statistics: statistics_double) }
  describe '#new' do
    context 'start' do
      it { expect(subject.instance_variable_get(:@process_helpers)).to eq(processhelper_double) }
      it { expect(subject.instance_variable_get(:@game)).to eq(game_double) }
    end
  end

  describe '.process' do
   context do
     it do
       subject.instance_variable_set(:@process_helpers, processhelper_double)
       expect(subject.instance_variable_get(:@process_helpers)).to receive(:setup_player)
       expect(subject.instance_variable_get(:@process_helpers)).to receive(:setup_difficulty)
       # expect(subject.instance_variable_get(:@player)).to eq(player_double)
       # expect(subject.instance_variable_get(:@difficulty)).to eq('easy')
       expect(subject).to receive(:set_game_options)
       expect(subject).to receive(:play_game)
       subject.send(:process)
      end
    end
  end

  describe '.set_game_options' do
    context 'pre game settings' do
      it do
        subject.instance_variable_set(:@game, game_double)
        expect(subject.instance_variable_get(:@game)).to receive(:game_options)
        subject.send(:set_game_options, 'easy', player_double)
      end
    end
  end

  describe '#choose_action' do
    before { allow(subject).to receive(:process) }
    context 'when call process' do
      it do
        allow(subject).to receive(:input).and_return('start')
        expect(subject).to receive(:process)
        subject.choose_action
      end
    end

    context 'when call rules' do
      it do
        allow(subject).to receive(:input).and_return('rules', 'start')
        expect(subject).to receive(:show_rules)
        expect(subject).to receive(:process)
        subject.choose_action
      end
    end

    context 'with call statistics' do
      it do
        allow(subject).to receive(:input).and_return('stats', 'start')
        expect(subject).to receive(:statistics)
        subject.choose_action
      end
    end

    context 'with invalid input actions' do
      it do
        allow(subject).to receive_message_chain(:gets, :chomp).and_return('staawdawdts', 'start')
        allow(subject).to receive(:process)
        expect(subject).to receive(:puts).with(I18n.t(:greeting))
        expect(subject).to receive(:puts).with(CHOOSE_ACTION).twice
        expect(subject).to receive(:puts).with(I18n.t(:wrong_input_action))
        subject.choose_action
      end
    end
  end

  describe '.play game' do
    context 'when input hint' do
      it do
        game_double.stub(:errors) {[]}
        game_double.stub(:try) {[1]}
        allow(subject).to receive_message_chain(:gets, :chomp).and_return('hint', 'exit')
        allow(subject).to receive(:validate_game_state).and_return(false)
        expect(subject).to receive(:puts).with(I18n.t(:in_process))
        expect(subject).to receive(:puts).with('1')
        expect(subject).to receive(:result_decision)
        subject.send(:play_game)
      end
    end

    context 'when intut is wrong' do
      it do
        game_double.stub(:errors) {[I18n.t(:when_incorrect_guess)]}
        game_double.stub(:try) {nil}
        allow(subject).to receive_message_chain(:gets, :chomp).and_return('something herny', 'exit')
        allow(subject).to receive(:validate_game_state).and_return(false)
        expect(subject).to receive(:puts).with(I18n.t(:in_process))
        expect(subject).to receive(:puts).with([I18n.t(:when_incorrect_guess)])
        expect(subject).to receive(:result_decision)
        subject.send(:play_game)
      end
    end

    context 'when intut right' do
      it do
        game_double.stub(:errors) {[]}
        game_double.stub(:try) {['+','+','+','+']}
        # game_double.stub(:winner) {true}
        allow(subject).to receive_message_chain(:gets, :chomp).and_return('1234', 'exit')
        allow(subject).to receive(:validate_game_state).and_return(false)
        expect(subject).to receive(:puts).with(I18n.t(:in_process))
        expect(subject).to receive(:puts).with('++++')
        expect(subject).to receive(:result_decision)
        subject.send(:play_game)
      end
    end

    context 'when have not hints' do
      it do
        game_double.stub(:errors) {[I18n.t(:when_no_hints)]}
        game_double.stub(:try) {false}
        allow(subject).to receive_message_chain(:gets, :chomp).and_return('hint', 'exit')
        allow(subject).to receive(:validate_game_state).and_return(false)
        expect(subject).to receive(:puts).with(I18n.t(:in_process))
        expect(subject).to receive(:puts).with([I18n.t(:when_no_hints)])
        expect(subject).to receive(:result_decision)
        subject.send(:play_game)
      end
    end
  end

  describe '.lose' do
    context 'when lose the game' do
      it do
        expect(subject).to receive(:puts).with(I18n.t(:when_lose))
        expect(subject).to receive(:new_process)
        subject.send(:loser)
      end
    end
  end

  describe '.validate_game_state' do
    context 'when player still guess' do
      it do
        game_double.stub(:attempts_left) {POSITIVE_NUMBER}
        game_double.stub(:winner) {nil}
        expect(subject.send(:validate_game_state)).to eq(true)
      end
    end

    context 'when player can`t guess more' do
      it do
        game_double.stub(:attempts_left) {NOT_POSITIVE_NUMBER}
        game_double.stub(:winner) {true}
        expect(subject.send(:validate_game_state)).to eq(false)
      end
    end
  end

  describe '.result_decision' do
    context 'when player win' do
      it do
        game_double.stub(:winner) {true}
        expect(subject).to receive(:winner)
        subject.send(:result_decision)
      end

      it do
        game_double.stub(:winner) {false}
        expect(subject).to receive(:loser)
        subject.send(:result_decision)
      end
    end
  end

  describe '.winner(@game)' do
    let(:player_game) {game_double}
    context 'when player win ,action' do
      it 'agree to save to db' do
        allow(subject).to receive_message_chain(:gets, :chomp).and_return('y')
        expect(subject).to receive(:puts).with(I18n.t(:when_win))
        expect(subject).to receive(:save_to_db)
        expect(subject).to receive(:new_process)
        subject.send(:winner, player_game)
      end

      it 'dissable to save to db' do
        allow(subject).to receive_message_chain(:gets, :chomp).and_return('')
        expect(subject).to receive(:puts).with(I18n.t(:when_win))
        expect(subject).to receive(:new_process)
        subject.send(:winner, player_game)
      end
    end
  end

  describe '.leave' do
    context 'when leave codebreaker' do
      it do
        expect(subject).to receive(:puts).with(I18n.t(:leave))
        expect(subject).to receive(:exit)
        subject.send(:leave)
      end
    end
  end

  describe '.new_process' do
    context 'when new game' do
      it do
        # console_double.stub(:choose_action) {true}
        # expect(subject).to receive_message_chain(:Console, :new, :choose_action)
        # subject.send(:new_process)
      end
    end
  end

  describe '#statistics' do
    before do
      allow(subject).to receive(:choose_action)
      subject.instance_variable_set(:@stats, statistics_double)
    end
    context 'when with_not_empty_db' do
      it do
        # statistics_double.stub(:winners) {[]}
        allow(subject).to receive(:load_db)
        expect(subject.instance_variable_get(:@stats)).to receive(:winners)
        expect(subject).to receive(:show)
        subject.send(:statistics)
      end
    end
  end
end

RSpec.describe Statistics do
  subject { described_class.new }
  let(:game_double) {instance_double('Game', name: 'Moroz', difficulty: 'easy', attempts_total: 10, attempts_used: 2, hints_total: 2, hints_used: 4)}
  describe '#winners' do
    context 'show winners table' do
      it do
        expect(subject.send(:multi_sort, [game_double])).to be_an_instance_of(Array)
        expect(subject.send(:to_table, [game_double])).to be_an_instance_of(Array)
        expect(subject.send(:to_table, [game_double])).to be_an_instance_of(Array)
        subject.winners([game_double])
      end
    end
  end
end
