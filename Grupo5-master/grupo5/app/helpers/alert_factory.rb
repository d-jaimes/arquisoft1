class AlertFactory
  def self.build(type, medicion)
    @alert = Api::Alert.new
    @alert.microcontrolador = medicion.microcontrolador

    case type
    when :FueraDeLinea
      @alert.tipo = 0
      @alert.mensaje = "Se presento alerta fuera de linea!"
      @alert.save
      return @alert
    when :FueraDeRango
      @alert.tipo = 1
      @alert.mensaje = "Se presento alerta fuera de rango!"
      @alert.save
      return @alert
    when :ActuadorIneficiente
      @alert.tipo = 2
      @alert.mensaje = "Se presento alerta actuador ineficiente!"
      @alert.save
      return @alert
    end
  end
end
