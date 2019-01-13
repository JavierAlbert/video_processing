

# Video Processing

The goal of this project is to take a short video of a walking person, stabilize the video, cut the background, replace the background and track the moving person.

## Input frame

![1](https://user-images.githubusercontent.com/31891596/51084006-d10f8a80-172b-11e9-91d9-52cc8787f40d.JPG)


## Video stabilization & Background substraction

We use Lucas-Kanade optical flow for stabilization. Then we use a combination of median filter, borders removal, image eroding and image dilatation.

![2](https://user-images.githubusercontent.com/31891596/51084005-d10f8a80-172b-11e9-91b2-e5bb505e3edf.JPG)
![3](https://user-images.githubusercontent.com/31891596/51084004-d076f400-172b-11e9-923c-8e7d58ef6247.JPG)
![4](https://user-images.githubusercontent.com/31891596/51084003-d076f400-172b-11e9-8fa6-a57f6be5ad37.JPG)
![5](https://user-images.githubusercontent.com/31891596/51084002-d076f400-172b-11e9-8136-432a96a6b74e.JPG)


## Matting by trimap image

![6](https://user-images.githubusercontent.com/31891596/51084001-d076f400-172b-11e9-9699-aad3b912974d.JPG)


## Tracking using particles filter

![7](https://user-images.githubusercontent.com/31891596/51084000-cfde5d80-172b-11e9-9d52-3fbcd45f6802.JPG)


## GUI

![8](https://user-images.githubusercontent.com/31891596/51084007-d10f8a80-172b-11e9-985c-91d063862c21.JPG)
