class Class
end
RSpec.describe Statistics do
PLAYER_NAME = 'Gosha'
let(:dummy_class) { Class.new do
  extend Statistics
  extend Database
end }
let(:dase_double) {instance_double('Database', name: 'Moroz', player: PLAYER_NAME)}
  describe '#winners' do
    context 'show winners table' do
      it do
        expect(dummy_class.send(:multi_sort, load_db)).to be_an_instance_of(Array)
        # expect(dummy_class.send(:to_table))
        # expect(dummy_class.send(:table))
        # expect(dummy_class).to receive(:multi_sort).with(load_db)
        # expect(dummy_class).to receive(:to_table).with(load_db)
        dummy_class.winners(load_db)
      end
    end
  end
end
