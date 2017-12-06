class Api::Alert
  include Mongoid::Document
  include Mongoid::Timestamps

  # 0 Alerta fuera de linea
  # 1 Alerta fuera de rango
  # 2 Actuador ineficiente
  field :tipo, type: Integer
  field :mensaje, type: String

  belongs_to :microcontrolador, :class_name => 'Api::Microcontrolador'

  def get_variable_type_as_string
    if tipo == 0
      return "Fuera de linea"
    elsif tipo == 1
      return "Fuera de rango"
    elsif tipo == 2
      return "Actuador ineficiente"
    end
  end
end
