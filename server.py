from flask import Flask, request, send_file
from rembg import remove
from PIL import Image
import io

app = Flask(__name__)

@app.route('/remove_bg', methods=['POST'])
def remove_background():
    # request to get image
    file = request.files['image']
    input_data = file.read()
    
    output_data = remove(input_data)

    # Save Image
    output_image = Image.open(io.BytesIO(output_data))
    img_byte_arr = io.BytesIO()
    output_image.save(img_byte_arr, format='PNG')
    img_byte_arr.seek(0)

    # return image
    return send_file(img_byte_arr, mimetype='image/png')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
