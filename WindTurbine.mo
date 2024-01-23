model WindTurbine
  parameter Modelica.Units.SI.Density rho "Air density (kg/m³)";
  parameter Modelica.Units.SI.Area A_ref "Reference area (m²)";
  Real Cp_ref "Reference power coefficient";
  //parameter Modelica.Units.SI.Length R "Rotor radius (m)";
  //parameter Modelica.Units.SI.Length hubHeight "Hub height (m)";

  input Real windSpeed "Input: Wind speed at hub height (m/s)";
  output Real power "Output: Mechanical power from wind turbine (W)";
// Reading lookup table for Cp w.r.t windSpeed
  Lookup_tableread tableReader;
  

algorithm

  tableReader.inputvalue:=windSpeed;
  Cp_ref:=tableReader.outputvalue;
  // Wind turbine power model
  power := 0.5 * rho * A_ref * Cp_ref * windSpeed^3;

end WindTurbine;


 
