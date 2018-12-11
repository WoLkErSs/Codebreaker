RSpec.describe Test do
  let(:current_subject) { described_class.new }
  describe '#puts' do

    it do
      allow(current_subject).to receive(:coco).and_return('lolol')
      # current_subject.stub(:puts) { 'lolol' }
      expect(current_subject.coco).to eq('lolol')
    end
  end
end
