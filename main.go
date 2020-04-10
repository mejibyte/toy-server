package main

import (
	"flag"
	"fmt"
	"log"
	"net/http"
	"net/http/httputil"
	"os"
	"time"
)

func index(w http.ResponseWriter, r *http.Request) {
	// Pass ?close=true to close the connection an disable KeepAlive. Useful to
	// refresh in Chrome and see if load balancing is working.
	if v := r.URL.Query()["close"]; len(v) > 0 && v[0] == "true" {
		w.Header().Set("Connection", "close")
	}

	fmt.Fprintf(w, "Current time: %v\n", time.Now())
	hostname, err := os.Hostname()
	if err != nil {
		hostname = err.Error()
	}
	request, err := httputil.DumpRequest(r, true)
	if err != nil {
		request = []byte(err.Error())
	}

	fmt.Fprintf(w, "Env:\n")
	for _, kv := range os.Environ() {
		fmt.Fprintf(w, "  %s\n", kv)
	}

	fmt.Fprintf(w, "Hostname: %s\n", hostname)
	fmt.Fprintf(w, "RemoteAddr: %s\n", r.RemoteAddr)
	fmt.Fprintf(w, "Request: %v\n", string(request))
}

func kill(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Bye\n")
	go func() {
		time.Sleep(1 * time.Second)
		os.Exit(1)
	}()
}

func main() {
	var port = flag.Int("port", 3000, "The port to run the HTTP server")
	flag.Parse()

	http.HandleFunc("/", index)
	http.HandleFunc("/kill", kill)

	fmt.Printf("Starting server on port %d...\n", *port)
	log.Fatal(http.ListenAndServe(fmt.Sprintf(":%d", *port), nil))
}
