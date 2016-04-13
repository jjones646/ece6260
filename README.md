# Data Compression & Modeling

This project is the analysis and compression of an audio signal, [Signal.wav](./includes/Signal.wav).


## Prerequisites

You will need [MATLAB](http://www.mathworks.com/products/matlab/) to run the scripts.


## Usage

To encode the [Signal.wav](./includes/Signal.wav) file, run the [encoder_main.m](./encoder_main.m) script using [MATLAB](http://www.mathworks.com/products/matlab/).


## License

TODO

~~This project is licensed under the MIT License - see the [LICENSE.md](./LICENSE.md) file for details.~~


## Examples

Bandpass filters are used to divide [Signal.wav](./includes/Signal.wav) into manageable sections. A relevant compression technique is then applied for each section.
<div align="center" class="plain">
    <img src="https://raw.githubusercontent.com/jjones646/ece6260/master/doc/filtered-sections.png" alt="Filtered sections from the original signal" class="markdown-img-wrapper"/>
</div>

The original [Signal.wav](./includes/Signal.wav) file contains Morse code in the background audio. This section of the signal is decoded as a prerequisite to its compression.
<div align="center" class="plain">
    <img src="https://raw.githubusercontent.com/jjones646/ece6260/master/doc/morse-signal.png" alt="Digitized Morse Signal" class="plain"/>
</div>
