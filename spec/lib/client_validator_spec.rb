require 'rails_helper'

describe ClientValidator do
  describe '#phone_number_is_unused' do
    let(:client) { build :client, phone_number: '1234' }
    let(:validator) { ClientValidator.new }

    subject { validator.validate(client) }

    it 'is valid if phone number is unique' do
      subject
      expect(client.errors).to be_empty
    end

    context 'client is associated with a different department' do
      before do
        create :client, phone_number: '1234'
      end

      it 'is invalid' do
        subject
        expect(client.errors.added?(:phone_number, :taken)).to eq(true)
      end
    end

    context 'the client is already associated with the current user' do
      let(:current_user) { create :user }
      before do
        existing_client = create :client, phone_number: '1234'
        existing_client.users << current_user
      end

      it 'specifies on the error that the association exists' do
        subject
        expect(client.errors.added?(:phone_number, :taken_by_user)).to eq(true)
      end
    end
  end
end
