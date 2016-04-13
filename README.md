# Data Compression & Modeling :speaker:

This project is the analysis and compression of an audio signal, [Signal.wav](./includes/Signal.wav).


## Prerequisites

You will need [MATLAB](http://www.mathworks.com/products/matlab/) to run the scripts.


## Usage

### Encoding
To encode the [Signal.wav](./includes/Signal.wav) file, run the [encoder_main.m](./encoder_main.m) script using [MATLAB](http://www.mathworks.com/products/matlab/).

### Decoding
TODO


## License

TODO

~~This project is licensed under the MIT License - see the [LICENSE.md](./LICENSE.md) file for details.~~


## Algorithm Approach

|Signal Segmentation|
|:---|
|Bandpass filters are used to divide [Signal.wav](./includes/Signal.wav) into manageable sections. The `fftfilter` function in [fftfilter.m](./includes/fftfilter.m) is used for the initial segmentation. A relevant compression technique is then applied for each section, which are shown below.|
|![](./doc/filtered-sections.png)|
|The signal is broken down into these 5 parts:<ul><li>Speech</li><li>Morse Code</li><li>Mid. Freq. Noise</li><li>Chirp</li><li>High Freq. Noise</li></ul>|

|Morse Code|
|:---|
|The original [Signal.wav](./includes/Signal.wav) file contains Morse Code in the background audio. One of the steps involved for its compression is to first decode the signal. The bulk of this is handled with the `demorse` function from [demorse.m](./includes/demorse.m), and some of its steps are shown below.|
|![](./doc/morse-signal.png)|
