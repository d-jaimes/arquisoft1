class Api::Alert
  include Mongoid::Document
  include Mongoid::Timestamps

  # 0 Alerta fuera de linea
  # 1 Alerta fuera de rango
  # 2 Actuador ineficiente
  field :tipo, type: Integer
  field :mensaje, type: String

  belongs_to :microcontrolador, :class_name => 'Api::Microcontrolador'
end
