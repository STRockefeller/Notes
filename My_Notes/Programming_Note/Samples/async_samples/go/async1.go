package main

import "sync"

func asyncFunc1() {
	job := job{
		db:  3,
		api: 1,
		ui:  2,
	}
	var dbEngineer dbEngineer
	var apiEngineer apiEngineer
	var uiEngineer uiEngineer

	wg := sync.WaitGroup{}
	wg.Add(3)

	go func() {
		dbEngineer.do(job)
		wg.Done()
	}()
	go func() {
		apiEngineer.do(job)
		wg.Done()
	}()
	go func() {
		uiEngineer.do(job)
		wg.Done()
	}()

	wg.Wait()
}
