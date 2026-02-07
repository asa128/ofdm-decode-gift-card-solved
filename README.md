decode the ofdm i/q file to get amazon gift card.

fs = 48KHz

number of char = 256
each char is 8 bits

signal has a pulse , a gap , cp for pilot block, pilot block,  cp for data block, data block

signal has a freq offset, needs to be removed.

pulse is 8192 samples

gap is 1000 samples

cp for pilot block is 512 samples
pilot block is 3072 samples

cp for data block is 512 samples
data block is 3072 samples

need to take fft of pilot block and data block.

fft size = 3072

after fft,  use fftshift to center spectrum of data block and pilot block

spectrum is 512 guard bins then 2048 bins of data, and then 512 guard bins

data fft is related to pilot fft

bit 1 = 0 degrees  
bit 0 = 180 degrees

number of bits = 256*8


