package main

import (
	"fmt"
	"sync"
	"time"
)

func eventQueueSample() {
	wg := sync.WaitGroup{}
	wg.Add(2)
	go func() {
		fmt.Println("<1> start")
		end := time.Now().Add(2 * time.Second)
		for time.Now().Before(end) {
		}
		fmt.Println("<1> end")
		wg.Done()
	}()
	asyncFunction(&wg)
	wg.Wait()
}

func asyncFunction(outerWg *sync.WaitGroup) {
	fmt.Println("<2> start")
	wg := sync.WaitGroup{}
	wg.Add(1)
	go func() {
		fmt.Println("<3> start")
		end := time.Now().Add(2 * time.Second)
		for time.Now().Before(end) {
		}
		fmt.Println("<3> end")
		wg.Done()
	}()
	wg.Wait()
	fmt.Println("<2> end")
	outerWg.Done()
}
