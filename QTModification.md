# QT BackEnd Modification
These steps are mandatory if you want to integrate the python control code to the QGC. QGC will show whether the cleaning mode is activated or not, and enables activation of the cleaning mode by GUI.

If this step is not followed, cleaning mode activation will only be available by joystick controls (not GUI).

Ensure that QGC QT project can be accessed and follow the steps below to do QGC and Python Control Integration.

## 1. Modification to Vehicle.h
Navigate and open `Vehicle.h`, insert this 2 line of code inside `Vehicle` class >> `Public` <br>

```
1    Q_INVOKABLE QJsonObject readJsonFile(QString path);
2    Q_INVOKABLE void updateJsonData(QString path, QString key, int data);
```

Example:
![alt text](./assets/vehicleh.png)

## 2. Modification to Vehicle.cc
Navigate and open `Vehicle.cc`, and insert these lines of codes:
```
QJsonObject Vehicle::readJsonFile(QString path){
    QFile file(path);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qDebug() << "Failed to open file";
    }
    QJsonDocument doc = QJsonDocument::fromJson(file.readAll());
    file.close();
    QJsonObject json = doc.object();
    return json; //return json data
}

void Vehicle::updateJsonData(QString path, QString key, int data){
    QFile file(path);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qDebug() << "Failed to open file to read";
        return;
    }
    QJsonDocument doc = QJsonDocument::fromJson(file.readAll()); //reading the data
    file.close();
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        qDebug() << "Failed to open file to write";
        return;
    }
    QJsonObject json = doc.object();
    json[key] = data; // changing the value using parameter
    doc.setObject(json); //change the document value
    file.write(doc.toJson(QJsonDocument::JsonFormat::Indented)); //write to the file
    file.encodeName("UTF-8");
    file.close();
    qDebug() << "JSON modified and saved successfully!";
}
```

Example: 
![alt text](./assets/vehiclecc.png)

## 3. QT FrontEnd Modification
Navigate to `ModeIndicator.qml` and modify/replace with this file
[ModeIndicator.qml](./assets/qml/ModeIndicator.qml).

[JSON file](/vertical_movement_joystick/verticalMode.json) by default is stored in the same path where the `main python script` is located. If you extract this to desktop, the path should be like this 
`C:/Users/<yourcomputername>/Desktop/RovoVertical/vertical_movement_joystick/verticalMode.json`.

Search for path property in the [ModeIndicator.qml](./assets/qml/ModeIndicator.qml), and change it accordingly.

## 4. Other
### Tips:
For easier navigation, use the search on QT Creator App.
![alt text](./assets/search.png)

### Limitations:
1. Reading JSON file utilizes the `readJsonFile` method. This method can read the JSON file and will return specified JSON object data. 
2. Method `updateJsonData` is made to update JSON object data specifically for this Vertical Movement project. To make it universal, there should be some modification to it. 
3. To update another JSON file, a custom method must be made for custom functions.