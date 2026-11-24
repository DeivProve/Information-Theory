close all
clear all
clc

% Ciphertexts (hex)
c1_hex = '0E1F1D021F1B0D1E1D12';
c2_hex = '171F0705040603120610';

% Convert hex to uint8 vectors
c1 = uint8(sscanf(c1_hex, '%2x').');
c2 = uint8(sscanf(c2_hex, '%2x').');

% Compute XOR = M1 XOR M2
xor = bitxor(c1, c2);

city1 = 'TURIN';
ascii1 = uint8(double(city1));

% We try on each possible starting position (from 1-5 to 6-10)
for position = 1:(length(xor) - length(city1) + 1)
    xs = xor(position:position+4);       % 5 bytes of XOR
    ascii2 = bitxor(ascii1, xs);         % Recover M2 letters
    city2 = char(ascii2);
    check = all(ascii2 >= 65 & ascii2 <= 90);  % check letters from A to Z in ASCII
    
    fprintf('Position %d–%d:  M2 = %s', position, position+4, city2);
    if check
        fprintf('   <-- possible city');
    end
    fprintf('\n');
end
