# Assignment CO3037 🤖🤖🤖


## Requirement environment 📑
- *Python*: 3.12
- *pip*

## Setup and run project
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

4. create **.env** file with following structure to store key:
```console
ADAFRUIT_IO_USERNAME= <adafruit_io_username>
ADAFRUIT_IO_PASSWORD= <adafruit_io_password>
LISTEN_IOT_GATE= <adafruit_io_feed_id_1>
RESPONSE_IOT_GATE=<adafruit_io_feed_id_2>
```

5. To run project by the following command:
```console
python main.py
```