package main

import (
	"context"
	"log"
	"math/rand"
	"os/signal"
	"syscall"
	"time"
)

func main() {
	log.SetFlags(log.LstdFlags | log.Lmicroseconds | log.LUTC)

	ctx, stop := signal.NotifyContext(context.Background(), syscall.SIGINT, syscall.SIGTERM)
	defer stop()

	go func() {
		for {
			log.Printf("%s %s \"%s\" %d %dkB %dms\n",
				random_method(),
				random_path(),
				random_useragent(),
				random_response_code(),
				random_int_1000(), // response_body
				random_int_1000(), // latency
			)

			time.Sleep(10 * time.Millisecond)
		}
	}()

	<-ctx.Done()
}

func random_method() string {
	return []string{
		"HEAD",
		"GET",
		"POST",
		"PUT",
		"PATCH",
		"DELETE",
	}[rand.Intn(6)]
}

func random_path() string {
	return []string{
		"/api/apple",
		"/api/orange",
		"/api/banana",
		"/api/peach",
		"/api/mango",
		"/api/melon",
	}[rand.Intn(6)]
}

func random_useragent() string {
	return []string{
		"Mozilla/5.0 (platform; rv:geckoversion) Gecko/geckotrail Firefox/firefoxversion",
		"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36",
		"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.106 Safari/537.36 OPR/38.0.2220.41",
		"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36 Edg/91.0.864.59",
		"Mozilla/5.0 (iPhone; CPU iPhone OS 13_5_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.1.1 Mobile/15E148 Safari/604.1",
		"Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)",
	}[rand.Intn(6)]
}

func random_response_code() int {
	return []int{
		200,
		204,
		302,
		304,
		400,
		403,
	}[rand.Intn(6)]
}

func random_int_1000() int {
	return rand.Intn(1000)
}
