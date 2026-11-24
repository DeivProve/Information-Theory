clc;
clear;
close all;

addpath(genpath("Functions"))

% Load Key 
key_str = fileread('key.txt');
key = double(key_str(key_str=='0' | key_str=='1')) - '0';
roundKeys = key_scheduler(key(1:128));

% Load Bank IDs
id_b_str = fileread('encrypted_bank_B_ID.txt');
target_B = double(id_b_str(id_b_str=='0' | id_b_str=='1')) - '0';
target_B = target_B(1:128); 

id_c_str = fileread('encrypted_bank_C_ID.txt');
target_C = double(id_c_str(id_c_str=='0' | id_c_str=='1')) - '0';
target_C = target_C(1:128);

traffic_str = fileread('encrypted_banking.txt');
C = double(traffic_str(traffic_str=='0' | traffic_str=='1')) - '0';
fprintf('Stream of %d bits \n \n', numel(C));


start_indices = strfind(C, target_B);
total_diverted = 0;
count = 0;

% Output file
fid_save = fopen('diverted_amount_blocks.txt', 'w');

for k = start_indices
    
    % Check RX ID (Bank C) at offset +256
    idx_rx = k + 256;
    rx = C(idx_rx : idx_rx + 127);
    
    if isequal(rx, target_C)
        count = count + 1;
        
        % Extract Amount Block at offset +512
        amt = k + 512;
        block_amount = C(amt : amt + 127);
        
        fprintf(fid_save, '%d', block_amount);
        fprintf(fid_save, '\n');
        
        % Decryption
       
        dec_bits = AES_decrypt_block(block_amount, roundKeys);
        
        if size(dec_bits, 1) > 1
            dec_bits = dec_bits'; 
        end
        
        val = sum(dec_bits .* (2 .^ (127:-1:0)));
        
        fprintf('Transfer #%d found at bit %d: EUR %.2f\n', count, k, val);
        total_diverted = total_diverted + val;
    end
end

fclose(fid_save);

fprintf('\n');
fprintf('Total transfers found: %d\n', count);
fprintf('Total amount diverted: EUR %.2f\n', total_diverted);