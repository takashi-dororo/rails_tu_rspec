# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do
  describe 'GET root_path' do
    it 'returns http success' do
      get :home
      expect(response).to be_successful
    end
  end

  describe 'GET help_path' do
    it 'returns http success' do
      get :help
      expect(response).to be_successful
    end
  end

  describe 'GET about_path' do
    it 'returns http success' do
      get :about
      expect(response).to be_successful
    end
  end

  describe 'GET contact_path' do
    it 'returns http success' do
      get :contact
      expect(response).to be_successful
    end
  end
end
