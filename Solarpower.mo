model Solarpower
  // Constants
  //constant Real S_PER_H = 3600; //Second per hour
  constant Real MEGA = 1e6;   // contant for prefix Mega
  //constant Integer K_C_GAP = 273; // for converting kelvin to degree
  // Grid connection
  //output Real reserveUp(unit = "MW", min = 0);
  input Real reserveUpCall(fixed = true, min = 0.0, max = 1.0);      
//output Real reserveDown(unit = "MW", min = 0);
  input Real reserveDownCall(fixed = true, min = 0.0, max = 1.0);
 // Solar, input output and paramter
  parameter Real solarEfficiency = 0.15;//Maximum efficiency available 20-22% in industrial
  parameter Real solarArea(unit = "m2") = 7000;//Total area of the collector
  input Real irradiation(unit = "W/m2", fixed = true);//Value of solar irradiation at Solar Area
  output Real solarPower(unit = "MW");//ideal Solar Power generated
  output Real solarBaselinePower(unit = "MW");  // After adjusting flexibilty operations
  //parameter Boolean isSolarCurtailable = 1;//Solar Curtailment is the fraction of solar power that is curtailed
  input Real solarCurtailment(min = 0, max = 1);// isSolarCurtailable Getting input with the solar curtailment
  input Real solarFlexUp(unit = "MW", min = 0.0);// increase solar power, positive solar flex
  input Real solarFlexDown(unit = "MW", min = 0.0);  
// decrease solar power, negative solar flex
equation

  MEGA * solarPower = (1.0 - solarCurtailment) * solarEfficiency * solarArea * irradiation;
  solarPower = solarBaselinePower + reserveUpCall * solarFlexUp - reserveDownCall * solarFlexDown;

annotation(
    uses(Modelica(version = "4.0.0")));
end Solarpower;
