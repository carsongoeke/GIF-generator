# GIF-generator

The goal of this project is create a generative model, that will translate texts to novel gifs.
I use the Giphy API to generate training examples.

The system will work by using a set of common words to query the Giphy API to generate examples.
The text will be passed to an embedding layer which will be fed to a conditional variational autoencoder to generate the first frame of the gifs.

A convolutional LSTM network will be trained to generate the sequence of frames from the starting frame.

The final network will just connect the CVAE and CLSTM to take a word and generate a gif. 
