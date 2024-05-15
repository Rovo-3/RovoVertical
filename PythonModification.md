# Python Code Modification
Change Pymavlink connection, JSON path, and Key Button (optional) based on your current status of device (ROV output and Control unit name)

## Pymavlink Connection
Navigate to the mavlink connection [code](/vertical_movement_joystick/set_pitch_with_controller.py) and modify the pymavlink connection to the ROV.

![Mavlink Connection](./assets/mavlinkconnection.png)

# JSON path
[JSON file](/vertical_movement_joystick/verticalMode.json) by default is stored in the same path where the main script is located. If you extract this to desktop, the path should be like this 
`C:/Users/<yourcomputername>/Desktop/RovoVertical/vertical_movement_joystick/verticalMode.json`.

Search for `json_path` property in the `My_Joystick` class, and change it accordingly.


# Key Button Modification
On default, the key used to activate the vertical mode is by `shift` (key 10) + `B` (key 1) while the yaw using the `Left Joystick` (Axis 0) and pitch down and pitch up use the `LT` (key 2) and `RT` (key 5). You can change the key accordingly.

To know the key number and its type, go to `key_received` on the `My_joystick` class and uncomment the commented code.

![alt text](./assets/keyModifications.png)