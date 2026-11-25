% Encryption pseudocode
addpath(genpath("Functions"))

file_path_original = 'plaintext.txt';
file_path_encrypted = 'encrypted.txt';
%file_path_key = 'key.txt'; % in case you want to save the key...

% original binary string
% data = ... take the binary stream from your plaintext.txt (your favourite song)

% padded binary string
M = padding(data);

% number of blocks
n_blocks = numel(M)/128;

% key
privateKey = ... take the key from key.txt

roundKeys = key_scheduler(privateKey);

C = zeros(size(M));

for i=1:n_blocks
    
   % Here you need to write the code for encryption
   % use the AES_encrypt_block.m function, found in the "Functions" folder

   % FOR ANY DOUBTS: CHECK THE INPUT/OUTPUT VARIABLES OF THE FUNCTIONS (IN
   % THE Functions FOLDER)

end

% write the ciphertext C in encrypted.txt (keep C in binary)

