# frozen_string_literal: true

RSpec.describe Hammerhead::Configuration do
  describe '#validate!' do
    context 'missing configuration file' do
      xit 'raises an Error' do
        expect { subject.validate! }.to raise_error Hammerhead::Error
      end
    end

    context 'with configuration file' do
      let(:config) { subject.config }

      before do
        config.append_path fixtures_path
      end

      context 'missing harvest information' do
        before do
          allow(config).to receive :fetch
        end

        it 'raises an Error' do
          expect { subject.validate! }.to raise_error Hammerhead::Error
        end
      end

      context 'missing harvest subdomain' do
        before do
          allow(subject).to receive :subdomain
        end

        it 'raises an Error' do
          expect { subject.validate! }.to raise_error Hammerhead::Error
        end
      end

      context 'missing harvest username' do
        before do
          allow(subject).to receive :username
        end

        it 'raises an Error' do
          expect { subject.validate! }.to raise_error Hammerhead::Error
        end
      end

      context 'missing harvest password' do
        before do
          allow(subject).to receive :password
        end

        it 'raises an Error' do
          expect { subject.validate! }.to raise_error Hammerhead::Error
        end
      end
    end
  end

  describe '#subdomain' do
    let(:config) { subject.config }

    before do
      config.append_path fixtures_path
      subject.validate!
    end

    xit 'is present after validation' do
      expect(subject.subdomain).to eq 'SET_ME'
    end
  end

  describe '#username' do
    let(:config) { subject.config }

    before do
      config.append_path fixtures_path
      subject.validate!
    end

    xit 'is present after validation' do
      expect(subject.username).to eq 'SET_ME'
    end
  end

  describe '#password' do
    let(:config) { subject.config }

    before do
      config.append_path fixtures_path
      subject.validate!
    end

    xit 'is present after validation' do
      expect(subject.password).to eq 'SET_ME'
    end
  end
end
