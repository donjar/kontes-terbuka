require 'test_helper'

class AboutUsersControllerTest < ActionController::TestCase
  setup :login_and_be_admin, :create_items

  test 'routes' do 
    assert_equal user_about_user_path(@user),
      "/users/#{@user.to_param}/about-user"
    assert_equal edit_user_about_user_path(@user),
      "/users/#{@user.to_param}/about-user/edit"
  end

  test 'create' do
    test_abilities @about_user, :create, [nil], %i[admin]
    post :create, user_id: @user.id, about_user: {
      name: 'Test_create',
      description: 'Test',
      is_alumni: '0',
    }

    assert_redirected_to user_path(@user)
  end

  test 'edit' do
    test_abilities @about_user, :edit, [nil], %i[admin]
    get :edit, user_id: @user.id
    assert_response 200
  end

  test 'patch update' do
    test_abilities @about_user, :update, [nil], %i[admin]
    patch :update, user_id: @user.id, about_user: { 
      name: 'TestUpdate',
      description: 'Test',
      is_alumni: '1',
    }
    assert_redirected_to user_path(@user)
  end

  test 'put update' do
    test_abilities @about_user, :update, [nil], %i[admin]
    patch :update, user_id: @user.id, about_user: { 
      name: 'TestUpdate',
      description: 'Test',
      is_alumni: '1',
    }
    assert_redirected_to user_path(@user)
  end

  def create_items
    @about_user = create(:about_user)
    @user = @about_user.user
  end
end
