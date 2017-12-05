class Api::Microcontrolador
  include Mongoid::Document
  field :nivel, type: Integer
  field :area, type: Integer

  has_many :alerts, :class_name => 'Api::Alert'
  has_many :actuadores, :class_name => 'Api::Actuador'
  has_many :registros_medicion, :class_name => 'Api::RegistroMedicion'
end
