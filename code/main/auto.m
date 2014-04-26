% filename{1}='../../data/both/8';
% filename{2}='../../data/both/5';
% filename{3}='../../data/both/6';
% filename{4}='../../data/both/7';
filename{6}='../../data/packer_multi_res/1a_big';
filename{7}='../../data/packer_multi_res/1a_med';
filename{8}='../../data/packer_multi_res/1a_small';
filename{9}='../../data/packers_lowTexture/1a_big';
filename{10}='../../data/colts_A/1';
filename{11}='../../data/colts_A/2';
filename{12}='../../data/packers_lowTexture/1b_big';
filename{13}='../../data/packers_A/1';

% fullfile(read_dir,'/*jpg')
% imageNames  =  dir(fullfile(read_dir,'/*jpg'));
% imageNames  = {imageNames.name}';
% imageStrings = regexp([imageNames{:}],'(\d*)','match');
% imageNumbers = str2double(imageStrings);
% [~,sortedIndices] = sort(imageNumbers);
% imgList = imageNames(sortedIndices);

for i=6:length(filename)
   process(filename{i},'mp4'); 
end