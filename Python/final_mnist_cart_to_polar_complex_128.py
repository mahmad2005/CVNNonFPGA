# -*- coding: utf-8 -*-
"""Final_MNIST_Cart_to_Polar_Complex_128.ipynb

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/1aqK8wFTUnUualyTdjDGmn6Yw1SlyRD0r
"""

from google.colab import drive
drive.mount('/content/drive') #MNIST 2D dataset in .mat format
#download file
!gdown 1F_-g56Dg9cPxcqsWvHFCQsuFWXOapP2G

# install dependencies
!pip install scipy numpy
!pip install cvnn
!pip install tensorflow-addons

# import all dependencies
import scipy.io
import tensorflow as tf
from tensorflow.keras import datasets, layers, models
import cvnn.layers as complex_layers
import numpy as np
from cvnn import losses
from cvnn import metrics
from pdb import set_trace
from importlib import reload
import os
import tensorflow
from matplotlib import pyplot as plt
from tensorflow.keras.utils import to_categorical
from sklearn.model_selection import train_test_split
import time

"""#Preprocessing"""

# Load 2D MNIST dataset
#MNIST_2D_RAW = scipy.io.loadmat('/content/2d_mnist_data.mat')
MNIST_2D_RAW = scipy.io.loadmat(r'E:/...Your Directory.../2d_mnist_data.mat')
MNIST_2D_Train_images = MNIST_2D_RAW['train_images']
#print(MNIST_2D_RAW.shape)



import numpy as np
#import matplotlib.pyplot as plt
import cv2

# Function to perform the same operations as the MATLAB code
def mnist_polar_serial(image, NumberOfThetaRho):
    img = image.reshape(28, 28)

    import cv2
    # Decimation factor
    #M = 4/3

    # Calculate the new dimensions after downsampling
    #new_height = int(img.shape[0] / M)
    #new_width = int(img.shape[1] / M)

    # Down-sample the image
    #downsampled_img = cv2.resize(img, (new_width, new_height))

    # Replace the original image with the downsampled image
    #img = downsampled_img

    # Check if the image is not None and has three dimensions
    if img is not None and len(img.shape) == 3 and img.shape[2] == 3:
        # Convert to grayscale
        img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

    # Convert the image to double for calculations
    img_double = img.astype(np.float64)

    # Apply the logarithmic transformation
    #log_img = np.log1p(img_double)

    # Normalize the logarithmic image to the range [0, 255]
    #normalized_img = ((log_img - np.min(log_img)) / (np.max(log_img) - np.min(log_img))) * 255

    # Quantize the normalized image to 8 levels
    #quantized_img = np.round(normalized_img / 32) * 32  # 256/8 = 32

    #img = quantized_img

    # Step 1: Convert pixel values to 8 intensity levels using logarithmic transformation
    log_image = np.log2(img_double + 1)  # Add 1 to avoid log(0)
    # Normalize the logarithmic image to the range [0, 7] and round to get 8 intensity levels
    intensity_levels = np.round((log_image / np.max(log_image)) * 7).astype(np.uint8)

    # Step 2: Highlight the pixels with the highest intensity (8th intensity level)
    highlighted_contour = np.where(intensity_levels == 7, 255, 0).astype(np.uint8)
    img = highlighted_contour

    # Decimation factor
    M = 4/3

    # Calculate the new dimensions after downsampling
    new_height = int(img.shape[0] / M)
    new_width = int(img.shape[1] / M)

    # Down-sample the image
    downsampled_img = cv2.resize(img, (new_width, new_height))

    # Replace the original image with the downsampled image
    img = downsampled_img

    # Cartesian to Polar plane conversion
    rows, cols = img.shape
    centerX = cols / 2
    centerY = rows / 2

    X, Y = np.meshgrid(np.arange(1, cols + 1), np.arange(1, rows + 1))
    X = X - centerX
    Y = centerY - Y

    theta = np.arctan2(Y, X)
    rho = np.sqrt(X**2 + Y**2)

    theta_rho_pairs = []

    for i in range(rows):
        for j in range(cols):
            if img[i, j] > 0:
                theta_rho_pairs.append([theta[i, j], rho[i, j]])

    # Convert theta_rho_pairs to a NumPy array
    theta_rho_pairs = np.array(theta_rho_pairs)

    # Normalize the rho values
    maxRho = np.max(theta_rho_pairs[:, 1])
    minRho = 0  # Set the minimum rho value as needed
    theta_rho_pairs[:, 1] = (theta_rho_pairs[:, 1] - minRho) / (maxRho - minRho)

    # Show the normalized polar plot
    #plt.figure(figsize=(8, 8))
    #plt.polar(theta_rho_pairs[:, 0], theta_rho_pairs[:, 1], 'o')

    # Rearrange the theta-rho pairs in descending order by rho values
    #sorted_theta_rho_pairs = theta_rho_pairs[theta_rho_pairs[:, 1].argsort()[::-1]]
    # Rearrange the theta-rho pairs in ascending order by theta values
    #sorted_theta_rho_pairs = theta_rho_pairs[theta_rho_pairs[:, 0].argsort()]

    # Number of ThetaRho values to be taken
    if len(theta_rho_pairs) < NumberOfThetaRho:
        zeroPadding = np.pad(theta_rho_pairs, ((0, NumberOfThetaRho - len(theta_rho_pairs)), (0, 0)), 'constant')
    else:
        zeroPadding = np.array(theta_rho_pairs)

    zeroPadding = zeroPadding[zeroPadding[:, 0].argsort()]

    zeroPadTheta = zeroPadding[:NumberOfThetaRho, 0]
    zeroPadRho = zeroPadding[:NumberOfThetaRho, 1]

    # Convert polar data to complex numbers
    z = zeroPadRho * np.exp(1j * zeroPadTheta)

    # Compute DFT
    N = len(z)
    Xk = np.zeros(N, dtype=np.complex128)

    for k in range(N):
        Xk[k] = np.sum(z * np.exp(-1j * 2 * np.pi * k * np.arange(N) / N))

    return Xk



####################### Train

MNIST = MNIST_2D_Train_images
# Assuming MNIST is a NumPy array with shape (num_samples, 784) where each row represents an image
inputEntry = 128
serialThetaRho = np.zeros((MNIST.shape[0], inputEntry), dtype=np.complex128)

for i in range(MNIST.shape[0]):
    image = MNIST[i, :]
    serialThetaRho[i, :] = mnist_polar_serial(image, inputEntry)

# Save the result to a text file
np.savetxt("serialThetaRho_Train.txt", serialThetaRho)


####################### Test

MNIST_2D_Test_images = MNIST_2D_RAW['test_images']

MNIST = MNIST_2D_Test_images
# Assuming MNIST is a NumPy array with shape (num_samples, 784) where each row represents an image
#inputEntry = 128
serialThetaRhoTest = np.zeros((MNIST.shape[0], inputEntry), dtype=np.complex128)

for i in range(MNIST.shape[0]):
    image = MNIST[i, :]
    serialThetaRhoTest[i, :] = mnist_polar_serial(image, inputEntry)

# Save the result to a text file
np.savetxt("serialThetaRho_Test.txt", serialThetaRhoTest)




####################### Train Label

#mnist_label_mat = scipy.io.loadmat('/content/mnist_train_lbel.mat')
mnist_train_label_raw = MNIST_2D_RAW['train_labels']
mnist_train_label_rehaped = np.reshape(mnist_train_label_raw, (60000))
mnist_train_label = to_categorical(mnist_train_label_rehaped, 10)
print(mnist_train_label.shape)

"""#Training"""

def own_complex_fit(train_images, train_labels, val_images, val_labels, epochs=10):
    tf.random.set_seed(1)
    init = 'ComplexGlorotUniform'
    acti = 'crelu'
    model = models.Sequential()
    model.add(complex_layers.ComplexInput(input_shape=(128, )))                     # Always use ComplexInput at the start
    model.add(complex_layers.ComplexDense(20, activation=acti, kernel_initializer=init))
    model.add(complex_layers.ComplexDense(10, activation='cart_softmax', kernel_initializer=init))
    print(model.summary())


    model.compile(optimizer='Adam',
                  loss=losses.ComplexAverageCrossEntropy(),
                  metrics=metrics.ComplexCategoricalAccuracy())

    start_time = time.time()
    history = model.fit(train_images, train_labels, epochs=epochs, validation_data=(val_images, val_labels),batch_size=32)
    end_time = time.time()
    training_duration = end_time - start_time
    return history, model, training_duration



train_images, val_images, train_labels, val_labels = train_test_split(serialThetaRho, mnist_train_label, test_size=0.02, random_state=42)
epochs=50
[history, model, duration] = own_complex_fit(train_images, train_labels, val_images, val_labels, epochs)
print(f"Training took {duration:.2f} seconds.")

model.save_weights('model_weights_128.h5')
#%cp /content/model_weights_128.h5 /content/drive/MyDrive/MSresearch/model_weights_128.h5

"""#Testing"""

#%cp /content/drive/MyDrive/MSresearch/model_weights_64.h5 /content/model_weights_64.h5
import time

init = 'ComplexGlorotUniform'
acti = 'crelu'

model_1 = models.Sequential()
model_1.add(complex_layers.ComplexInput(input_shape=(128, )))                     # Always use ComplexInput at the start
model_1.add(complex_layers.ComplexDense(20, activation=acti, kernel_initializer=init))
model_1.add(complex_layers.ComplexDense(10, activation='cart_softmax', kernel_initializer=init))

model_1.load_weights('model_weights_128.h5')
model_1.summary()



#get int label
#test_mnist_label_mat = scipy.io.loadmat('/content/mnist_test_label.mat')
mnist_test_label_raw = MNIST_2D_RAW['test_labels']
gt_int_list = list(np.reshape(mnist_test_label_raw, (10000)))
print(type(gt_int_list))
print(len(gt_int_list))
print(type(gt_int_list[0]))

start_time = time.time()
batch_size = 124  # or whatever batch size you prefer
predictions = model_1.predict(serialThetaRhoTest, batch_size=batch_size)
end_time = time.time()
inference_duration = end_time - start_time
print(f"Inference took {inference_duration:.2f} seconds.")



pred_int_list = []
for each_pred in predictions:
  temp_pred_int = np.argmax(np.abs(each_pred))
  pred_int_list.append(temp_pred_int)

print(len(pred_int_list))



from sklearn.metrics import classification_report

target_names = list(set(gt_int_list)).sort()
print(classification_report(gt_int_list, pred_int_list, labels=target_names))




from sklearn.metrics import confusion_matrix, ConfusionMatrixDisplay

cm = confusion_matrix(gt_int_list, pred_int_list, labels=target_names)
disp = ConfusionMatrixDisplay(confusion_matrix=cm, display_labels=target_names)
cmap = 'Blues'

# Plot the confusion matrix with the specified colormap
disp.plot(cmap=cmap)
plt.savefig("ConfusionMatrix_Polar_Complex_128_20N.jpg", dpi=600)

"""#Inference Time Measurement"""

init = 'ComplexGlorotUniform'
acti = 'crelu'

model_1 = models.Sequential()
model_1.add(complex_layers.ComplexInput(input_shape=(128, )))                     # Always use ComplexInput at the start
model_1.add(complex_layers.ComplexDense(20, activation=acti, kernel_initializer=init))
model_1.add(complex_layers.ComplexDense(10, activation='cart_softmax', kernel_initializer=init))

model_1.load_weights('model_weights_128.h5')

#get int label
#test_mnist_label_mat = scipy.io.loadmat('/content/mnist_test_label.mat')
mnist_test_label_raw = MNIST_2D_RAW['test_labels']
gt_int_list = list(np.reshape(mnist_test_label_raw, (10000)))

# Load your data (replace this with your actual data loading code)
#SerialRealValuedTestData = ...

# Transfer the data to the GPU if available
with tf.device("/GPU:0"):
    start_time = time.time()
    batch_size = 124  # or whatever batch size you prefer
    predictions = model_1.predict(serialThetaRhoTest, batch_size=batch_size)
    end_time = time.time()
    inference_duration = end_time - start_time
    print(f"Inference took {inference_duration:.2f} seconds.")