class DummyClass
end
RSpec.describe Statistics do
PLAYER_NAME = 'Gosha'
let(:dase_double) {instance_double('Database', name: 'Moroz', player: PLAYER_NAME)}
let(:dummy_class) do
  Class.new do
    extend Database
    extend Statistics
  end
end
  describe '#winners' do
    context 'show winners table' do
      it do
        expect(dummy_class.send(:multi_sort))
        expect(dummy_class.send(:to_table))
        expect(dummy_class.send(:table))
        # expect(dummy_class).to receive(:multi_sort).with(load_db)
        # expect(dummy_class).to receive(:to_table).with(load_db)
        dummy_class.winners(load_db)
      end
    end
  end
end
