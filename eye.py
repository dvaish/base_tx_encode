import re
import numpy as np
import matplotlib.pyplot as plt

data_pattern = re.compile(r"TXD = 0x(?P<data>\w+)")
symbol_pattern = re.compile(r"Encoded => A =\s+(?P<A>-*\d), B =\s+(?P<B>-*\d), C =\s+(?P<C>-*\d), D =\s+(?P<D>-*\d)")
file = "encoder_txrx_output.txt"
with open(file, "r") as f:
    lines = f.readlines()
    # data = list(map(lambda line: int(data_pattern.search(line).group("data"), 16), lines))
    symbols = list(map(lambda line: list(map(int, symbol_pattern.search(line).groups())), lines))
symbols = np.array(symbols)
f.close()

channel = np.loadtxt("ffe_input.txt")
equalized = np.loadtxt("ffe_output.txt", skiprows=4)[:, 1:]

colors = [f"C{i}" for i in range(5)]
col = 0
for i in range(1, len(channel)-1):
    plt.plot(channel[i-1:i+2, col], alpha=0.5, color=colors[symbols[i+1, col]+2])
plt.savefig("original_eye.png")
plt.show()
plt.close()

### CHATGPT
a = equalized[:, col]       
b = symbols[:, col]

# Determine which is larger
if len(a) > len(b):
    a, b = b, a  # ensure a is the smaller one

# Compute full cross-correlation
corr = np.correlate(b, a, mode='full')

# Find the best alignment (maximum correlation)
best_offset = np.argmax(corr)

# Compute lag: index offset from the beginning of full correlation
lag = best_offset - (len(a) - 1)

# Slice the larger sequence to match alignment
# start = max(lag, 0)
# end = start + len(a)
# aligned_b = b[start:end]
a = a[-best_offset-1:]
aligned_b = b[:len(a)]
print(np.max(corr), np.dot(a, aligned_b))
### CHATGPT

col = 0
for i in range(1, len(a)-1):
    plt.plot(a[i-1:i+2], alpha=0.5, color=colors[aligned_b[i]+2])
plt.savefig("ffe_eye.png")
plt.show()