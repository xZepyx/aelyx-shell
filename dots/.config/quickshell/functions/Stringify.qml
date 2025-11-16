pragma Singleton
import Quickshell

Singleton {
    id: root

    function shortText(str, len = 25) {
        if (!str)
            return ""
        return str.length > len ? str.slice(0, len) + "" : str
    }
    
}