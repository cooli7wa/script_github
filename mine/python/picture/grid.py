
import cv2
import numpy as np

GRID_NUM = 7

img = cv2.imread("/home/cooli7wa/Desktop/test1.png")
img_shape = img.shape
grid_x = img_shape[0] // GRID_NUM
grid_y = img_shape[1] // GRID_NUM
for i in range(1, GRID_NUM):
    x = grid_x * i
    y = grid_y * i
    img = cv2.line(img, (0,x), (img_shape[1],x), (0,0,0), 5)
    img = cv2.line(img, (y,0), (y,img_shape[0]), (0,0,0), 5)
# cv2.imshow("",img)
# cv2.waitKey(0)
cv2.imwrite('aa.png', img)
