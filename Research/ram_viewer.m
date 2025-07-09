clc;
clear;

% Set image width (in pixels, multiple of 8)
PACKET_image_width = 128;

% List all .sav* files in current folder
listing = dir('*.sav*');

for i = 1:length(listing)
    name = listing(i).name;
    fprintf('Processing: %s\n', name);

    % Read file bytes
    fid = fopen(name, 'rb');
    if fid == -1
        warning('Could not open file: %s', name);
        continue;
    end
    a = fread(fid, inf, 'uint8');
    fclose(fid);

    % Compute number of 8x8 tiles (each tile is 16 bytes)
    tiles = floor(length(a) / 16);

    % Infer image height from total tiles and width
    PACKET_image_height = 8 * tiles / (PACKET_image_width / 8);

    if mod(PACKET_image_height, 8) ~= 0
        warning('Computed image height is not multiple of 8. Skipping: %s', name);
        continue;
    end

    % Decode tiles to image
    GB_tile = a(1:16*tiles);
    frame = ram_decode(GB_tile, PACKET_image_width, PACKET_image_height);

    % Convert Game Boy grayscale palette to 8-bit image
    % You can tweak these values for visual tone
    frame_png = uint8((frame == 3) * 255 + ...
                      (frame == 2) * 125 + ...
                      (frame == 1) * 80 + ...
                      (frame == 0) * 0);

    % Save PNG
    imwrite(frame_png, [name(1:end-4), '.png']);
    disp('RAM extracted and saved as PNG.');

    % Optional: Preview image
    figure(1);
    imagesc(frame);
    colormap gray;
    axis image off;
    title(['Frame from ', name]);
    drawnow;
end
