
RSpec.describe Hammerhead::HarvestClient do

  describe '.config' do
    let(:config) { described_class.config }

    before do
      config.append_path fixtures_path
      config.read
    end
  
      it 'is present' do
      expect(config).not_to be_nil
    end

    context 'with harvest details' do
      let(:harvest) { config.fetch(:harvest) }

      it 'defines subdomain' do
        expect(harvest['subdomain']).to eq 'SET_ME'
      end

      it 'defines username' do
        expect(harvest['username']).to eq 'SET_ME'
      end

      it 'defines password' do
        expect(harvest['password']).to eq 'SET_ME'
      end
    end
  end

  describe '#config' do
    let(:config) { subject.config }

    before do
      config.append_path fixtures_path
      config.read
    end
  
      it 'is present' do
      expect(config).not_to be_nil
    end

    context 'harvest' do
      let(:harvest) { config.fetch(:harvest) }

      it 'defines subdomain' do
        expect(harvest['subdomain']).to eq 'SET_ME'
      end

      it 'defines username' do
        expect(harvest['username']).to eq 'SET_ME'
      end

      it 'defines password' do
        expect(harvest['password']).to eq 'SET_ME'
      end
    end
  end

  describe '#authenticate!' do

    context 'missing configuration file' do
      it 'raises an Error' do
        expect { subject.authenticate! }.to raise_error Hammerhead::Error
      end
    end

    context 'with configuration file' do
      let(:config) { subject.config }

      before do
        config.append_path fixtures_path
      end
  
      it 'returns an api client' do
        expect( subject.authenticate! ).not_to be_nil
      end
  
        context 'when harvest information missing' do
        before do
          allow( config ).to receive :fetch
        end
        it 'raises an Error' do
          expect { subject.authenticate! }.to raise_error Hammerhead::Error
        end
      end

      context 'with harvest subdomain missing' do
        before do
          allow( subject ).to receive :subdomain
        end
        it 'raises an Error' do
          expect { subject.authenticate! }.to raise_error Hammerhead::Error
        end
      end

      context 'with harvest username missing' do
        before do
          allow( subject ).to receive :username
        end
        it 'raises an Error' do
          expect { subject.authenticate! }.to raise_error Hammerhead::Error
        end
      end

      context 'with harvest password missing' do
        before do
          allow( subject ).to receive :password
        end
        it 'raises an Error' do
          expect { subject.authenticate! }.to raise_error Hammerhead::Error
        end
      end
    end
  end
end
