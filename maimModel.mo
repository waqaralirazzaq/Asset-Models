model mainModel

  // Instantiate the tableread model with a specific input
  Lookup_tableread tableReader(inputvalue=5);

  // Define other variables or components in your main model
  Real someVariable1;

equation
  // Connect the output of tableread to someVariable
  //tableReader.inputvalue=25;
  someVariable1 = tableReader.outputvalue;



end mainModel;
