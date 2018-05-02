#coding:utf-8
from PIL import Image, ImageDraw, ImageFont

class PictureException(Exception):
    def __init__(self,err='图片拼接错误'):
        Exception.__init__(self,err)

def StitchPictures(images, out_path, mode='V', quality=100):
    images_number = len(images)
    image_files = []
    for i in range(images_number):
        image_ori = Image.open(images[i])
        # fnt = ImageFont.truetype('STENCIL.TTF', 100)
        # d = ImageDraw.Draw(image_ori)
        # d.text((50, 50), "JP" + str(i), font=fnt, fill=(0, 0, 0, 0))
        image_files.append(image_ori)
    per_image_size = image_files[0].size
    if mode == 'H':
        out_image_size = (per_image_size[0]*images_number, per_image_size[1])
    elif mode == 'V':
        out_image_size = (per_image_size[0], per_image_size[1]*images_number)
    else:
        raise PictureException
    target = Image.new('RGB', out_image_size)
    left = 0
    upper = 0
    right = per_image_size[0]
    lower = per_image_size[1]
    for i in range(images_number):
        target.paste(image_files[i], (left, upper, right, lower))
        if mode == 'H':
            left += per_image_size[0]
            right += per_image_size[0]
        else:
            upper += per_image_size[1]
            lower += per_image_size[1]
    target.save(out_path, quality=quality)

images = ('step1.jpg', 'step2.jpg', 'step2_1.jpg', 'step3.jpg')
StitchPictures(images, 'result.jpg', quality=10)

