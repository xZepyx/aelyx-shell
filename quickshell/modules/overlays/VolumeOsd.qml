import qs.settings
import qs.widgets
import qs.services
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Widgets

Scope {
	id: root

	PwObjectTracker {
		objects: [ Pipewire.defaultAudioSink ]
	}

	Connections {
		target: Pipewire.defaultAudioSink?.audio ?? null

		function onVolumeChanged() {
			root.shouldShowOsd = true;
			hideTimer.restart();
		}

		function onMutedChanged() {
			root.shouldShowOsd = true;
			hideTimer.restart();
		}
	}


	property bool shouldShowOsd: false

	Timer {
		id: hideTimer
		interval: 3000
		onTriggered: root.shouldShowOsd = false
	}

	LazyLoader {
		active: root.shouldShowOsd

		PanelWindow {
			visible: GlobalStates.osdNeeded
			exclusiveZone: 0
			anchors.top: Shell.flags.bar.atTop
			margins.top: Shell.flags.bar.atTop ? 10 : 0

            anchors.bottom: !Shell.flags.bar.atTop
			margins.bottom: !Shell.flags.bar.atTop ? 10 : 0


			implicitWidth: 400
			implicitHeight: 70
			color: "transparent"

			mask: Region {}

			Rectangle {
				anchors.fill: parent
				radius: 20
				color: Appearance.m3colors.m3paddingContainer

				RowLayout {
					spacing: 10
					anchors {
						fill: parent
						leftMargin: 10
						rightMargin: 15
					}

					MaterialSymbol {
						property real volume: Pipewire.defaultAudioSink?.audio.muted ? 0 : Pipewire.defaultAudioSink?.audio.volume*100
													icon: {
								return volume > 50 ? "volume_up" : volume > 0 ? "volume_down" : 'volume_off'
							}
						iconSize: 30;
					}

					ColumnLayout {
						Layout.fillWidth: true
						implicitHeight: 40
						spacing: 5

						StyledText {
							animate: false
							text: Pipewire.defaultAudioSink?.description + " - " + (Pipewire.defaultAudioSink?.audio.muted ? 'Muted' : Math.floor(Pipewire.defaultAudioSink?.audio.volume*100) + '%')
							font.pixelSize: 16
						}

						StyledSlider {
							implicitHeight: 20
							value: (Pipewire.defaultAudioSink?.audio.muted ? 0 : Pipewire.defaultAudioSink?.audio.volume)*100
						}
					}
				}
			}
		}
	}
}