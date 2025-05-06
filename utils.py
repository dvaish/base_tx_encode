import numpy as np
import scipy as sp
from scipy import signal
import matplotlib.pyplot as plt

from typing import List

    
class Channel:
    channel_response_bounds = np.loadtxt("table40_10.txt", skiprows=3)
    channel_response = np.mean(channel_response_bounds[:, 1:], axis=1)

    def __init__(self, fs: int=4_000_000_000, N=1000, data=None):
        if data is None:
            self.N = N
            self.data = np.random.randint(-2, 3, N)
        else:
            self.N = len(data)
            self.data = data
        self.fs = fs
        self.osr = fs // 125_000_000
        self.waveform = self.data

    def pulse_shaping_filter(self):
        transmit_filter = [3, 1]
        self.waveform = np.convolve(self.waveform, transmit_filter, mode='same')
        return self

    def upsample(self):
        waveform = np.zeros(self.N * self.osr)
        waveform[::self.osr] = self.waveform
        self.waveform = waveform 
    
    def simulate_channel_response(self):
        self.waveform = np.convolve(self.waveform, Channel.channel_response, mode='same')
        return self
    
    def insertion_loss(self):
        fft = np.fft.rfft(self.waveform)
        f = np.linspace(0, self.fs, len(fft))
        f = np.minimum(f, 100e6)
        f = np.maximum(f, 1e6)
        il_dB = 2.8 * ((f / 1e6) ** 0.529) + 0.4 / (f / 1e6)
        il = 10.0 ** (-il_dB / 20)
        response = fft * il
        self.waveform = np.fft.irfft(response)
        return self


    def simulate_test_setup(self):
        omega_z = 100e3
        omega_p = 100e6
        numerator = [1, 1/omega_z]
        denomenator = [1, 1/omega_p]
        b, a = signal.bilinear(numerator, denomenator, fs=self.fs)
        self.waveform = signal.lfilter(b, a, self.waveform)
        return self
    
    def downsample(self):
        self.waveform = self.waveform[::self.osr]
        return self
    
    def quantize(self, margin=1.05, B=8):
        full_scale = max(self.waveform) - min(self.waveform)
        full_scale *= margin
        self.waveform = ((self.waveform / full_scale) * (2 ** B)).astype(int)
        return self
    
    def simulate(self, rx=True, margin=1.05, B=8)->"Channel":
        self.pulse_shaping_filter()
        self.upsample()
        if rx:
            # self.insertion_loss()
            #self.simulate_channel_response()
            # self.simulate_test_setup()
            self.downsample()
            self.quantize(margin=margin, B=B)
        return self

class Beachfront():

    # TODO
    def __init__(self, rx:Channel, echo:Channel, next:List[Channel]):
        self.rx = rx
        self.echo = echo
        self.next = next

    def simulate_echo(self):
        fft = np.fft.rfft(self.echo.waveform)
        f = np.linspace(0, self.rx.fs, len(fft))
        f = np.minimum(f, 1e6)
        f = np.maximum(f, 100e6)
        rl_dB = 15 - 10 * np.log10((f / 1e6) / 20)
        rl_dB = np.maximum(rl_dB, 15)
        rl = 10.0 ** (-rl_dB / 20)
        response = fft * rl
        echo = np.fft.irfft(response)
        self.rx.waveform = self.rx.waveform + echo
        return self

    def simulate_next(self):
        length = len(np.fft.rfft(self.next[0].waveform))
        f = np.linspace(0, self.rx.fs, length)
        f = np.minimum(f, 1e6)
        f = np.maximum(f, 100e6)
        rl_dB = 27.1 - 16.8 * np.log10((f / 1e6) / 100)
        rl = 10.0 ** (-rl_dB / 20)
        for next in self.next:
            fft = np.fft.rfft(next.waveform)
            response = fft * rl
            aggressor = np.fft.irfft(response)
            self.rx.waveform += aggressor
        return self