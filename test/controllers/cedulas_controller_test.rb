require 'test_helper'

class CedulasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cedula = cedulas(:one)
  end

  test "should get index" do
    get cedulas_url
    assert_response :success
  end

  test "should get new" do
    get new_cedula_url
    assert_response :success
  end

  test "should create cedula" do
    assert_difference('Cedula.count') do
      post cedulas_url, params: { cedula: { cedula_number: @cedula.cedula_number, cedula_type: @cedula.cedula_type, gender: @cedula.gender, institution: @cedula.institution, last_name_1: @cedula.last_name_1, last_name_2: @cedula.last_name_2, name: @cedula.name, title: @cedula.title, year: @cedula.year } }
    end

    assert_redirected_to cedula_url(Cedula.last)
  end

  test "should show cedula" do
    get cedula_url(@cedula)
    assert_response :success
  end

  test "should get edit" do
    get edit_cedula_url(@cedula)
    assert_response :success
  end

  test "should update cedula" do
    patch cedula_url(@cedula), params: { cedula: { cedula_number: @cedula.cedula_number, cedula_type: @cedula.cedula_type, gender: @cedula.gender, institution: @cedula.institution, last_name_1: @cedula.last_name_1, last_name_2: @cedula.last_name_2, name: @cedula.name, title: @cedula.title, year: @cedula.year } }
    assert_redirected_to cedula_url(@cedula)
  end

  test "should destroy cedula" do
    assert_difference('Cedula.count', -1) do
      delete cedula_url(@cedula)
    end

    assert_redirected_to cedulas_url
  end
end
