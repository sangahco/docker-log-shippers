# Filebeat setup & run instructions


Test if *git*, *Docker* and *Docker Compose* are installed

![GitHub Logo](doc/ice_screenshot_20170315-113328.png)

---

Install Docker Compose

![GitHub Logo](doc/ice_screenshot_20170315-113520.png)

---

From our github page go to the repository *docker-log-shippers*

![GitHub Logo](doc/ice_screenshot_20170315-113632.png)

---

Click the button *Clone or download* and copy the url tha show up.

![GitHub Logo](doc/ice_screenshot_20170315-113753.png)

---

From the home folder of the user run `git clone` with the url copied
and a new directory will be created just under the current one.

![GitHub Logo](doc/ice_screenshot_20170315-113831.png)

---

Explore the folder structure and you will notice a file named `.env`,
here you find all the variables required to run the service.

**Don't edit this file, these are default values only**

![GitHub Logo](doc/ice_screenshot_20170315-114057.png)

---

Copy the key value from inside the file and we are going to put them on another file.

![GitHub Logo](doc/ice_screenshot_20170315-114228.png)

---

Put the copied content inside the file `~/.bashrc`
and add a prefix `export` to them and change the values accordingly.

![GitHub Logo](doc/ice_screenshot_20170315-114757.png)

---

With the command below you set those variables to the new values.

![GitHub Logo](doc/ice_screenshot_20170315-114845.png)

---

Almost ready to run the service, go to the service folder
and you see two files `docker-auto.sh` and `docker17-auto.sh`.

**If on Centos 7 or Ubuntu use the former otherwise if on Centos 7 the latter**

![GitHub Logo](doc/ice_screenshot_20170315-114949.png)

---

Run the script without passing parameters and you will be presented with an help message.

![GitHub Logo](doc/ice_screenshot_20170315-115406.png)

---

Run the service with the command below.
If is the first time you use docker on this machine, you might have the error shown on the image.
It means you need to login to our registry first.

![GitHub Logo](doc/ice_screenshot_20170315-115547.png)

---

Login to our registry with the following commands, and make sure it ends with the message
*Login Succeded*.

![GitHub Logo](doc/ice_screenshot_20170315-115611.png)

---

Start the service with the command below.

![GitHub Logo](doc/ice_screenshot_20170315-115719.png)

---

Show the services status with the following command.

![GitHub Logo](doc/ice_screenshot_20170315-115804.png)

---

Follow the logs

![GitHub Logo](doc/ice_screenshot_20170315-115851.png)

---

Stop the service.

![GitHub Logo](doc/ice_screenshot_20170315-115955.png)

---

Done start logging!