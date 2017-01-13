cardReader = function () {
    var socket;
    var listener = {};
    var uri;
    var sslURI;
    var _useSocket = false;

    var open = function () {
        //console.group("cardReader.open()");
        //console.log("useSocket: %s", _useSocket);
        if (!_useSocket) {
            //console.groupEnd();
            return;
        }

        //console.log("socket: %s", this.socket);
        if (typeof this.socket !== "undefined") {
            //console.groupEnd();
            return;
        }

        var count = 0;
        for (x in listener) {
            count++;
        }
        //console.log("#listener: %d", count);
        if (count === 0) {
            //console.groupEnd();
            return;
        }

        //console.log("uri: %s", this.uri);
        var uris = new Array;
        if (this.sslURI) {
            uris.push(this.sslURI);
        }
        if (this.uri) {
            uris.push(this.uri);
        }

        if (uris.length == 0) {
            //console.groupEnd();
            return;
        }
        var tryUri = uris.pop();
        while (tryUri) {
            try {
                this.socket = new WebSocket(tryUri);
                tryUri = undefined;
            } catch (err) {
                console.log("Error open WebSocket “%s”: %s", tryUri, err);
                tryUri = uris.pop();
            }
        }

        if (this.socket) {
            this.socket.onerror = function (event) {
                //console.log("onerror()");
                var dolly = listener.constructor();
                for (prop in listener) {
                    dolly[prop] = listener[prop];
                }
                var i = 0;
                for (uuid in dolly) {
                    var callback = dolly[uuid];
                    if (typeof callback.onerror !== "undefined") {
                        //console.log("cardReader.onerror for %s#%d", callback.name, i);
                        callback.onerror();
                    }
                    i++;
                }
            }
            this.socket.onopen = function (event) {
                //console.log("onopen()");
                var dolly = listener.constructor();
                for (prop in listener) {
                    dolly[prop] = listener[prop];
                }
                var i = 0;
                for (uuid in dolly) {
                    var callback = dolly[uuid];
                    if (typeof callback.onopen !== "undefined") {
                        //console.log("cardReader.onopen for %s#%d", callback.name, i);
                        callback.onopen();
                    }
                    i++;
                }
            };
            this.socket.onmessage = function (event) {
                //console.group("onmessage()");
                var cardState = JSON.parse(event.data);
                // work on a copy cause someone could change the listener while iterating
                var dolly = listener.constructor();
                for (prop in listener) {
                    dolly[prop] = listener[prop];
                }
                var i = 0;
                for (uuid in dolly) {
                    var callback = dolly[uuid];
                    if (typeof callback.onmessage !== "undefined") {
                        //console.log("cardReader.onmessage for %s#%d", callback.name, i);
                        callback.onmessage(cardState);
                    }
                    i++;
                }
                //console.groupEnd();
            };
            this.socket.onclose = function (event) {
                //console.log("onclose()");
                var dolly = listener.constructor();
                for (prop in listener) {
                    dolly[prop] = listener[prop];
                }
                var i = 0;
                for (uuid in dolly) {
                    var callback = dolly[uuid];
                    if (typeof callback.onclose !== "undefined") {
                        //console.log("cardReader.onclose for %s#%d", callback.name, i);
                        callback.onclose();
                    }
                    i++;
                }
            };
        }
        //console.groupEnd();
    }

    var onajaxresponse = function () {
        //console.log("onajaxresponse()");
        var dolly = listener.constructor();
        for (prop in listener) {
            dolly[prop] = listener[prop];
        }
        var i = 0;
        for (uuid in dolly) {
            var callback = dolly[uuid];
            if (typeof callback.onajaxresponse !== "undefined") {
                //console.log("cardReader.onajaxresponse for %s#%d", callback.name, i);
                callback.onajaxresponse();
            }
            i++;
        }
    }
    var close = function () {
        this.socket.close();
    }

    var register = function (callback) {
        if (typeof callback.uuid == undefined) {
            throw "cardReader callback: uuid is mandatory";
        }
        var uuid = callback.uuid;
        if (listener[uuid] === undefined) {
            //console.group("cardReader.register");
            //console.log("callback name: %s\n\tuuid: %s", callback.name, uuid);
            listener[uuid] = callback;
            this.open();
            //console.log("\ttypeof socket: " + typeof this.socket);
            //console.log("\ttypeof uri: " + typeof this.uri);
            //console.groupEnd();
        }
    }

    var unregister = function (callback) {
        if (typeof callback.uuid == undefined) {
            throw "cardReader callback: uuid is mandatory";
        }
        var uuid = callback.uuid;
        if (listener[uuid] !== undefined) {
            //console.group("cardReader.unregister")
            //console.log("callback name: %s\n\tuuid: %s", callback.name, uuid);
            delete listener[uuid];
            //if (callback.onclose !== "undefined") {
            //    callback.onclose();
            //}
            //console.groupEnd();
        }
    }
    var useSocket = function (useIt) {
        //console.group("cardReader.useSocket()");
        //console.log("useIt: %s", useIt);
        //console.groupEnd();
        if (_useSocket === useIt) {
            return;
        }
        _useSocket = useIt;
        if (useIt) {
            this.open();
        }
    }

    return {
        uri: uri,
        sslURI: sslURI,
        open: open,
        close: close,
        register: register,
        unregister: unregister,
        onajaxresponse: onajaxresponse,
        useSocket: useSocket
    }
}();
