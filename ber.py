import numpy as np
import matplotlib.pyplot as plt
import re

data_pattern = re.compile(r"TXD = 0x(?P<data>\w+)")
symbol_pattern = re.compile(r"Encoded => A =\s+(?P<A>-*\d), B =\s+(?P<B>-*\d), C =\s+(?P<C>-*\d), D =\s+(?P<D>-*\d)")
file = "encoder_txrx_output.txt"
with open(file, "r") as f:
    lines = f.readlines()
    # data = list(map(lambda line: int(data_pattern.search(line).group("data"), 16), lines))
    symbols = list(map(lambda line: list(map(int, symbol_pattern.search(line).groups())), lines))
symbols = np.array(symbols)
f.close()

ffe = np.loadtxt("ffe_output.txt")
decoded = np.loadtxt("decoded_output.txt")

def threshold(value):
    symbol = -2
    if value > -110:
        symbol = -1
    if value > -50:
        symbol = 0
    if value > 50:
        symbol = 1
    if value > 100:
        symbol = 2
    return symbol

def align(a, b, log=False):
    correlation = np.correlate(a, b, mode='full')
    delay = np.argmax(correlation)
    lag = delay - (len(b) - 1)
    if lag >= 0:
        a = a[lag:][:len(b)]
        b = b[:len(a)]
    else:
        b = b[-lag:][:len(a)]
        a = a[:len(b)]
    if log:
        print(np.max(correlation), np.dot(a, b))
    return a, b

def ber(a, b):
    a, b = align(a, b)
    return np.mean(np.not_equal(a, b))

def eye(received, transmitted=None, log=False):
    if transmitted is not None:
        received, transmitted = align(received, transmitted, log=log)
    for i in range(1, min(len(received), len(transmitted))-2):
        colors = ['C0', 'C1', 'C2', 'C3', 'C4']
        color = colors[int(transmitted[i]) + 2]
        plt.plot(received[i-1:i+2], alpha=0.5, color=color)
    plt.savefig("eye.png")
    plt.close()
    return

symbols_aligned_sets = []
decoded_aligned_sets = []
for col in range(4):
    
    ffe_output = ffe[:, col]
    ffe_symbols = list(map(threshold, ffe_output))
    # print(np.max(correlation), np.dot(decoded[13:, col], symbols[:-18, col]))
    eye(ffe_output, transmitted=symbols[:, col], log=True)

    ffe_ber = ber(ffe_symbols, symbols[:, col])
    symbol_ber = ber(symbols[:, col], decoded[:, col])

    symbols_aligned, decoded_aligned = align(symbols[:, col], decoded[:, col])
    decoded_aligned_sets.append(decoded_aligned)
    symbols_aligned_sets.append(symbols_aligned)
    plt.plot(symbols_aligned)
    plt.plot(decoded_aligned)
    plt.savefig(f"time_domain{col}.png")
    plt.close()

    print(f"FFE={round(ffe_ber, 3)}, TOTAL={round(symbol_ber, 3)}")

for i in range(len(decoded)):
    plt.plot(decoded[i-1:i+2, 4] // (2 ** 7), color='C0', alpha=0.5)
plt.savefig("decoded.png")

overall = (symbols_aligned_sets[0] == decoded_aligned_sets[0]) & \
    (symbols_aligned_sets[1] == decoded_aligned_sets[1]) & \
    (symbols_aligned_sets[2] == decoded_aligned_sets[2]) & \
    (symbols_aligned_sets[3] == decoded_aligned_sets[3])