require 'rails_helper'

RSpec.describe JwtService do
  let(:payload) { { user_id: 1, role: 'admin' } }

  describe '.encode / .decode' do
    it 'encode แล้ว decode กลับได้ถูกต้อง' do
      token   = JwtService.encode(payload)
      decoded = JwtService.decode(token)

      expect(decoded[:user_id]).to eq(1)
      expect(decoded[:role]).to eq('admin')
    end

    it 'decode token ปลอมแล้ว raise AuthenticationError' do
      expect {
        JwtService.decode('fake.token.here')
      }.to raise_error(AuthenticationError)
    end
  end
end
