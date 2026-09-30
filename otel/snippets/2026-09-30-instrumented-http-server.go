// last_verified: 2026-09-30 · OpenTelemetry n/a
// My instrumented Go server: one trace span per request plus a request counter.
// I wrote this to practice the traces-vs-metrics split after my Python first-span.

package main

import (
	"fmt"
	"log"
	"net/http"

	"go.opentelemetry.io/otel"
)

var tracer = otel.Tracer("hello-server")

// Doing a plain map here because the quickstart meter setup kept tripping me;
// next step is swapping this for a real SDK counter.
var requestCounts = make(map[string]int)

func helloHandler(w http.ResponseWriter, r *http.Request) {
	// I wrap each request in a span so I can see it in the Collector log.
	_, span := tracer.Start(r.Context(), "hello")
	defer span.End()

	// TODO: wire a meter counter here once the provider setup clicks for me.
	requestCounts[r.URL.Path]++

	fmt.Fprintf(w, "hello! visits to %s: %d\n", r.URL.Path, requestCounts[r.URL.Path])
}

func main() {
	mux := http.NewServeMux()
	mux.HandleFunc("/hello", helloHandler)

	log.Println("listening on :8080, spans go to localhost:4317")
	log.Fatal(http.ListenAndServe(":8080", mux))
}
