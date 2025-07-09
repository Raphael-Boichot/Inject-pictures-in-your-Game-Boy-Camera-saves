function GB_tile = encode(a)
    [height, width, ~] = size(a);

    % Identify unique grayscale levels
    C = unique(a(:));
    if length(C) == 2
        Black = C(1); Dgray = C(2); Lgray = Dgray; White = Dgray;
    else
        Black = C(1); Dgray = C(2); Lgray = C(3); White = C(4);
    end

    % Compute number of tiles
    hor_tile = width / 8;
    vert_tile = height / 8;
    total_tiles = hor_tile * vert_tile;

    % Preallocate output
    GB_tile = zeros(total_tiles * 16, 1, 'uint8');  % 2 bytes per row × 8 rows per tile

    tile_idx = 1;

    % Power-of-two weights for binary to byte conversion
    weights = uint8(2.^(7:-1:0));

    % Process each tile
    for y = 1:8:height
        for x = 1:8:width
            block = a(y:y+7, x:x+7);
            for row = 1:8
                pixels = block(row, :);

                % Create 2-bit Game Boy bitplanes from pixel intensity
                % 1st bitplane (MSB)
                bit1 = (pixels == Black) | (pixels == Lgray);

                % 2nd bitplane (LSB)
                bit2 = (pixels == Black) | (pixels == Dgray);

                % Element-wise multiply and sum
                byte1 = sum(uint8(bit1) .* weights);
                byte2 = sum(uint8(bit2) .* weights);

                % Store the two bytes for this row
                GB_tile(tile_idx)     = byte1;
                GB_tile(tile_idx + 1) = byte2;

                tile_idx += 2;
            end
        end
    end
end

