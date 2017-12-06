module Api::RegistroMedicionesHelper
  def self.verify(medicion, promedio)
    #Alerta fuera de linea
    self.verificar_alerta_fuera_linea(medicion)

    #Alerta fuera rango
    limiteInferior = medicion.variable_ambiental.valorMinimo - medicion.variable_ambiental.variacionDiaria
    limiteSuperior = medicion.variable_ambiental.valorMaximo - medicion.variable_ambiental.variacionDiaria
    puts "#{limiteInferior}"
    # Si esta fuera de los rangos se prenden los actuadores
    if medicion.valor < limiteInferior || medicion.valor > limiteSuperior
      @alertRango = Api::Alert.new(tipo: 1, mensaje: "Alerta fuera de rango")
      @alertRango.microcontrolador = medicion.microcontrolador
      @alertRango.save

      puts "Alerta Fuera de rango"
      self.cambiar_estado_de_actuadores_a(1, medicion)
      puts "Se prendieron los actuadores"

      self.delay(run_at: 60.minutes.from_now).verify_actuador_off(medicion.microcontrolador.actuadores.where(variable_ambiental: medicion.variable_ambiental).to_a, medicion)

      return false
    else
      # Si se esta en el rango y hay actuadores prendidos hay que apagarlos
      self.cambiar_estado_de_actuadores_a(0, medicion)
      puts "Se apagaron los actuadores"
    end
    return true
  end

  ###########################################################
  # Alertas
  ###########################################################

  def self.verificar_alerta_fuera_linea(medicion)
    lastTimestamp = Api::RegistroMedicion.all[-2].created_at if Api::RegistroMedicion.all[-2] != nil
    currentTimestamp = Time.now.utc

    # Se manda alerta si esta fuera del tiempo estipulado
    if lastTimestamp && currentTimestamp > (lastTimestamp + 5*medicion.variable_ambiental.frecuencia) #segundos
      puts "Alerta Fuera de linea"
      mensaje = "Tipo de alerta: Sensor fuera de línea\n\nEl microcontrolador identificado con el numero #{medicion.microcontrolador._id} contiene un sensor que se encuentra fuera de línea.\nNivel:#{medicion.microcontrolador.nivel}\nArea:#{medicion.microcontrolador.area}\nTipo de sensor:#{medicion.variable_ambiental.tipo}"
      Api::RegistroMedicionesHelper.delay.send_email(mensaje, "Se presento alerta fuera de linea!")
      @alertLinea = Api::Alert.new(tipo: 0, mensaje: mensaje)
      @alertLinea.microcontrolador = medicion.microcontrolador
      @alertLinea.save
    end
  end

  def self.verify_actuador_off(actuadores, medicion)
    siguePrendido = false
    ineficiente = nil

    # Se verifica si hay algun actuador prendido
    actuadores.each do |actuador|
      if actuador.estado == true
        siguePrendido = true
        ineficiente = actuador
        break
      end
    end

    # Si esta prendido manda el correo
    if siguePrendido
      # Mando alerta
      puts "Mandar alerta"
      mensaje = "El actuador de identificado con el numero #{ineficiente._id} ubicado en el nivel #{ineficiente.microcontrolador.nivel} y área #{ineficiente.microcontrolador.area} no está teniendo efecto en la mitigación del riesgo ambiental."
      Api::RegistroMedicionesHelper.delay.send_email(mensaje, "Se presento alerta actuador ineficiente!")
      @alertInf = Api::Alert.new(tipo: 2, mensaje: mensaje)
      @alertInf.microcontrolador = medicion.microcontrolador
      @alertInf.save
    end
  end

  ###########################################################
  # Enviar Correos
  ###########################################################

  def self.send_email(mensaje, asunto)
    mail = Mail.deliver do
      to 'drummerwilliam@gmail.com'
      from 'a.echeverrir@uniandes.edu.co'
      subject asunto
      text_part do
        body mensaje
      end
    end

    puts "Enviado"
  end

  ###########################################################
  # Modificadores
  ###########################################################

  def self.cambiar_estado_de_actuadores_a(estado_nuevo, medicion)
    estado_viejo = (estado_nuevo == 0) ? 1 : 0

    if medicion.microcontrolador.actuadores.where(estado: estado_viejo, variable_ambiental: medicion.variable_ambiental).count
      medicion.microcontrolador.actuadores.where(estado: estado_viejo, variable_ambiental: medicion.variable_ambiental).each do |actuador|
        actuador.update_attributes(estado: estado_nuevo)
      end
    end
  end
end
