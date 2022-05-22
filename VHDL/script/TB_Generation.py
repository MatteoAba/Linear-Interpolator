from random import seed
import sys
from xml.etree.ElementTree import tostring

# input of parameters
import argparse
parser = argparse.ArgumentParser()
parser.add_argument("-s", "--seed", type=int, help="Seed for the Signals Generator.")
parser.add_argument("-n", "--number", type=int, help="Number of Signals to generate.")
args = parser.parse_args()

# parameters for generation 
if args.seed :
    INITIAL_SEED = args.seed
else:
    INITIAL_SEED = 0
if args.number :
    GENERATED_SIGNAL = args.number
else:
    GENERATED_SIGNAL = 16

print("- Seed for generation:", INITIAL_SEED)
print(f"- Will be generated {GENERATED_SIGNAL} signals\n")

# RNG for the signals generation
from numpy.random import Generator, MT19937, SeedSequence
sg = SeedSequence(874015)
rng = Generator(MT19937(sg.spawn(1)[0]))
sig = rng.integers(low=0, high=65535, size=GENERATED_SIGNAL).tolist()

# generation of testbench file
sys.stdout = open("./LinearInterpolator_tb.vhd", "w")

for line in open("./Base.txt"):

    if "wait for 500" in line:
        print("\t\t\twait for 150 ns;")
        print("\t\t\ta_rst_n_ext <= '1';") 
        print("\t\t\twait for 250 ns;")

        for s in sig:
            value = str(hex(s))[2:]
            if len(value) == 1:
                value = "000" + value
            elif len(value) == 2:
                value = "00" + value
            elif len(value) == 3:
                value = "0" + value
            print(f"\t\t\tsig_ext     <= x\"{value}\";") 
            print("\t\t\twait for 400 ns;") 

    print(line, end="")

sys.stdout = sys.__stdout__

print("[+] Testbench correctly generated")

# generations of results file in a tabulated form

results = list()
sys.stdout = open("./TabulatedResults.txt", "w")

print("+-------+-------+-------+-------+-------+")
print("| SIG\t| OUT0\t| OUT1\t| OUT2\t| OUT3\t|")
print("+-------+-------+-------+-------+-------+")

sig = [0] + sig
for i in range(1, GENERATED_SIGNAL):
    out0 = sig[i-1]
    out1 = (sig[i] >> 2) + (sig[i-1] >> 2) + (sig[i-1] >> 1)
    out2 = (sig[i] >> 1) + (sig[i-1] >> 1)
    out3 = (sig[i] >> 2) + (sig[i] >> 1) + (sig[i-1] >> 2)
    
    print(f"| {sig[i]}\t| {out0}\t| {out1}\t| {out2}\t| {out3}\t|")
    results = results + [out0, out1, out2, out3]

print("+-------+-------+-------+-------+-------+")

sys.stdout = sys.__stdout__

# generations of results file in a list form

sys.stdout = open("./ExpectedResults.txt", "w")

for i in range(0, len(results)):  
    print(results[i])

sys.stdout = sys.__stdout__

print("[+] Results files correctly generated")
