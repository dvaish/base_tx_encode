import pandas as pd

data = pd.read_csv("encoder_output.txt", delimiter="\t")

# A == 1
# B == 0

set0 = (abs(data["A"]) % 2).astype(int)
set1 = (abs(data["B"]) % 2).astype(int)
set2 = (abs(data["C"]) % 2).astype(int)
set3 = (abs(data["D"]) % 2).astype(int)

symbols = list(zip(set0, set1, set2, set3))

symbol_map = {
    (0, 0, 0, 0): 0,
    (1, 1, 1, 1): 0,
    (1, 1, 1, 0): 1,
    (0, 0, 0, 1): 1,
    (1, 1, 0, 0): 2,
    (0, 0, 1, 1): 2,
    (1, 1, 0, 1): 3,
    (0, 0, 1, 0): 3,
    (1, 0, 0, 1): 4,
    (0, 1, 1, 0): 4,
    (1, 0, 0, 0): 5,
    (0, 1, 1, 1): 5,
    (1, 0, 1, 0): 6,
    (0, 1, 0, 1): 6,
    (1, 0, 1, 1): 7,
    (0, 1, 0, 0): 7
}

sets = list(map(lambda symbol: symbol_map[symbol], symbols))