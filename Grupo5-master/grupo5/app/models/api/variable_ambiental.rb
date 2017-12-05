class Api::VariableAmbiental

  include Mongoid::Document

  field :tipo, type: String
  field :valorMaximo, type: Float
  field :valorMinimo, type: Float
  field :unidad, type: String
  field :variacionDiaria, type: Float
  field :precision, type: Float
  field :frecuencia, type: Integer

  has_many :registro_medicion, :class_name => 'Api::RegistroMedicion'
  has_many :actuadores, :class_name => 'Api::Actuador'
end
