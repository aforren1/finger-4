function rawim = mkRawImg(img_type)
% inputs: img_type (from tgtfile), swapped (from tgtfile)
%
% outputs: cell array of images
    % Pick directory based on tgtfile
    basedir = [pwd, '/misc/images/'];
    basedir = [basedir, ifelse(img_type, 'shapes/', 'hands/')];
    im_names = dir([basedir, '*.jpg']); %jpgs have been fixed
    rawim = cell(length(im_names), 1);
    % if length(im_names) < 10, error('Not enough images!');
    for ii = 1:length(im_names)
            rawim{ii} = imread([basedir, im_names(ii).name]);
        % Deal with thumb as catch image
    end
end
