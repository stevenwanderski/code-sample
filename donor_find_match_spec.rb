require 'rails_helper'

describe DonorFindMatch do
  describe '#call' do
    let(:nonprofit) { create(:nonprofit) }
    let(:param_first_name) { 'Frank' }
    let(:param_last_name) { 'Zappa' }
    let(:param_address_1) { '123 Moon' }

    let(:donor_first_name) { 'Frank' }
    let(:donor_last_name) { 'Zappa' }
    let(:donor_address_1) { '123 Moon' }

    let(:params) do
      {
        first_name: param_first_name,
        last_name: param_last_name,
        address_1: param_address_1,
        nonprofit_id: nonprofit.id
      }
    end

    subject { DonorFindMatch.call(params: params) }

    context 'donor exists' do
      let!(:donor) do
        create(:donor,
          nonprofit: nonprofit,
          first_name: donor_first_name,
          last_name: donor_last_name,
          address_1: donor_address_1
        )
      end

      context 'first name' do
        context 'record contains uppercase and whitespace' do
          let(:donor_first_name) { ' FRANK ' }
          let(:param_first_name) { 'frank' }

          it 'returns the donor' do
            expect(subject.id).to eq(donor.id)
          end
        end

        context 'param contains uppercase and whitespace' do
          let(:donor_first_name) { 'frank' }
          let(:param_first_name) { ' FRANK ' }

          it 'returns the donor' do
            expect(subject.id).to eq(donor.id)
          end
        end
      end

      context 'last name' do
        context 'record contains uppercase and whitespace' do
          let(:donor_last_name) { ' ZAPPA ' }
          let(:param_last_name) { 'zappa' }

          it 'returns the donor' do
            expect(subject.id).to eq(donor.id)
          end
        end

        context 'param contains uppercase and whitespace' do
          let(:donor_last_name) { 'zappa' }
          let(:param_last_name) { ' ZAPPA ' }

          it 'returns the donor' do
            expect(subject.id).to eq(donor.id)
          end
        end

        context 'null values' do
          let(:donor_last_name) { nil }
          let(:param_last_name) { nil }

          it 'returns the donor' do
            expect(subject.id).to eq(donor.id)
          end
        end
      end

      context 'address 1' do
        context 'record contains uppercase and whitespace' do
          let(:donor_address_1) { ' 123 MOON ' }
          let(:param_address_1) { '123 moon' }

          it 'returns the donor' do
            expect(subject.id).to eq(donor.id)
          end
        end

        context 'param contains uppercase and whitespace' do
          let(:donor_address_1) { '123 moon' }
          let(:param_address_1) { ' 123 MOON ' }

          it 'returns the donor' do
            expect(subject.id).to eq(donor.id)
          end
        end

        context 'null values' do
          let(:donor_address_1) { nil }
          let(:param_address_1) { nil }

          it 'returns the donor' do
            expect(subject.id).to eq(donor.id)
          end
        end
      end
    end

    context 'donor does not exist' do
      let!(:donor) do
        create(:donor,
          nonprofit: nonprofit,
          first_name: 'Frankie',
          last_name: donor_last_name,
          address_1: donor_address_1
        )
      end

      it 'returns nil' do
        expect(subject).to eq(nil)
      end
    end
  end
end
