model Battery_Soc_controle

  parameter Real battery_capacity = 5 "Battery capacity in MWh";
  parameter Real charg_rate = 0.5 "C rating of Battery";
  parameter Real discharge_rate = 0.5;
  parameter Real load = 35 "Constant load in MWh";
  parameter Real init_soc = 0.5 "Initial state of charge of battery";

  Real soc(start = init_soc) "State of charge of the battery";
  Real charging_energy = charg_rate * battery_capacity;
  Real discharging_energy = discharge_rate * battery_capacity;

  // Load generated energy data
  Real t[:];
  Real wind_energy[:];
  Real solar_energy[:];

  // Total energy available after feeding load
  Real gen_energy[:];
  Real load_profile[:];
  Real avail_energy[:];
  Real curtail_energy[:];
  Real import_energy[:];
  Real Soc[:];

initial equation
  // Initialize the data
  gen_energy = wind_energy + solar_energy;
  load_profile = fill(load, size(gen_energy, 1));
  avail_energy = gen_energy - load_profile;
  curtail_energy = zeros(size(avail_energy, 1));
  import_energy = zeros(size(avail_energy, 1));

algorithm
  // Control logic for charging and discharging of battery
  while (battery_capacity <= 50) loop
    for i in 1:size(avail_energy, 1) loop
      // Charging logic
      if avail_energy[i] > 0 and avail_energy[i] > charging_energy and soc < 1 then
        curtail_energy[i] := avail_energy[i] - charging_energy;
        soc := init_soc + charging_energy / battery_capacity;
      elseif avail_energy[i] > 0 and avail_energy[i] >= charging_energy and soc >= 1 then
        curtail_energy[i] := avail_energy[i];
        soc := init_soc;
      elseif avail_energy[i] > 0 and avail_energy[i] == charging_energy and soc < 1 then
        curtail_energy[i] := 0;
        soc := init_soc + charging_energy / battery_capacity;
      elseif avail_energy[i] > 0 and avail_energy[i] < charging_energy and soc < 1 then
        curtail_energy[i] := 0;
        soc := init_soc + avail_energy[i] / battery_capacity;
      elseif avail_energy[i] > 0 and avail_energy[i] < charging_energy and soc >= 1 then
        curtail_energy[i] := avail_energy[i];
        soc := init_soc;
      end if;

      // Discharging logic
      if avail_energy[i] < 0 and abs(avail_energy[i]) > discharging_energy and soc > 0 then
        import_energy[i] := avail_energy[i] + discharging_energy;
        soc := init_soc - discharging_energy / battery_capacity;
      elseif avail_energy[i] < 0 and -avail_energy[i] >= discharging_energy and soc <= 0 then
        import_energy[i] := avail_energy[i];
        soc := init_soc;
      elseif avail_energy[i] < 0 and -avail_energy[i] == discharging_energy and soc > 0 then
        import_energy[i] := 0;
        soc := init_soc - discharging_energy / battery_capacity;
      elseif avail_energy[i] < 0 and -avail_energy[i] < discharging_energy and soc > 0 then
        import_energy[i] := 0;
        soc := init_soc + avail_energy[i] / battery_capacity;
      elseif avail_energy[i] < 0 and -avail_energy[i] < discharging_energy and soc <= 0 then
        import_energy[i] := avail_energy[i];
        soc := init_soc;
      end if;

      // SOC constraints
      soc := max(0, min(1, soc));

      init_soc := soc;
      Soc[i] := soc;
    end for;
    battery_capacity := battery_capacity + 5;
  end while;



end Battery_Soc_controle;
