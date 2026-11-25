% Encryption pseudocode
clear
close all
clc

addpath(genpath("Functions"))

file_path_original = 'Plaintext.txt';
file_path_encrypted = 'encrypted.txt';

IV_str = '11011001110110100111101111101010000110100011000111011000101010111110001010100010011110110100111010000101010111000101110001011100'; %after randomizing
% original binary string
data = text_to_binary_stream(file_path_original); 

% padded binary string
M = padding(data);

% number of blocks
n_blocks = numel(M)/128;

% key
privateKey_str = '10101101001000111110101101000110001110011110100100101101110010110001010011111000010110110010011110001110011110101001101101010110'; %after randomizing

privateKey = double(privateKey_str) - double('0');
IV = double(IV_str) - double('0');

roundKeys = key_scheduler(privateKey);

C = zeros(size(M));
prev = IV_str;
for i = 1:n_blocks
    Mi = M((i-1)*128+1 : i*128);
    input_block = xor(Mi, prev);
    Ci = AES_encrypt_block(input_block, roundKeys);
    C((i-1)*128+1 : i*128) = Ci;
    prev = Ci;
end

binary_stream_to_text(C, file_path_encrypted);

% Now we test with a slightly different key
privateKey_str_modified = '10001101001000111110101101000110001110011110100100101101110010110001010011111000010110110010011110001110011110101001101101010110'; %third bit
privateKey_mod = double(privateKey_str_modified) - double('0');
roundKeys_mod = key_scheduler(privateKey_mod);

C_mod = zeros(size(M));
prev = IV; 

for i = 1:n_blocks
    Mi = M((i-1)*128+1 : i*128);
    input_block = xor(Mi, prev);
    Ci = AES_encrypt_block(input_block, roundKeys_mod);
    C_mod((i-1)*128+1 : i*128) = Ci;
    prev = Ci;
end

% Calculate Difference
num_diff_bits = sum(C ~= C_mod);
percent_diff = (num_diff_bits / numel(C)) * 100;

fprintf('Percentage of bits that differ: %.2f%%\n', percent_diff);
