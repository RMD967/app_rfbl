require "test_helper"

class DiscoversControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  describe 'index action' do
    it 'should get all discovers' do
      discover1 = create(:discover)
      discover2 = create(:discover)
      get '/discovers'
      expect(response.body).to include(discover1.content)
      expect(response.body).to include(discover2.content)
    end

    it 'should filter discovers by genre' do
      discover1 = create(:discover, genre: 'Rock')
      discover2 = create(:discover, genre: 'Pop')
      get '/discovers?genre=Rock'
      expect(response.body).to include(discover1.content)
      expect(response.body).not_to include(discover2.content)
    end
  end

  describe 'show action' do
    it 'should find the discover' do
      discover = create(:discover)
      get '/discovers/' + discover.id.to_s
      expect(response.body).to include(discover.content)
    end
  end

  describe 'new action' do
    it 'should create a new discover' do
      user = create(:user)
      sign_in user
      get '/discovers/new'
      expect(response.body).to include('New Discover')
      expect(response.body).to include('Content')
      expect(response.body).to include('Genre')
    end
  end

  describe 'create action' do
    it 'should create a new discover' do
      user = create(:user)
      sign_in user
      content = 'This is a new discover'
      genre = 'Rock'
      post '/discovers', params: { discover: { content: content, genre: genre } }
      expect(response).to redirect_to(discovers_url)
      discover = Discover.last
      expect(discover.content).to eq(content)
      expect(discover.genre).to eq(genre)
    end
  end

  describe 'destroy action' do
    it 'should destroy the discover' do
      discover = create(:discover)
      delete '/discovers/' + discover.id.to_s
      expect(Discover.exists?(discover.id)).to be false
    end
  end
end
