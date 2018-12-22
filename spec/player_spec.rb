RSpec.describe Player do
  let(:player) { described_class.new }
  let(:max_input) {'I'*20}
  let(:less_t_min_input) {'I'*2}
  let(:more_t_max_input) {'I'*21}

  describe '#assign_name(input)' do
    context 'with right pass name' do
      it do
        allow(player.send(:assign_name, max_input))
        expect(player.send(:validate_name, max_input)).to eq(true)
        expect(player.instance_variable_get(:@errors_store)).to eq([])
      end
    end

    context 'with wrong pass name' do
      it do
        allow(player.send(:assign_name, less_t_min_input))
        expect(player.instance_variable_get(:@errors_store)).to eq([I18n.t(:when_wrong_name) ])
        expect(player.send(:validate_name, less_t_min_input)).to eq(false)
      end
    end

    context 'with wrong pass name' do
      it do
        allow(player.send(:assign_name, more_t_max_input))
        expect(player.instance_variable_get(:@errors_store)).to eq([I18n.t(:when_wrong_name) ])
        expect(player.send(:validate_name, more_t_max_input)).to eq(false)
      end
    end
  end
end
