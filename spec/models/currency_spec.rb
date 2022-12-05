# frozen_string_literal: true

require 'rspec'
require_relative '../rails_helper'

describe 'Currency', type: :model do
  let(:date_now) { DateTime.parse('2022-01-01').strftime '%Y-%m-%d' }

  after do
    # Do nothing
  end

  context 'when calling #all method' do
    before do
      Currency.create(name: 'RON')
      Currency.create(name: 'EUR')
      Currency.create(name: 'USD')
    end

    it 'returns 3 currencies' do
      currencies = Currency.all

      expect(currencies.length).to eql(3)
    end
  end

  context 'when validating the data' do
    it 'fails validation when a Currency has no name' do
      currency = Currency.new

      expect(currency.valid?).to be_falsey
    end

    it 'passes validation when currency has name' do
      currency = Currency.new(name: 'RON')

      expect(currency.valid?).to be_truthy
    end
  end

  context 'when retrieving rates' do
    before do
      ron = Currency.new(name: 'RON')
      ron.save!

      euro = Currency.new(name: 'EUR')
      euro.save!

      euro.rates.create(date: '2022-01-01', value: 4.5, ref_currency: ron)
      euro.rates.create(date: '2022-02-02', value: 4.6, ref_currency: ron)
      euro.rates.create(date: '2022-03-03', value: 4.7, ref_currency: ron)
      euro.save!
    end

    it 'retrieves rate for base currency' do
      currency = Currency.lookup('RON')

      expect(currency.rate(DateTime.now).value).to eql(1.0)
    end

    it 'retrieve rate for current currency from given time' do
      currency = Currency.lookup('EUR')
      rate = currency.rate(DateTime.parse('2022-01-05'))

      expect(rate.value).to eql(4.5)
    end
  end
end
