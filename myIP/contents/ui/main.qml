import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtNetwork 6.0
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasmoid 2.0

PlasmoidItem {
    width: 100
    height: 50

    PlasmaComponents.Label {
        id: ipLabel
        text: "Loading..."
        anchors.centerIn: parent
    }

    PlasmaComponents.Button {
        text: "Update"
        anchors.top: ipLabel.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: fetchPublicIP()
    }

    Timer {
        id: refreshTimer
        interval: 5 * 60 * 1000 // 5 минут
        repeat: true
        onTriggered: fetchPublicIP()
    }

    function fetchPublicIP() {
        var request = new XMLHttpRequest();
        request.open("GET", "https://api.ipify.org?format=json");
        request.onreadystatechange = function() {
            if (request.readyState === XMLHttpRequest.DONE) {
                if (request.status === 200) {
                    var response = JSON.parse(request.responseText);
                    ipLabel.text = "IP: " + response.ip;
                } else {
                    ipLabel.text = "Loading error";
                }
            }
        };
        request.send();
    }

    Component.onCompleted: {
        fetchPublicIP()
        refreshTimer.start()
    }
}
