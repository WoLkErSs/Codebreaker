RSpec.describe Game do
  PLAYER_NAME = 'Ivan'
  DIFFICULTY = {
                'easy': {attempts: 15, hints: 2, difficulty: 'easy'},
                'hard': {attempts: 10, hints: 2, difficulty: 'hard'},
                'expert': {attempts: 5, hints: 1, difficulty: 'expert'}}.freeze

  let(:player_double) {class_double('Player', PLAYER_NAME)}
  let(:difficulty) {DIFFICULTY[:easy][:difficulty]}
  let(:game) {described_class.new(user_difficulty: difficulty, player: player_double)}
  describe '#new' do

    context 'start game' do
      it { expect(game.errors).to eq([]) }
      it { expect(game.hints_used).to eq(0) }
      it { expect(game.attempts_used).to eq(0) }

      it do
        receiver = double("secret_code")
        receiver.stub(:secret_code) { [1, 2, 3, 4] }
        receiver.secret_code.should eq([1, 2, 3, 4])
      end

      it do
        receiver = double(PLAYER_NAME)
        receiver.stub(:name) { PLAYER_NAME }
        receiver.name.should eq(PLAYER_NAME)
      end

      it do
        game.send(:assign_difficulty, DIFFICULTY[:easy])
        expect(game.instance_variable_get(:@attempts_total)).to eq(15)
        expect(game.instance_variable_get(:@hints_total)).to eq(2)
        expect(game.instance_variable_get(:@attempts_left)).to eq(15)
        expect(game.instance_variable_get(:@difficulty)).to eq('easy')
      end
    end
  end

  describe '#try' do
    let(:hint) {'hint'}
    let(:user_code) {'1234'}
    let(:wrong_input) {'12wda34'}
    context 'in play' do
      it do
        game.try(hint)
        expect(game.send(:use_hint))
        allow(game.instance_variable_set(:@hints_total, 2))
        allow(game.instance_variable_set(:@hints_used, 2))
        allow(game.instance_variable_set(:@arr_for_hints, [1, 2, 3, 4]))
        expect {game.try(hint)}.to change{game.hints_total}.by(-1)
        expect {game.try(hint)}.to change{game.hints_used}.by(1)
      end

      it do
        game.try(hint)
        allow(game.instance_variable_set(:@hints_total, 0))
        expect(game.send(:use_hint)).to eq(false)
        expect(game.instance_variable_get(:@errors)).to eq([I18n.t(:when_no_hints)])
      end

      it do
        expect {game.try(user_code)}.to change{game.attempts_left}.by(-1)
        expect {game.try(user_code)}.to change{game.attempts_used}.by(1)
      end

      it do
        game.try(wrong_input)
        allow(game).to receive(:try).with(wrong_input)
        expect(game.send(:check_input, wrong_input))
      end
    end
  end
end
