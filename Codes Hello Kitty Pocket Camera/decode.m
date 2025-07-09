function GB_pixels = decode(GB_tile)
    PACKET_image_width = 128;
    PACKET_image_height = 112;
    PACKET_image = zeros(PACKET_image_height, PACKET_image_width, 'uint8');

    pos = 1;
    tile_count = 0;
    height = 1;
    width = 1;

    while tile_count < 224
        % Extract 16 bytes for the tile (2 bytes per row * 8 rows)
        tile_bytes = GB_tile(pos : pos + 15);
        pos = pos + 16;

        % Split into low and high bytes per row
        byte1 = tile_bytes(1:2:end); % odd indices, low bitplane bytes
        byte2 = tile_bytes(2:2:end); % even indices, high bitplane bytes

        % Preallocate tile matrix
        tile = zeros(8, 8, 'uint8');

        % For each bit position (from MSB=8 down to LSB=1), extract bits in vector
        for bit_idx = 8:-1:1
            low_bits = bitget(byte1, bit_idx);
            high_bits = bitget(byte2, bit_idx);

            % Place pixels in the correct column (bit position maps to column)
            % Note: bits go from MSB (bit 8) on the left to LSB (bit 1) on right
            col = 9 - bit_idx;
            tile(:, col) = low_bits + 2 * high_bits;
        end

        % Place decoded tile into image
        PACKET_image(height:height+7, width:width+7) = tile;

        tile_count = tile_count + 1;
        width = width + 8;
        if width > PACKET_image_width
            width = 1;
            height = height + 8;
        end
    end

    GB_pixels = 3 - PACKET_image;
end

