function GB_pixels = ram_decode(GB_tile, PACKET_image_width, PACKET_image_height)
    % Compute number of tiles
    num_tiles = length(GB_tile) / 16;
    tiles_per_row = PACKET_image_width / 8;

    % Reshape raw bytes into 16 x num_tiles matrix
    tile_bytes = reshape(GB_tile, 16, num_tiles);

    % Split into low and high bitplanes (8x8 pixels per tile)
    byte1s = tile_bytes(1:2:end, :);  % LSBs
    byte2s = tile_bytes(2:2:end, :);  % MSBs

    % Prepare decoded tile storage
    tile_data = zeros(8, 8, num_tiles, 'uint8');

    % For each of 8 rows in tile
    for row = 1:8
        bits1 = zeros(8, num_tiles);  % LSB plane
        bits2 = zeros(8, num_tiles);  % MSB plane

        for b = 1:8
            bits1(b, :) = bitget(byte1s(row, :), 9 - b);  % LSBs
            bits2(b, :) = bitget(byte2s(row, :), 9 - b);  % MSBs
        end

        % Reshape to (1 x 8 x num_tiles) to match output format
        bits1 = reshape(bits1, [1, 8, num_tiles]);
        bits2 = reshape(bits2, [1, 8, num_tiles]);

        % Combine 2-bit pixel values
        tile_data(row, :, :) = uint8(2 * bits2 + bits1);
    end

    % Allocate full image
    GB_pixels = zeros(PACKET_image_height, PACKET_image_width, 'uint8');

    % Place each tile into its position in the image
    for k = 1:num_tiles
        tile_x = mod(k - 1, tiles_per_row) * 8 + 1;
        tile_y = floor((k - 1) / tiles_per_row) * 8 + 1;
        GB_pixels(tile_y:tile_y+7, tile_x:tile_x+7) = tile_data(:, :, k);
    end

    % Flip pixel values for correct palette mapping
    GB_pixels = 3 - GB_pixels;
end

