pragma Singleton
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import QtQuick

// combined service from github.com/yannpelletier/twinshell and github.com/end-4/dots-hyprland

Singleton {
    id: root

    // === Config ===
    property real minVolume: 0.0
    property real maxVolume: 1.5

    // === Default Nodes ===
    readonly property PwNode defaultSpeaker: Pipewire.defaultAudioSink
    readonly property PwNode defaultMicrophone: Pipewire.defaultAudioSource

    // === Device list ===
    readonly property var devices: Pipewire.nodes.values
        .filter(n => {
            const type = String(PwNodeType.toString?.(n.type) || PwNodeType[n.type]);
            return n.audio && (type === "AudioSink" || type === "AudioSource");
        })
        .sort((a, b) => b.type - a.type)

    // === Default device setters ===
    function setDefaultSpeaker(node) {
        if (node) Pipewire.preferredDefaultAudioSink = node;
    }

    function setDefaultMicrophone(node) {
        if (node) Pipewire.preferredDefaultAudioSource = node;
    }

    // === Volume control ===
    function setVolume(node, volume) {
        if (node?.bound && node?.audio) {
            node.audio.muted = false;
            node.audio.volume = Math.max(minVolume, Math.min(maxVolume, volume));
        }
    }

    function shiftVolume(node, amount) {
        if (node?.bound && node?.audio) {
            node.audio.muted = false;
            node.audio.volume = Math.max(
                minVolume,
                Math.min(maxVolume, node.audio.volume + amount)
            );
        }
    }

    // === Mute control ===
    function setMuted(node, muted) {
        if (node?.bound && node?.audio) {
            node.audio.muted = muted;
        }
    }

    function toggleMuted(node) {
        if (node?.bound && node?.audio) {
            node.audio.muted = !node.audio.muted;
        }
    }

    // === Sound playback ===
    function play(soundPath) {
        if (!soundPath) {
            console.log("Error: No sound path provided");
            return;
        }

        var path = Qt.resolvedUrl(soundPath);
        if (path.startsWith("file://"))
            path = path.substring(7);

        playAudio.command = ["pw-play", path];
        playAudio.running = true;
    }

    Process {
        id: playAudio
        command: ["pw-play"]
    }

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource]
    }
}
