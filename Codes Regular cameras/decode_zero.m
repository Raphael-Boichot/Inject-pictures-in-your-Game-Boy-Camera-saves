function GB_pixels = decode_zero(GB_tile)
    PACKET_image_width = 128;
    PACKET_image_height = 128;
    PACKET_image = zeros(PACKET_image_height, PACKET_image_width, 'uint8');

    pos = 1;

    for tile_count = 0:255
        % Extract 16 bytes per tile (2 bytes per row * 8 rows)
        tile_bytes = GB_tile(pos : pos + 15);
        pos = pos + 16;

        byte1 = tile_bytes(1:2:end); % low bitplane bytes for each row
        byte2 = tile_bytes(2:2:end); % high bitplane bytes for each row

        tile = zeros(8, 8, 'uint8');

        % Extract bits for each column (bit 8 to bit 1)
        for bit_idx = 8:-1:1
            low_bits = bitget(byte1, bit_idx);
            high_bits = bitget(byte2, bit_idx);
            col = 9 - bit_idx; % MSB at leftmost column

            tile(:, col) = low_bits + 2 * high_bits;
        end

        % Calculate row and column to place tile in PACKET_image
        row = floor(tile_count / 16) * 8 + 1;
        col = mod(tile_count, 16) * 8 + 1;
        PACKET_image(row:row+7, col:col+7) = tile;
    end

    GB_pixels = 3 - PACKET_image;
end

