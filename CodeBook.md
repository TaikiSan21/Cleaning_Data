---
title: "CodeBook"
author: "Taiki Sakai"
date: "September 26, 2015"
output: html_document
---
### Data Transformation

Minimal transformations were performed on the initial dataset. Activity Labels were converted from
IDs 1-6 to descriptive variables (WALKING, etc.). For the tidy data set, the value in each cell
is the mean of all observations of that variable for each subject-activity pair. For example, if Subject
1 had 30 readings while walking, the average of those thirty would be the value in the tidy dataset. 

All other operations performed to get the tidy dataset were simply filtering and rearranging the original dataset,
and these operations are described in the README.md document.

### Variable descriptions

Subject ID: the ID number of the subject for that row of observations

ActivityName: the name of the activity during which the data was taken

For the remaining variables, the labels are created as follows:

* time refers to time-based data, ie. velocity or acceleration
* freq refers to frequency based data, ie. the fourier transform of the time data
* mean and std are the mean and standard deviation of all the samples for a given Subject, Activity pair
* x, y, and z denote the particular direction of the device reading
* Magnitude is the overall magnitude of the signal, derived from the x, y, z values
* Accel refers to readings from an accelerometer
* Gyro refers to readings from a gyroscope
* Body is the signal due to body movement read on the device
* Gravity is the signal due to gravty read on the device
* Jerk is a measure of the jerk calculated from the device readings. Variables without jerk are just acceleration readings.