# frozen_string_literal: true

require 'rspec'
require_relative '../rails_helper'

describe 'Rate' do
  subject { Currency.create(name: 'RON') }

  let(:date_now) { DateTime.parse('2022-01-01').strftime '%Y-%m-%d' }

  before do
    subject.rates.create(date: date_now, value: 1, ref_currency_id: subject.id)
  end

  after do
    # Do nothing
  end

  context 'when calling #all method' do
    it 'returns 1 rate' do
      rates = subject.rates.all

      expect(rates.length).to eql(1)
    end
  end

  context 'when validating the data' do
    it 'fails validation nothing is given' do
      rate = Rate.new

      expect(rate.valid?).to be_falsey
    end

    it 'passes validation when Rate has value' do
      rate = Rate.new(date: date_now, value: 1, currency: subject, ref_currency: subject)

      expect(rate.valid?).to be_truthy
    end
  end
end
