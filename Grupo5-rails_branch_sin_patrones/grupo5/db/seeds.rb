Api::Actuador.delete_all
Api::Alert.delete_all
Api::Microcontrolador.delete_all
Api::Usuario.delete_all
Api::RegistroMedicion.delete_all
Api::VariableAmbiental.delete_all
Delayed::Job.delete_all

varAlerta = Api::Alert.new(tipo:1, mensaje:"alerta fuera de rango: valor recibido=1 valor minimo=2.0")

varActuador = Api::Actuador.new(estado:false)

varMicrocontrolador = Api::Microcontrolador.new(nivel:1,area:1)

varRegistroMedicion = Api::RegistroMedicion.new(valor:1)

varVariableAmbiental1 = Api::VariableAmbiental.new(tipo:"Temperature", valorMaximo:27.0, valorMinimo:21.5 , unidad:"∞C", variacionDiaria:5.4 , precision:2.0 , frecuencia:60)

varVariableAmbiental2 = Api::VariableAmbiental.new(tipo:"Sound", valorMaximo:85.0, valorMinimo:0.0 , unidad:"dB", variacionDiaria:0.0 , precision:2.0 , frecuencia:120)

varVariableAmbiental3 = Api::VariableAmbiental.new(tipo:"Monoxide", valorMaximo:100.0, valorMinimo:0.0 , unidad:"ppm", variacionDiaria:0.0 , precision:2.0 , frecuencia:60)

varVariableAmbiental4 = Api::VariableAmbiental.new(tipo:"Lux", valorMaximo:2000.0, valorMinimo:100.0 , unidad:"Lux", variacionDiaria:0.0 , precision:2.0 , frecuencia:120)

varUsuario = Api::Usuario.new(nombre:"Alejandro", correo:"a.echeverrir@uniandes.edu.co", contrasena:"password1234" )

varActuador.microcontrolador = varMicrocontrolador
varActuador.variable_ambiental = varVariableAmbiental1

varAlerta.microcontrolador = varMicrocontrolador

varRegistroMedicion.variable_ambiental = varVariableAmbiental1
varRegistroMedicion.microcontrolador =  varMicrocontrolador

varVariableAmbiental1.save
varVariableAmbiental2.save
varVariableAmbiental3.save
varVariableAmbiental4.save

varMicrocontrolador.save
varRegistroMedicion.save
varAlerta.save
varActuador.save
varUsuario.save
