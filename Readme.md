# Assignment CO3037 🤖🤖🤖


## 1. Requirement environment 📑
- *Python*: 3.12
- *pip*

## 2. Setup project 🧱

### 2.1. Setup and run gate way 📡📡📡
1. Create isolating enviroment for the project:
```console
python3.12 -m venv project_env
```
For more detail about virtual enviroment in python. Please referrence: [Creation of virtual environments](https://docs.python.org/3/library/venv.html)

2. Activate project enviroment.

3. Install all necessary packages for project
```console
pip install -r requirements.txt
```

4. create **.env** file with following structure to store key:  🤐🤐🤐🤐
```console
ADAFRUIT_IO_USERNAME= <adafruit_io_username>
ADAFRUIT_IO_PASSWORD= <adafruit_io_password>
LISTEN_IOT_GATE= <adafruit_io_feed_id_1>
RESPONSE_IOT_GATE= <adafruit_io_feed_id_2>
```

5. To run project by the following command: 🚀🚀🚀🚀
```console
python main.py
```

### 2.2. Setup mobile device 📱📱📱
There are two way in order to setup device
#### 2.2.1 Use Android Studio's virtual device to compile source code ☁️☁️☁️

1. Install Android Studio IDE according to instructions at:
[https://developer.android.com/studio?hl=vi](https://developer.android.com/studio?hl=vi)

2. Next install the Dart programming language according to the instructions at: 
[https://dart.dev/get-dart](https://dart.dev/get-dart)

3. Install Flutter and check requirements to create a Flutter Project with Android Studio according to the instructions at: 
[https://docs.flutter.dev/get-started/install/windows/mobile?tab=physical](https://docs.flutter.dev/get-started/install/windows/mobile?tab=physical)

4. Create a virtual mobile device in Android Studio following the instructions at:
[https://developer.android.com/studio/run/managing-avds](https://developer.android.com/studio/run/managing-avds)

5. Open Project smart_farm (source code is provided in the [Github link here](https://github.com/LeoPkm2-1/IOT_Project_CO3037/tree/main) ) and create file `smart_farm\lib\consts.dart` to store your private key for project  in the following structure:

```console
const OPENWEATHER_API_KEY = <OPENWEATHERMAP_API_KEY>;
const ADAFRUIT_IO_USERNAME = <ADAFRUIT_IO_USERNAME>;
const ADAFRUIT_IO_PASSWORD = <ADAFRUIT_IO_PASSWORD>;
const LISTEN_IOT_GATE = <ADAFRUIT_IO_FEED_ID_1>;
const RESPONSE_IOT_GATE = <ADAFRUIT_IO_FEED_ID_2>;
```

6. Open the virtual device and run the command below in Terminal. Or press the Run button in the Android Studio IDE. The application will be installed onto the virtual device.

```console
cd [project]
flutter install
```

#### 2.2.2. Install the APK file onto a real Android device  📱📱📱
1. Download the app-release.apk file in the `smart_farm\release-apk` folder to your device :point_down::point_down::point_down:.

2. Go to `Settings > Apps > Menu > Special access > Install` unknown apps and enable the option for your browser or file manager to install APK files outside of CH Play.

3. Open the downloaded APK file and follow the installation steps.