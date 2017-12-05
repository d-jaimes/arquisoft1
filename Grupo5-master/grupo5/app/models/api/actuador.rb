class Api::Actuador
  include Mongoid::Document
  field :estado, type: Boolean

  belongs_to :microcontrolador, :class_name => 'Api::Microcontrolador'
  belongs_to :variable_ambiental, :class_name => 'Api::VariableAmbiental'
end
