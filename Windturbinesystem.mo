model Windturbinesystem
 // Parameters
  parameter Modelica.Units.SI.Density rho = 1.225 "Air density (kg/m³)";
  parameter Modelica.Units.SI.Area A_ref = 876 "Reference area (m²)";
  //parameter Real Cp_ref = 0.45 "Reference power coefficient";
  //parameter Modelica.Units.SI.Length R = 40.0 "Rotor radius (m)";
  //parameter Modelica.Units.SI.Length hubHeight = 80.0 "Hub height (m)";
  //parameter Real generatorEfficiency = 0.95 "Generator efficiency";
  //parameter Integer numPoles = 2 "Number of generator poles";
  //parameter Real frequency = 50.0 "Generator output frequency (Hz)";

  // Variables
  //parameter Modelica.Units.SI.Velocity windSpeed=10 "Wind speed at hub height (m/s)";
  Modelica.Units.SI.Power mechanicalPower "Mechanical power from wind turbine (W)";
  //Modelica.Units.SI.Power electricalPower "Electrical power output (W)";
 
  // Wind Turbine Model
  WindTurbine windTurbine(rho=rho, A_ref=A_ref);
  
  
equation


  // Connect wind speed to wind turbine
  windTurbine.windSpeed = 10;
  // Connect wind turbine to generator
  mechanicalPower = windTurbine.power;

end Windturbinesystem;
