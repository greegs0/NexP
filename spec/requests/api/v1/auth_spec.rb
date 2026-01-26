require 'rails_helper'

RSpec.describe 'Api::V1::Auth', type: :request do
  describe 'POST /api/v1/auth/login' do
    let!(:user) { create(:user, email: 'test@example.com', password: 'password123') }

    context 'with valid credentials' do
      it 'returns a JWT token' do
        post '/api/v1/auth/login', params: {
          email: 'test@example.com',
          password: 'password123'
        }

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['token']).to be_present
        expect(json['user']['email']).to eq('test@example.com')
        expect(json['expires_at']).to be_present
      end
    end

    context 'with invalid credentials' do
      it 'returns unauthorized error' do
        post '/api/v1/auth/login', params: {
          email: 'test@example.com',
          password: 'wrongpassword'
        }

        expect(response).to have_http_status(:unauthorized)
        json = JSON.parse(response.body)
        expect(json['error']).to be_present
      end
    end

    context 'with non-existent email' do
      it 'returns unauthorized error' do
        post '/api/v1/auth/login', params: {
          email: 'nonexistent@example.com',
          password: 'password123'
        }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /api/v1/auth/signup' do
    context 'with valid data' do
      it 'creates a new user and returns a token' do
        expect {
          post '/api/v1/auth/signup', params: {
            user: {
              email: 'newuser@example.com',
              password: 'password123',
              password_confirmation: 'password123',
              username: 'newuser',
              name: 'New User'
            }
          }
        }.to change(User, :count).by(1)

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json['token']).to be_present
        expect(json['user']['email']).to eq('newuser@example.com')
        expect(json['user']['username']).to eq('newuser')
      end
    end

    context 'with invalid data' do
      it 'returns unprocessable entity error' do
        post '/api/v1/auth/signup', params: {
          user: {
            email: 'invalid',
            password: '123'
          }
        }

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['error']).to be_present
        expect(json['details']).to be_present
      end
    end

    context 'with duplicate email' do
      let!(:existing_user) { create(:user, email: 'existing@example.com') }

      it 'returns validation error' do
        post '/api/v1/auth/signup', params: {
          user: {
            email: 'existing@example.com',
            password: 'password123',
            password_confirmation: 'password123',
            username: 'newuser'
          }
        }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
