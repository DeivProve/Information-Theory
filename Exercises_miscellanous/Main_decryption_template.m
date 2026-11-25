clc;
clear;
close all;


addpath(genpath("C:\Users\davep\Downloads\_temp_matlab_R2025b_Windows\Functions"))

% File paths
file_path_encrypted = 'C:\Users\davep\OneDrive\Documenti\MATLAB\Ciphertext.txt';
file_path_decrypted = 'decrypted.txt'; % output file after decryption
file_path_decrypted_inc = 'decrypted_inc.txt';

% Convert the ciphertext into a binary stream
C = text_to_binary_stream(file_path_encrypted);

% Number of blocks
n_blocks = numel(C)/128; % C = [C1, C2, ... , Cn_blocks] 

% Private Key
privateKey_str = '10010111000101010111101001101111110010001110010010111011111001000011001011000100000011010011010111110010011100010110000010010010';

% Initialization vector
IV_str = '11101011101000000010111000110111100110000001011111010110001101101010000101000100010101010001110111110100100110101101111000110111';

% Incorrect initialization vector (set such that 0's become 1's and vice versa)
IV_inc = '00010100010111111101000111001000011001111110100000101001110010010101111010111011101010101110001000001011011001010010000111001000';

% Convert privateKey and IV to 1x128 binary vectors 
privateKey = double(privateKey_str) - double('0');
IV = double(IV_str) - double('0');

Iv_inc = double(IV_inc) -double('0');

% Generate the round keys
roundKeys = key_scheduler(privateKey);

% Initialize the plaintext 
M = zeros(size(C));

prev = IV; 

for i = 1:n_blocks
    Ci = C((i-1)*128+1 : i*128);
    Di = AES_decrypt_block(Ci, roundKeys);
    Mi = xor(Di, prev);
    M((i-1)*128+1 : i*128) = Mi;
    prev = Ci;
end
%Loop with incorrect IV
prev_inc = IV_inc; 

for i = 1:n_blocks
    Ci = C((i-1)*128+1 : i*128);
    Di = AES_decrypt_block(Ci, roundKeys);
    Mi = xor(Di, prev_inc);
    M_inc((i-1)*128+1 : i*128) = Mi;
    prev_inc = Ci;
end

% Remove padding
data = unpadding(M);
data_inc = unpadding(M_inc);

% Convert to text and write the content into decrypted.txt
binary_stream_to_text(data, file_path_decrypted);
binary_stream_to_text(data_inc,file_path_decrypted_inc);