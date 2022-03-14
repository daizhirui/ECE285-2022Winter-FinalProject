clear
clc
close all

sdplibDir = fullfile([pwd filesep 'sdplib']);
files = {dir(sdplibDir).name}';
for i = 1 : size(files, 1)
    file = files{i};
    if endsWith(file, '.dat-s')
        filepath = fullfile([sdplibDir, filesep, file]);
        fprintf('parsing %s ...', filepath);
        sdplib(filepath);
        disp('DONE');
    end
end