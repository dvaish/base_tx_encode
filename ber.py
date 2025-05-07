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

def align(a, b):
    correlation = np.correlate(a, b, mode='full')
    delay = np.argmax(correlation)
    lag = delay - (len(b) - 1)
    if lag >= 0:
        a = a[lag:][:len(b)]
        b = b[:len(a)]
    else:
        b = b[-lag:][:len(a)]
        a = a[:len(b)]
    print(np.max(correlation), np.dot(a, b))
    return a, b

def ber(a, b):
    a, b = align(a, b)
    return np.mean(np.not_equal(a, b))

def eye(received, transmitted):
    received, transmitted = align(received, transmitted)
    for i in range(1, min(len(received), len(transmitted))-2):
        colors = ['C0', 'C1', 'C2', 'C3', 'C4']
        color = colors[int(transmitted[i]) + 2]
        plt.plot(received[i-1:i+2], alpha=0.5, color=color)
    return


for col in range(4):
    
    ffe_output = ffe[:, col]
    ffe_symbols = list(map(threshold, ffe_output))
    # print(np.max(correlation), np.dot(decoded[13:, col], symbols[:-18, col]))
    eye(ffe_symbols, symbols[:, col])
    plt.savefig(f"ffe_eye{col}.png")

    print(ber(ffe_symbols, symbols[:, col]))
    print(ber(symbols[:, col], decoded[:, col]))