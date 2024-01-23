model Lookup_tableread
output Real outputvalue;
input Real inputvalue;

  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds(columns = 1:2, fileName = "C:/Users/waqar.razzaq/Desktop/Modelica models/Cp_lookup.mat", tableName = "lookuptableCp", tableOnFile = true, verboseRead = false);
algorithm

combiTable1Ds.u:=inputvalue;
 outputvalue:=combiTable1Ds.y[2];

end Lookup_tableread;
