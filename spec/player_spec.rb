RSpec.describe Player do
  let(:player) { described_class.new }
  let(:errors) { [] }
  let(:input) {'Ivan'}

  describe '#assign_name(input)' do
    before do

    end
    context 'with right pass name' do
      it do
        player.assign_name(input)
        expect(player.send(:validate_name, input)).to eq(true)
        expect(player.instance_variable_get(:@errors_store)).to eq([])
      end
    end

    context 'with wrong pass name' do
      it do
        player.assign_name('')
        expect(player.instance_variable_get(:@errors_store)).to eq([I18n.t(:when_wrong_name) ])
        expect(player.send(:validate_name, '')).to eq(false)

      end
    end
  end
end
