require 'test_helper'

class DocBasesControllerTest < ActionController::TestCase
  setup do
    @doc_basis = doc_bases(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:doc_bases)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create doc_basis" do
    assert_difference('DocBase.count') do
      post :create, :doc_basis => @doc_basis.attributes
    end

    assert_redirected_to doc_basis_path(assigns(:doc_basis))
  end

  test "should show doc_basis" do
    get :show, :id => @doc_basis.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @doc_basis.to_param
    assert_response :success
  end

  test "should update doc_basis" do
    put :update, :id => @doc_basis.to_param, :doc_basis => @doc_basis.attributes
    assert_redirected_to doc_basis_path(assigns(:doc_basis))
  end

  test "should destroy doc_basis" do
    assert_difference('DocBase.count', -1) do
      delete :destroy, :id => @doc_basis.to_param
    end

    assert_redirected_to doc_bases_path
  end
end
