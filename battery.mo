model Battery

  // Constants
  constant Real S_PER_H = 3600;

// Battery
  parameter Real batteryChargeEfficiency = 0.9;
  parameter Real batteryDischargeEfficiency = 0.9;
  parameter Real batteryMinCapacity(unit = "MWh") = 0.0;
  parameter Real batteryMaxCapacity(unit = "MWh") = 1;
  parameter Real batteryRatedCharge(unit = "MW") = 1;
  parameter Real batteryRatedDischarge(unit = "MW") = 1;
  parameter Real maxDailyChargeCycles = 0;
  parameter Real minDailyChargeCycles = 0;
  parameter Real desiredMinBatterySOC = 0;
  parameter Real desiredMaxBatterySOC = 1;
  output Real batteryChargeCycles;
  input Real batteryChargePower(unit = "MW", min = 0, max = batteryRatedCharge);
  input Real batteryDischargePower(unit = "MW", min = 0, max = batteryRatedDischarge);
  output Real batteryPower(unit = "MW");  // positive batteryPower charges battery
  output Real batteryBaselinePower(unit = "MW");
  output Real batteryCharge(unit = "MWh", min = batteryMinCapacity, max = batteryMaxCapacity);
  output Real batteryRevenue(unit = "$");
  output Real totalBatteryRevenue(unit = "$");
  output Real batterySOC;
  input Real batteryFlexUp(unit = "MW", min = 0.0);
  input Real batteryFlexDown(unit = "MW", min = 0.0);
  input Real reserveUpCall(fixed = true, min = 0.0, max = 1.0);
  input Real reserveDownCall(fixed = true, min = 0.0, max = 1.0);
  input Real gridEnergyCost(unit = "$/MWh", fixed = true);
  
equation

  S_PER_H * der(batteryCharge) = batteryChargeEfficiency * batteryChargePower - 1.0 / batteryDischargeEfficiency * batteryDischargePower;
  
  batteryPower = batteryChargePower - batteryDischargePower;
  
  batteryPower = batteryBaselinePower + reserveUpCall * batteryFlexUp - reserveDownCall * batteryFlexDown;
  
  batteryRevenue = -gridEnergyCost * batteryPower;
  
  S_PER_H * der(totalBatteryRevenue) = batteryRevenue;
  
  S_PER_H * der(batteryChargeCycles) = (batteryChargeEfficiency * batteryChargePower + 1.0 / batteryDischargeEfficiency * batteryDischargePower) / batteryMaxCapacity / 2.0;
  
  batterySOC = batteryCharge / batteryMaxCapacity;

end Battery;
