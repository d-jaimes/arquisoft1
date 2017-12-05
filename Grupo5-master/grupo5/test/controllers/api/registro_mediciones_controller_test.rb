require 'test_helper'

class Api::RegistroMedicionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    # Crear objetos para prueba.
    @registro_medicion1 = Api::RegistroMedicion.new(tipo: "Temperatura", unidad: "C", valor: 28)
    @registro_medicion2 = Api::RegistroMedicion.new(tipo: "Lux", unidad: "lux", valor: 12)
  end

  test "should get index" do
    # Deberia dar todos los datos existente sin error.
    get api_registro_mediciones_url
    assert_response :success
  end

  test "should create api_registro_medicion" do
    # Deberia crear objeto si vienen los datos correctos.
    assert_difference('Api::RegistroMedicion.count') do
      post api_registro_mediciones_url, params: { registro_medicion: { tipo: @registro_medicion1.tipo, unidad: @registro_medicion1.unidad, valor: @registro_medicion1.valor } }
    end

    assert_response :success

    json_response = JSON.parse(@response.body)
    assert_equal "Temperatura", json_response['tipo']
    assert_equal "C", json_response['unidad']
    assert_equal 28, json_response['valor']

    # No deberia guardar con datos faltantes.
    post api_registro_mediciones_url, params: { registro_medicion: { tipo: nil, unidad: @registro_medicion1.unidad, valor: @registro_medicion1.valor } }
    assert_response :unprocessable_entity

    post api_registro_mediciones_url, params: { registro_medicion: { tipo: @registro_medicion1.tipo, unidad: nil, valor: @registro_medicion1.valor } }
    assert_response :unprocessable_entity

    post api_registro_mediciones_url, params: { registro_medicion: { tipo: @registro_medicion1.tipo, unidad: @registro_medicion1.unidad, valor: nil } }
    assert_response :unprocessable_entity
  end

  test "should show api_registro_medicion" do
    # Si se crea objeto deberia ser posible poder buscarlo.
    assert_difference('Api::RegistroMedicion.count') do
      post api_registro_mediciones_url, params: { registro_medicion: { tipo: @registro_medicion2.tipo, unidad: @registro_medicion2.unidad, valor: @registro_medicion2.valor } }
    end
    assert_response :success
    json_response = JSON.parse(@response.body)

    model_id = { id: json_response["_id"]["$oid"]}

    get api_registro_medicion_url(model_id)
    assert_response :success

    json_response = JSON.parse(@response.body)
    assert_equal "Lux", json_response['tipo']
    assert_equal "lux", json_response['unidad']
    assert_equal 12, json_response['valor']

  end


  test "should destroy api_registro_medicion" do
    # Si se crea objeto deberia ser posible poder eliminarlo.
    assert_difference('Api::RegistroMedicion.count') do
      post api_registro_mediciones_url, params: { registro_medicion: { tipo: @registro_medicion1.tipo, unidad: @registro_medicion1.unidad, valor: @registro_medicion1.valor } }
    end
    assert_response :success
    json_response = JSON.parse(@response.body)

    model_id = { id: json_response["_id"]["$oid"]}

    assert_difference('Api::RegistroMedicion.count', -1) do
      delete api_registro_medicion_url(model_id)
    end
  end
end
