RSpec.describe Game do
  PLAYER_NAME = 'Gilly'
  DIFFICULTY = {
                'easy': {attempts: 15, hints: 2, difficulty: 'easy'},
                'hard': {attempts: 10, hints: 2, difficulty: 'hard'},
                'expert': {attempts: 5, hints: 1, difficulty: 'expert'}}.freeze

  let(:player_double) {class_double('Player', PLAYER_NAME)}
  let(:difficulty) {DIFFICULTY[:easy][:difficulty]}
  subject {described_class.new}
  describe '#new' do

    context 'start Game' do
      it { expect(subject.hints_used).to eq(0) }
      it { expect(subject.attempts_used).to eq(0) }

      it do
        receiver = double("secret_code")
        receiver.stub(:secret_code) { [1, 2, 3, 4] }
        receiver.secret_code.should eq([1, 2, 3, 4])
      end
    end
  end

  describe '#game_options' do
    context 'set options game' do
      it do
        expect(subject).to receive(:assign_difficulty)
        subject.game_options(user_difficulty: 'easy', player: player_double)
      end
    end
  end
  describe '.assign_difficulty' do
    context 'assign settings' do
      it do
        subject.send(:assign_difficulty, DIFFICULTY[:easy])
        expect(subject.instance_variable_get(:@attempts_total)).to eq(15)
        expect(subject.instance_variable_get(:@hints_total)).to eq(2)
        expect(subject.instance_variable_get(:@attempts_left)).to eq(15)
        expect(subject.instance_variable_get(:@difficulty)).to eq('easy')
      end
    end
  end

  describe '#try' do
    let(:hint) {'hint'}
    let(:user_code) {'1234'}
    let(:wrong_input) {'12wda34'}
    let(:just_input) {[4,5,6,7]}
    let(:just_input2) {[7,5,6,4]}
    let(:right_input) {['+','+','+','+']}
    context 'in play' do
      it do
        allow(subject.instance_variable_set(:@hints_total, 2))
        allow(subject.instance_variable_set(:@hints_used, 2))
        allow(subject.instance_variable_set(:@errors, []))
        allow(subject.instance_variable_set(:@arr_for_hints, [1, 2, 3, 4]))
        expect {subject.try(hint)}.to change{subject.hints_total}.by(-1)
        expect {subject.try(hint)}.to change{subject.hints_used}.by(1)
        expect(subject.send(:use_hint))
        subject.try(hint)
      end

      it do
        allow(subject.instance_variable_set(:@errors, []))
        allow(subject.instance_variable_set(:@hints_total, 0))
        expect(subject.send(:use_hint)).to eq(false)
        expect(subject.instance_variable_get(:@errors)).to eq([I18n.t(:when_no_hints)])
        subject.try(hint)
      end

      it do
        allow(subject.instance_variable_set(:@attempts_left, 2))
        allow(subject.instance_variable_set(:@attempts_used, 2))
        expect {subject.try(user_code)}.to change{subject.attempts_left}.by(-1)
        expect {subject.try(user_code)}.to change{subject.attempts_used}.by(1)
        expect(subject.instance_variable_get(:@winner)).to be(true)
        subject.try(user_code)
      end

      it do
        expect(subject.send(:verdict, just_input)).to eq(['-'])
        expect(subject.send(:verdict, just_input2)).to eq(['+'])
      end

      it do
        allow(subject).to receive(:try).with(wrong_input)
        expect(subject.send(:check_input, wrong_input))
        subject.try(wrong_input)
      end
    end
  end
end
