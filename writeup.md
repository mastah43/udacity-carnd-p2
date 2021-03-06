# **Traffic Sign Recognition**

**Build a Traffic Sign Recognition Project**

The goals / steps of this project are the following:
* Load the data set (see below for links to the project data set)
* Explore, summarize and visualize the data set
* Design, train and test a model architecture
* Use the model to make predictions on new images
* Analyze the softmax probabilities of the new images
* Summarize the results with a written report


[//]: # (Image References)

[image1]: ./visualization/train_samples.png "Train Samples"
[image2]: ./visualization/train_class_distribution.png "Train Distribution by Class"
[image4]: ./test_images/stopsign-32.png "Stop Sign"
[image5]: ./test_images/noentry-32.png "No Entry Sign"
[image6]: ./test_images/30kmh-32.png "30 km/h Sign"
[image7]: ./test_images/70kmh-32.png "70 km/h Sign"
[image8]: ./test_images/80kmh-32.png "80 km/h Sign"
[softmax]: ./visualization/test_images_softmax.png "Softmax Results"
[feature_maps]: ./visualization/model_visualization.png "Feature Maps"


## Rubric Points
### Here I will consider the [rubric points](https://review.udacity.com/#!/rubrics/481/view) individually and describe how I addressed each point in my implementation.

---
### Writeup / README

#### 1. Provide a Writeup / README that includes all the rubric points and how you addressed each one. You can submit your writeup as markdown or pdf. You can use this template as a guide for writing the report. The submission includes the project code.

You're reading it! and here is a link to my [project code](https://github.com/mastah43/udacity-carnd-p2)

### Data Set Summary & Exploration

#### 1. Provide a basic summary of the data set. In the code, the analysis should be done using python, numpy and/or pandas methods rather than hardcoding results manually.

I used python standard library functions to calculate summary statistics of the traffic
signs data set:

* The size of training set is 34799 (without added augmented training samples)
* The size of the validation set is 4410
* The size of test set is 12630
* The shape of a traffic sign image is (32, 32, 3) meaning a width of 32, height of 32 and 3 channels (RGB)
* The number of unique classes/labels in the data set is 43

#### 2. Include an exploratory visualization of the dataset.

The following illustration shows one sample image per class of the training data set.

![alt text][image1]

The following illustration shows the number of training images per class. 
It is obvious that some classes like e.g. 0, 19 lack training samples 
that we need to create synthetically through data augmentation.

![alt text][image2]

### Design and Test a Model Architecture

#### 1. Describe how you preprocessed the image data. What techniques were chosen and why did you choose these techniques? Consider including images showing the output of each preprocessing technique. Pre-processing refers to techniques such as converting to grayscale, normalization, etc. (OPTIONAL: As described in the "Stand Out Suggestions" part of the rubric, if you generated additional data for training, describe why you decided to generate additional data, how you generated the data, and provide example images of the additional data. Then describe the characteristics of the augmented training set like number of images in the set, number of images for each class, etc.)

I used a modified LeNet model architecture with RGB images as input so I did not convert the images to grey scale.
To limit the effects of varying contrasts in data set images I used contrast limited adaptive histogram equalization.

I decided to generate additional data because the number of training images per class were strongly varying 
as depicted in the visualization above.
To add more data to the the data set, I used Keras to create additional training images that are randomly shifted, rotated, zoomed and sheared.
This augmentation was applied since it reflects differences when taking photos of traffic sign images.
For every class the augmentation makes sure that there are 5.000 training samples.
I also tried to add random gaussian noise but this lead to a worse model accuracy.

The difference between the original data set and the augmented data set
is the size of the training images as well as the pixel equalization.
Original training size is 34799 and augmented training size is 215000. 

Since image normalization and augmentation took some time to process 
I added a mechanism for caching results in pickled files.

#### 2. Describe what your final model architecture looks like including model type, layers, layer sizes, connectivity, etc.) Consider including a diagram and/or table describing the final model.

My final model consisted of the following layers. 
This matches the LeNet architecture except having input 3 instead of 1 input channel 
and having a final output size of 43:

| Layer         		|     Description	        					| 
|:---------------------:|:---------------------------------------------:| 
| Input         		| 32x32x3 RGB image   							| 
| Normalization         | normalize channel values to have zero mean    |
| Convolution 5x5     	| 1x1 stride, valid padding, outputs 28x28x6 	|
| RELU					|												|
| Max pooling	      	| 2x2 stride,  outputs 14x14x6 				    |
| Convolution 5x5	    | 1x1 stride, valid padding, outputs 10x10x16   |
| RELU					|												|
| Max pooling	      	| 2x2 stride,  outputs 5x5x16 				    |
| Flatten    	      	| convert 5x5x16 to 400               		    |
| Fully connected		| output 120   									|
| RELU					|												|
| Fully connected		| output 84   									|
| RELU					|												|
| Fully connected		| output 43   									|
| RELU					|												|

#### 3. Describe how you trained your model. The discussion can include the type of optimizer, the batch size, number of epochs and any hyperparameters such as learning rate.

To train the model, I used:
* learning rate: 0.001
* batch size: 128
* epochs: 10
* keep probability for the dropout on each layer: 0.7
* optimizer: Adam optimizer for stochastic gradient descent

I randomized the order of the training data set in every epoch to avoid effects of training data set order.


#### 4. Describe the approach taken for finding a solution and getting the validation set accuracy to be at least 0.93. Include in the discussion the results on the training, validation and test sets and where in the code these were calculated. Your approach may have been an iterative process, in which case, outline the steps you took to get to the final solution and why you chose those steps. Perhaps your solution involved an already well known implementation or architecture. In this case, discuss why you think the architecture is suitable for the current problem.

My final model results were:
* training set accuracy of 0.99
* validation set accuracy of 0.951
* test set accuracy of 0.947

The validation set accuracy is similar to the training set accuracy (only slightly lower).
The test set accuracy is similar to the validation set accuracy (only slightly lower).
This concludes that the model is slightly overfitted but the result is acceptable.

The LetNet model architecture was chosen. 

Slight modifications were made to LeNet:
* increase the number of input channels from 1 to 3 to handle RGB input
* normalize each channel of each input pixels to have zero mean and equal value ranges 
* change output layer size to 43 to match the number of traffic sign classes
* add drop out for every layer to reduce overfitting

Reason I used LeNet:
The LeNet architecture was originally designed for classifying letters / characters.
The relatively simple 2d shapes of german traffic signs are similar to to the shapes of arbitrary letters / characters.

Without drop out I achieved the following results:
* training set accuracy of 0.99
* validation set accuracy of 0.951
* test set accuracy of 0.947

So without drop out the training produced a significantly overfitted model.
This is why is used drop out to train the model.

I believe I could further improve the model by using greyscale to reduce to feature variety in the data set.

### Test a Model on New Images

#### 1. Choose five German traffic signs found on the web and provide them in the report. For each image, discuss what quality or qualities might be difficult to classify.

I downloaded 5 images from the internet:

![stop][image4] 
The stop sign could be difficult to predict since the sign was shot from a non directly front facing angle.

![no entry][image5] 
The no entry sign should be good to predict since shot was front facing, contrast is good.

![30 kmh][image6] 
The 30 km/h should be bit harder to predict since there is another sign on the top visible and there are also some distracting forms in the background.

![70 kmh][image7] 
The 70 km/h should be bit harder to predict since there is another sign on the bottom visible and there are also some trees in the background.

![80 kmh][image8]
The 80 km/h should be good to predict since contrast is good due to the background beeing only light grey sky.


#### 2. Discuss the model's predictions on these new traffic signs and compare the results to predicting on the test set. At a minimum, discuss what the predictions were, the accuracy on these new predictions, and compare the accuracy to the accuracy on the test set (OPTIONAL: Discuss the results in more detail as described in the "Stand Out Suggestions" part of the rubric).

Here are the results of the prediction:

| Image			        |     Prediction	        					| 
|:---------------------:|:---------------------------------------------:| 
| Stop Sign      		| Stop Sign   									| 
| No Entry     			| No entry 										|
| 30 km/h				| 30 km/h										|
| 70 km/h	      		| 70 km/h		    			 				|
| 80 km/h			    | 80 km/h             							|

The model was able to correctly guess 5 of the 5 traffic signs, which gives an accuracy of 100%.
This is higher then the test set accuracy of 0.947.

I also other test images from the GTSRB data set which were much harder to predict on but my model performed 
also quite well on them.

#### 3. Describe how certain the model is when predicting on each of the five new images by looking at the softmax probabilities for each prediction. Provide the top 5 softmax probabilities for each image along with the sign type of each probability. (OPTIONAL: as described in the "Stand Out Suggestions" part of the rubric, visualizations can also be provided such as bar charts)

The following image depicts the softmax outputs for each test image.

For image 1 (stop sign) and image 2 (no entry sign) - the model was very certain on its correct prediction (nearly one).
The quality of the images was good and shot from a front facing angle. Also those sign classes
are very different to other sign classes in the data set and thus good to predict.

For image 3 (30 km/h) the model was less sure on the correct prediction.
The speed sign for 30 km/h looks similar to 50 km/h and that is
what the models softmax outputs tell.

For image 4 (70 km/h) the model was very sure on the correct prediction.
The digit 7 looks a bit similar to digit 2 so this is the reason for the
model to list 20 km/h with the second highest although very low confidence.

For image 5 (80 km/h) the model less sure on the correct prediction
due to fact that 80 looks similar to 60 km/h.

To be more certain with speed sign prediction a specific model could
be trained only using speed signs. This speed sign model could then
be used if the confidence is not significant regarding multiple possible
outputs of speed signs. I think that this speed sign model would then
focus on features more distinguishing the different numbers on speed
signs.

![Softmax Results][softmax]

### (Optional) Visualizing the Neural Network (See Step 4 of the Ipython notebook for more details)

In the last step of the [jupyter notebook](Traffic_Sign_Classifier.html) the results depicts the the feature maps of my model
when predicting on the individual test images. The feature maps for layer 1 (convolution)
and layer 2 (convolution) are shown.

#### 1. Discuss the visual output of your trained network's feature maps. What characteristics did the neural network use to make classifications?

The feature maps from convolutional layer 1 show that the model uses the
boundary and shape of the sign as features since those pixels triggered
the activitation the most. For example, the no entry signs white horizontal
bar was taken completely as features.

