from PIL import Image
from typing import List


def mirror(raw)-> None:
    """
    Assume raw is image data. Modifies raw by reversing all the rows
    of the data.

    raw = [[[233, 100, 115], [0, 0, 0], [255, 255, 255]],
               [[199, 201, 116], [1, 9, 0], [255, 255, 255]]]
    mirror(raw)
    raw
    [[[255, 255, 255], [0, 0, 0], [233, 100, 115]],
     [[255, 255, 255], [1, 9, 0], [199, 201, 116]]]
    """

    for row in raw:
        row.reverse() # No return needed since list is mutated


def grey(raw)-> None:
    """
    Assume raw is image data. Modifies raw "averaging out" each
    pixel of raw. Specifically, for each pixel it totals the RGB
    values, integer divides by three, and sets the all RGB values
    equal to this new value

    >>> raw = [[[233, 100, 115], [0, 0, 0], [255, 255, 255]],
               [[199, 201, 116], [1, 9, 0], [255, 255, 255]]]
    >>> grey(raw)
    >>> raw
    [[[149, 149, 149], [0, 0, 0], [255, 255, 255]],
     [[172, 172, 172], [3, 3, 3], [255, 255, 255]]]
    """
    for row in raw:
         for i in range(len(row)):
            average = sum(row[i]) // 3 # takes average of the RGB in given pixel
            row[i] = [average, average, average] 
            # stores that average into all color values 
            # (same RGB values makes a shade of gray)


def invert(raw):
    """
    Assume raw is image data. Modifies raw inverting each pixel.
    To invert a pixel, you swap all the max values, with all the
    minimum values. See the doc tests for examples.

    >>> raw = [[[233, 100, 115], [0, 0, 0], [255, 255, 0]],
               [[199, 201, 116], [1, 9, 0], [255, 100, 100]]]
    >>> invert(raw)
    >>> raw
    [[[100, 233, 115], [0, 0, 0], [0, 0, 255]],
     [[199, 116, 201], [1, 0, 9], [100, 255, 255]]]
    """

    for row in raw:
        for i in range(len(row)):
            pixel = row[i]

            sorted_pixel = sorted(pixel) #Numerically sort RGB values from lowest to highest
            min_val, middle_val, max_val = sorted_pixel[0], sorted_pixel[1], sorted_pixel[2] # assign values

            new_pixel = []
            for value in pixel:
                if value == min_val: #switching min and max RGB values
                    new_pixel.append(max_val)
                elif value == max_val:
                    new_pixel.append(min_val)
                else:
                    new_pixel.append(middle_val) #whatever is left stays the same

            row[i] = new_pixel


def merge(raw1, raw2):
    # Determine the maximum dimensions for the new image
    height = max(len(raw1), len(raw2))
    width = max(len(raw1[0]), len(raw2[0]))

    merged = []

    for i in range(height):
        row = []
        for j in range(width):
            # Initialize default pixel as black
            pixel = [0, 0, 0]

            # Fetch pixels from raw1 and raw2 if available
            pixel1 = raw1[i][j] if i < len(raw1) and j < len(raw1[0]) else None
            pixel2 = raw2[i][j] if i < len(raw2) and j < len(raw2[0]) else None

            # Apply merge rules
            if pixel1 and pixel2:
                pixel = pixel1 if i % 2 == 0 else pixel2  # Alternate rows
            elif pixel1:
                pixel = pixel1  # Use raw1 pixel if raw2 pixel is missing
            elif pixel2:
                pixel = pixel2  # Use raw2 pixel if raw1 pixel is missing

            row.append(pixel)
        merged.append(row)

    return merged



def compress(raw):
    """
    Compresses raw by going through the pixels and combining a pixel with
    the ones directly to the right, below and diagonally to the lower right.
    For each RGB values it takes the average of these four pixels using integer
    division. If is is a pixel on the "edge" of the image, it only takes the
    relevant pixels to average across. See the second doctest for an example of
    this.

    >>> raw = [[[233, 100, 115], [0, 0, 0], [255, 255, 0], [3, 6, 7]],
               [[199, 201, 116], [1, 9, 0], [255, 100, 100], [99, 99, 0]],
               [[200, 200, 200], [1, 9, 0], [255, 100, 100], [99, 99, 0]],
               [[50, 100, 150], [1, 9, 0], [211, 5, 22], [199, 0, 10]]]
    >>> raw1 = compress(raw)
    >>> raw1
    [[[108, 77, 57], [153, 115, 26]],
     [[63, 79, 87], [191, 51, 33]]]

    >>> raw = [[[233, 100, 115], [0, 0, 0], [255, 255, 0]],
               [[199, 201, 116], [1, 9, 0], [255, 100, 100]],
               [[123, 233, 151], [111, 99, 10], [0, 1, 1]]]
    >>> raw2 = compress(raw)
    >>> raw2
    [[[108, 77, 57], [255, 177, 50]],
     [[117, 166, 80], [0, 1, 1]]]
    """
    compressed = []
    height = len(raw)
    width = len(raw[0])

    for i in range(0, height, 2): # Considering a 2 x 2 block of pixels
        compressed_row = []
        for j in range(0, width, 2):
           
            r = g = b = count = 0

            # 4 possible configurations for a pixel

            # Current pixel
            r += raw[i][j][0]
            g += raw[i][j][1]
            b += raw[i][j][2]
            count += 1

            # pixel to the right
            if j + 1 < width:
                r += raw[i][j + 1][0]
                g += raw[i][j + 1][1]
                b += raw[i][j + 1][2]
                count += 1

            # pixel to the bottom
            if i + 1 < height:
                r += raw[i + 1][j][0]
                g += raw[i + 1][j][1]
                b += raw[i + 1][j][2]
                count += 1

            # bottom right pixel
            if i + 1 < height and j + 1 < width:
                r += raw[i + 1][j + 1][0]
                g += raw[i + 1][j + 1][1]
                b += raw[i + 1][j + 1][2]
                count += 1

            avg_r = r // count
            avg_g = g // count
            avg_b = b // count

            compressed_row.append([avg_r, avg_g, avg_b])
        
        compressed.append(compressed_row)

    return compressed



"""
**********************************************************

Do not worry about the code below. However, if you wish,
you can use it to read in images, modify the data, and save
new images.

**********************************************************
"""

def get_raw_image(name)-> List[List[List[int]]]:
    
    image = Image.open(name)
    num_rows = image.height
    num_columns = image.width
    pixels = image.getdata()
    new_data = []
    
    for i in range(num_rows):
        new_row = []
        for j in range(num_columns):
            new_pixel = list(pixels[i*num_columns + j])
            new_row.append(new_pixel)
        new_data.append(new_row)

    image.close()
    return new_data


def image_from_raw(raw: List[List[List[int]]], name: str)->None:
    image = Image.new("RGB", (len(raw[0]),len(raw)))
    pixels = []
    for row in raw:
        for pixel in row:
            pixels.append(tuple(pixel))
    image.putdata(pixels)
    image.save(name)


# # TO ACTUALY RUN THE PICTURES AND ALTER THEM
def main():
    name = input("Enter the image filename: ")
    new_data = get_raw_image(name)

    print("How would you like to alter the image?")
    print("1. Mirror")
    print("2. Grey (Grayscale)")
    print("3. Invert Colors")
    print("4. merge")
    print("5. Compress")
    choice = int(input("Enter the number of your choice: "))

    match choice:
        case 1:
            mirror(new_data)
            output_name = "mirrored_" + name
        case 2:
            grey(new_data)
            output_name = "grey_" + name
        case 3:
            invert(new_data)
            output_name = "inverted_" + name
        case 4:
            second_image_name = input("Enter the second image filename for merging (e.g., other.png): ")
            second_data = get_raw_image(second_image_name)

            new_data = merge(new_data, second_data)  
            output_name = f"merged_{name.split('.')[0]}_{second_image_name.split('.')[0]}.png"
        case 5:
            new_data = compress(new_data)
            output_name = "compressed_" + name
        case _:
            print("Invalid choice. Exiting.")
            return

    image_from_raw(new_data, output_name)
    print(f"Image saved as {output_name}")

if __name__ == "__main__":
    main()