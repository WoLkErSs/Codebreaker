

RSpec.describe Game do

  let(:name) {'papa'}
  let(:hints) {2}
  let(:attempts) {5}
  let(:difficulty) {'easy'}
  let(:current_subject) { described_class.new(name: 'papa', hints: 2, attempts: 5, difficulty: 'easy') }
  after do
    current_subject.process
  end
    it 'should have hints' do
      expect(current_subject.name).to eq(name)
    end
    describe '#process' do
      it 'have to respond to process' do
        expect(current_subject).to receive(:create_secter_code)
      end

      it 'have to respond to one_iterate' do
        expect(current_subject).to receive(:one_iterate)
        current_subject.one_iterate
      end

    end
      #it 'create account if input is create' do
      #  allow(current_subject).to receive_message_chain(:gets, :chomp) { 'create' }
      #  expect(current_subject).to receive(:create)
      #end
end
# RSpec.describe Console do
#   it 'it should show greeting' do
#     con = Console.new
#     expect(con.revoke).to eq(nil)
#   end
#
#   describe '#benig_game' do
#     before do
#       allow(Console) to receive( :choose_action('start') )
#       and_return({name: 'Ivan', hints: 2, attempts: 2, difficulty: 'easy'})
#     end
#
#     # context 'when win' do
#     #   let(:console) {Console.new}
#     #
#     #   it 'game must run' do
#     #
#     #   end
#     # end
#   end
#  end
