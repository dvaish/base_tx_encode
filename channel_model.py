import numpy as np
import scipy as sp
import matplotlib.pyplot as plt
from scipy import signal
# from ffe.simple import ffe
import re

from utils import Beachfront, Channel

data_pattern = re.compile(r"TXD = 0x(?P<data>\w+)")
symbol_pattern = re.compile(r"Encoded => A =\s+(?P<A>-*\d), B =\s+(?P<B>-*\d), C =\s+(?P<C>-*\d), D =\s+(?P<D>-*\d)")
file = "encoder_txrx_output.txt"
with open(file, "r") as f:
    lines = f.readlines()
    data = list(map(lambda line: int(data_pattern.search(line).group("data"), 16), lines))
    symbols = list(map(lambda line: list(map(int, symbol_pattern.search(line).groups())), lines))
f.close()

data = np.array(data)
symbols = np.array(symbols)

rx = [Channel(data=symbols[:, i]).simulate().waveform for i in range(4)]
rx = np.array(rx)
