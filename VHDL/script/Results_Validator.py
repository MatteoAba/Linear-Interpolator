import sys

results = list()
expectedResults = list()

# results obtained in ModelSim
for line in open("./list.lst"):
    # remove the lines that don't contain results
    if "ps" in line or "delta" in line or "UUUUU" in line:
        continue

    # from every line the result will be extracted
    line = line.split(" ")
    res = int(line[len(line) - 2], 2)
    results.append(res)

# results expected
for line in open("./ExpectedResults.txt"):
    expectedResults.append(int(line))

# comparison between obtained and expected results
errors = 0
for i in range(0, len(expectedResults)):
    if results[i] != expectedResults[i]:
        errors += 1
        print("[-]",results[i], expectedResults[i])
    else:
        print("[+] OK")
print(f"\n{errors} errors found")