# Linear Interpolator

Electronics Systems project.

## How to simulate

The simulation of the circuit can be automated through the scripts in the `VHDL/script` folder, that can generate randomically a **ModelSim** testbench and compare the simulation results with the expected results:

### 1. Testbench generation

Generate the testbench with the python script `TB_Generation` in `VHDL/script` folder:

```bash
cd VHDL/script
python3 TB_generation.py
```

### 2. Modelsim simulation

Use the testbench to simulate the circuit on **ModelSim**. After that is necessary to extract the output signal: 

1) Activate the `List window` in View/List 
2) From the Object tab drag the signal `res_ext` to the List tab
3) Click on the List tab to highlight all the results
4) Save the results from File/Export/Tabular list as `list.lst` in the `VHDL/script` folder

### 3. Results check

Now use the script `Results_Validator` to compare the results extracted from **ModelSim** with the expected results generated in the first phase:

```bash
python3 Results_Validator.py
```

The scripts will return `[+] OK` if the expected and obtained signals are the same. If the signals are different, the script will return `[-] ObtainedSignal ExpectedSignal`. 

In this control some signals may differ by a value of one, due to **approximation errors**.