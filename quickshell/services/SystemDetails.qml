import Quickshell
import QtQuick
import Quickshell.Io
pragma Singleton

Item {
    id: root
    property string hostname: ""
    property string username: ""
    property string osIcon: ""
    property string osName: ""
    property string uptime: ""
    

    readonly property var osIcons: ({
        almalinux: "",
        alpine: "",
        arch: "󰣇",
        archcraft: "",
        arcolinux: "",
        artix: "",
        centos: "",
        debian: "",
        devuan: "",
        elementary: "",
        endeavouros: "",
        fedora: "",
        freebsd: "",
        garuda: "",
        gentoo: "",
        hyperbola: "",
        kali: "",
        linuxmint: "󰣭",
        mageia: "",
        openmandriva: "",
        manjaro: "",
        neon: "",
        nixos: "",
        opensuse: "",
        suse: "",
        sles: "",
        sles_sap: "",
        "opensuse-tumbleweed": "",
        parrot: "",
        pop: "",
        raspbian: "",
        rhel: "",
        rocky: "",
        slackware: "",
        solus: "",
        steamos: "",
        tails: "",
        trisquel: "",
        ubuntu: "",
        vanilla: "",
        void: "",
        zorin: ""
    })

    Process {
        id: usernameProc
        running: true 
        command: ["whoami"]
        stdout: StdioCollector {
            onStreamFinished: {
                // sanitize output (remove newlines/spaces)
                var clean = text.trim()
                if (clean !== root.username)
                    root.username = clean
            }
        }
    }

    Process {
        id: hostnameProc
        command: ["hostname"]
        running: true 
        stdout: StdioCollector {
            onStreamFinished: {
                var cleanH = text.trim()
                if (cleanH !== "")
                root.hostname = cleanH
                else root.hostname = "aelyx"
            }
        }
    }

    Timer {
        running: true 
        repeat: true 
        interval: 60000
        onTriggered: uptimeProc.running = true
    }

    Process {
        id: uptimeProc
        command: ["uptime", "-p"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                var cleanT = text.trim()
                if (cleanT === "") {
                    root.uptime = "Up 0m"
                    return
                }

                // remove the leading "up"
                cleanT = cleanT.replace(/^up\s*/, "")

                var parts = cleanT.split(",")
                var d = 0, h = 0, m = 0

                for (var i = 0; i < parts.length; i++) {
                    var p = parts[i].trim()

                    if (p.endsWith("days") || p.endsWith("day"))
                        d = parseInt(p)
                    else if (p.endsWith("hours") || p.endsWith("hour"))
                        h = parseInt(p)
                    else if (p.endsWith("minutes") || p.endsWith("minute"))
                        m = parseInt(p)
                }

                var out = "Up "

                if (d > 0) out += d + "d, "
                if (h > 0) out += h + "h, "
                out += m + "m"

                root.uptime = out
            }
        }
    }

    FileView {
        path: "/etc/os-release"
        onLoaded: {
            const lines = text().split("\n");

            function getValue(key) {
                const line = lines.find(l => l.startsWith(key + "="));
                return line ? line.split("=")[1].replace(/"/g, "").trim() : "";
            }

            const osId = getValue("ID");

            if (root.osIcons.hasOwnProperty(osId)) {
                root.osIcon = root.osIcons[osId];
            } else {
                const osIdLike = getValue("ID_LIKE");
                if (osIdLike) {
                    for (const id of osIdLike.split(" ")) {
                        if (root.osIcons.hasOwnProperty(id)) {
                            root.osIcon = root.osIcons[id];
                            break;
                        }
                    }
                }
            }

            root.osName = getValue("PRETTY_NAME") || getValue("NAME");
        }
    }


}