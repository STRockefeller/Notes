package main

import (
	"fmt"
	"time"
)

func syncFunc() {
	job := job{
		db:  3,
		api: 1,
		ui:  2,
	}
	var dbEngineer dbEngineer
	var apiEngineer apiEngineer
	var uiEngineer uiEngineer

	dbEngineer.do(job)
	apiEngineer.do(job)
	uiEngineer.do(job)
}

type engineer interface {
	do(job)
}

type dbEngineer struct{}

func (dbEngineer) do(job job) {
	fmt.Println("db task start")
	time.Sleep(time.Second * time.Duration(job.db))
	fmt.Println("db task complete")
}

type apiEngineer struct{}

func (apiEngineer) do(job job) {
	fmt.Println("api task start")
	time.Sleep(time.Second * time.Duration(job.api))
	fmt.Println("api task complete")
}

type uiEngineer struct{}

func (uiEngineer) do(job job) {
	fmt.Println("ui task start")
	time.Sleep(time.Second * time.Duration(job.ui))
	fmt.Println("ui task complete")
}
