require 'test_helper'

class Api::RegistroMedicionTest < ActiveSupport::TestCase
  test "should_create_registro" do
    # No se puede guardar sin datos.
    @registro = Api::RegistroMedicion.new
    assert_not @registro.save

    # No se puede guardar con datos faltantes.
    @registro = Api::RegistroMedicion.new(valor: nil, tipo: "Temperatura", unidad: "C")
    assert_not @registro.save

    @registro = Api::RegistroMedicion.new(valor: 28, tipo: nil, unidad: "C")
    assert_not @registro.save

    @registro = Api::RegistroMedicion.new(valor: 28, tipo: "Temperatura", unidad: nil)
    assert_not @registro.save

    # Se tiene que guardar si se envian los datos correctos y completos.
    assert_difference('Api::RegistroMedicion.count') do
      @registro = Api::RegistroMedicion.new(valor: 28, tipo: "Temperatura", unidad: "C")
      assert @registro.save
    end
  end

  test "should_find_registro" do
    # Buscar existente.
    assert_difference('Api::RegistroMedicion.count') do
      @registro = Api::RegistroMedicion.new(valor: 28, tipo: "Temperatura", unidad: "C")
      assert @registro.save
    end

    assert_not_nil Api::RegistroMedicion.where(_id: @registro._id).first

    # Buscar no existente.
    assert_nil Api::RegistroMedicion.where(_id: "id inventado").first
  end

  test "should_delete_registro" do
    # Eliminar existente.
    @registro = Api::RegistroMedicion.new(valor: 28, tipo: "Temperatura", unidad: "C")
    @registro.save

    assert_difference('Api::RegistroMedicion.count', -1) do
      @registro.destroy
    end
  end
end
