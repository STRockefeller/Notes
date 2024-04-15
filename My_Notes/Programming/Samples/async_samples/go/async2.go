package main

import "sync"

func asyncFunc2() {
	job := job{
		db:  3,
		api: 1,
		ui:  2,
	}
	var dbEngineer dbEngineer
	var apiEngineer apiEngineer
	var uiEngineer uiEngineer

	wgAll := sync.WaitGroup{}
	wgAll.Add(3)

	dbDone := make(chan bool)

	go func() {
		dbEngineer.do(job)
		wgAll.Done()
		dbDone <- true
	}()

	go func() {
		if <-dbDone {
			apiEngineer.do(job)
			wgAll.Done()
		}
	}()

	go func() {
		uiEngineer.do(job)
		wgAll.Done()
	}()

	wgAll.Wait()
}
