class Api::Usuario
  include Mongoid::Document
  field :nombre, type: String
  field :correo, type: String
  field :contrasena, type: String

  validates :nombre, presence: true
  validates :correo, presence: true
  validates :contrasena, presence: true
end
