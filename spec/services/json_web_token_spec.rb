require 'rails_helper'

RSpec.describe JsonWebToken, type: :service do
  describe '.encode' do
    it 'returns a JWT token string' do
      token = JsonWebToken.encode({ user_id: 1 })
      expect(token).to be_a(String)
      expect(token.split('.').length).to eq(3) # JWT has 3 parts
    end

    it 'encodes the payload' do
      payload = { user_id: 123, name: 'Test' }
      token = JsonWebToken.encode(payload)
      decoded = JsonWebToken.decode(token)

      expect(decoded[:user_id]).to eq(123)
      expect(decoded[:name]).to eq('Test')
    end

    it 'sets default expiration to 24 hours' do
      token = JsonWebToken.encode({ user_id: 1 })
      decoded = JsonWebToken.decode(token)

      # Expiration should be approximately 24 hours from now
      expected_exp = 24.hours.from_now.to_i
      expect(decoded[:exp]).to be_within(5).of(expected_exp)
    end

    it 'allows custom expiration' do
      custom_exp = 1.hour.from_now
      token = JsonWebToken.encode({ user_id: 1 }, custom_exp)
      decoded = JsonWebToken.decode(token)

      expect(decoded[:exp]).to eq(custom_exp.to_i)
    end
  end

  describe '.decode' do
    it 'decodes a valid token' do
      payload = { user_id: 42 }
      token = JsonWebToken.encode(payload)
      decoded = JsonWebToken.decode(token)

      expect(decoded[:user_id]).to eq(42)
    end

    it 'returns HashWithIndifferentAccess' do
      token = JsonWebToken.encode({ user_id: 1 })
      decoded = JsonWebToken.decode(token)

      expect(decoded).to be_a(HashWithIndifferentAccess)
      expect(decoded[:user_id]).to eq(decoded['user_id'])
    end

    it 'returns nil for invalid token' do
      result = JsonWebToken.decode('invalid.token.here')
      expect(result).to be_nil
    end

    it 'returns nil for expired token' do
      token = JsonWebToken.encode({ user_id: 1 }, 1.second.ago)
      result = JsonWebToken.decode(token)

      expect(result).to be_nil
    end

    it 'returns nil for tampered token' do
      token = JsonWebToken.encode({ user_id: 1 })
      tampered_token = token[0...-5] + 'XXXXX' # Modify last 5 chars

      result = JsonWebToken.decode(tampered_token)
      expect(result).to be_nil
    end

    it 'returns nil for empty string' do
      result = JsonWebToken.decode('')
      expect(result).to be_nil
    end

    it 'returns nil for nil input' do
      # JWT.decode with nil will raise an error, which is rescued
      result = JsonWebToken.decode(nil)
      expect(result).to be_nil
    end
  end

  describe 'SECRET_KEY' do
    it 'is defined' do
      expect(JsonWebToken::SECRET_KEY).not_to be_nil
    end

    it 'uses credentials secret_key_base' do
      expect(JsonWebToken::SECRET_KEY).to eq(
        Rails.application.credentials.secret_key_base || Rails.application.secrets.secret_key_base
      )
    end
  end

  describe 'token integrity' do
    it 'different payloads produce different tokens' do
      token1 = JsonWebToken.encode({ user_id: 1 })
      token2 = JsonWebToken.encode({ user_id: 2 })

      expect(token1).not_to eq(token2)
    end

    it 'same payload produces consistent decode' do
      original_payload = { user_id: 100, role: 'admin' }
      token = JsonWebToken.encode(original_payload)

      5.times do
        decoded = JsonWebToken.decode(token)
        expect(decoded[:user_id]).to eq(100)
        expect(decoded[:role]).to eq('admin')
      end
    end
  end
end
