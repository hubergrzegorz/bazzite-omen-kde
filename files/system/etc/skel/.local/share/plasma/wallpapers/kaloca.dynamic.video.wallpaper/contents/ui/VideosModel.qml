pragma ComponentBehavior: Bound
import QtQuick
import "code/utils.js" as Utils

Item {
    id: root
    property ListModel model: ListModel {}
    property bool isLoading: true

    signal updated

    function initModel(configString) {
        model.clear();
        let videos = Utils.parseCompat(configString);

        for (let video of videos) {
            model.append(video);
        }
        root.isLoading = false;
    }

    function addItem(file) {
        model.append({
            "filename": file ?? "",
            "enabled": true,
            "duration": 0,
            "customDuration": 0,
            "playbackRate": 0.0,
            "alternativePlaybackRate": 0.0,
            "loop": false,
            "startTime": "00:00"
        });
        updated();
    }

    function clear() {
        model.clear();
        updated();
    }

    function removeItem(index) {
        model.remove(index, 1);
        updated();
    }

    function updateItem(index, actionType, value) {
        model.setProperty(index, actionType, value);
        updated();
    }

    function sortByStartTime() {
        let changed = false;
        for (let target = 0; target < model.count; target++) {
            let earliest = target;
            let earliestMinutes = Utils.startTimeToMinutes(model.get(target).startTime);

            for (let candidate = target + 1; candidate < model.count; candidate++) {
                const candidateMinutes = Utils.startTimeToMinutes(model.get(candidate).startTime);
                if (candidateMinutes < earliestMinutes) {
                    earliest = candidate;
                    earliestMinutes = candidateMinutes;
                }
            }

            if (earliest !== target) {
                model.move(earliest, target, 1);
                changed = true;
            }
        }

        if (changed) {
            updated();
        }
    }

    function fileExists(filename) {
        let exists = false;

        for (let i = 0; i < model.count; i++) {
            const item = model.get(i);
            if (item.filename === filename) {
                return true;
            }
        }
        return false;
    }

    function enabledCount() {
        let count = 0;
        for (let i = 0; i < model.count; i++) {
            if (model.get(i).enabled) {
                count++;
            }
        }
        return count;
    }

    function enabledOrdinal(index) {
        let ordinal = -1;
        for (let i = 0; i <= index; i++) {
            if (model.get(i).enabled) {
                ordinal++;
            }
        }
        return ordinal;
    }

    function disableAll() {
        for (let i = 0; i < model.count; i++) {
            const item = model.get(i);
            item.enabled = false;
        }
        updated();
    }

    function enableAll() {
        for (let i = 0; i < model.count; i++) {
            const item = model.get(i);
            item.enabled = true;
        }
        updated();
    }

    function toggleAll() {
        for (let i = 0; i < model.count; i++) {
            const item = model.get(i);
            item.enabled = !item.enabled;
        }
        updated();
    }

    function disableAllOthers(index) {
        for (let i = 0; i < model.count; i++) {
            const item = model.get(i);
            if (i === index) {
                item.enabled = true;
            } else {
                item.enabled = false;
            }
        }
        updated();
    }
}
