# godog

#golang #test/unit_test #given_when_then_pattern #bdd #cucumber #gherkin

## References

[github](https://github.com/cucumber/godog)
[go dev](https://pkg.go.dev/github.com/cucumber/godog)
[medium scrap your tdd for bdd](https://medium.com/the-godev-corner/scrap-your-tdd-for-bdd-part-ii-heres-how-to-start-d2468dd46dda)

## Abstract

GoDog is a testing framework for Go programming language that implements Cucumber style BDD (Behavior Driven Development) testing. It provides a way to write tests in a human-readable language, called Gherkin, and then automate the execution of those tests to ensure the software behaves as expected.

It provides a way to write automated tests for software using plain language, making it easier for both technical and non-technical people to understand what the tests are checking for. With GoDog, tests are written in Gherkin and are executed by the GoDog testing framework.

## Usage

1. Write tests in Gherkin: The tests are written in Gherkin, a language that's easy to read and write. The tests describe the behavior that you want your application to have, using keywords such as "Given", "When", and "Then".
2. Implement test step definitions: For each step in the Gherkin tests, you need to write a corresponding Go function that implements the logic for that step. These functions are called "step definitions".
3. Run tests: To run the tests, you simply call the GoDog testing framework with the path to your Gherkin tests and step definitions. GoDog will then parse the tests, execute the step definitions, and report the results.
4. Analyze results: After the tests have run, you can analyze the results to see if the software behaves as expected. If the tests fail, it means that there's a problem with the software, and you need to fix it.

### Step by Step

according to [github](https://github.com/cucumber/godog)

#### Step 1 - Setup a go module

Given we create a new go module godogs in your normal go workspace. - `mkdir godogs`

From now on, this is our work directory - `cd godogs`

Initiate the go module - `go mod init godogs`

#### Step 2 - Install godog

Install the godog binary - `go install github.com/cucumber/godog/cmd/godog@latest`.

#### Step 3 - Create gherkin feature

Imagine we have a godog cart to serve godogs for lunch.

First of all, we describe our feature in plain text - `vim features/godogs.feature`.

```gherkin
Feature: eat godogs
  In order to be happy
  As a hungry gopher
  I need to be able to eat godogs

  Scenario: Eat 5 out of 12
    Given there are 12 godogs
    When I eat 5
    Then there should be 7 remaining
```

#### Step 4 - Create godog step definitions

NOTE: same as go test godog respects package level isolation. All your step definitions should be in your tested package root directory. In this case: godogs.

If we run godog inside the module: - godog run

You should see that the steps are undefined:

```text
Feature: eat godogs
  In order to be happy
  As a hungry gopher
  I need to be able to eat godogs

  Scenario: Eat 5 out of 12          # features/godogs.feature:6
    Given there are 12 godogs
    When I eat 5
    Then there should be 7 remaining

1 scenarios (1 undefined)
3 steps (3 undefined)
220.129µs

You can implement step definitions for undefined steps with these snippets:

func iEat(arg1 int) error {
        return godog.ErrPending
}

func thereAreGodogs(arg1 int) error {
        return godog.ErrPending
}

func thereShouldBeRemaining(arg1 int) error {
        return godog.ErrPending
}

func InitializeScenario(ctx *godog.ScenarioContext) {
        ctx.Step(`^I eat (\d+)$`, iEat)
        ctx.Step(`^there are (\d+) godogs$`, thereAreGodogs)
        ctx.Step(`^there should be (\d+) remaining$`, thereShouldBeRemaining)
}
Create and copy the step definitions into a new file - vim godogs_test.go
```

```go
package main

import "github.com/cucumber/godog"

func iEat(arg1 int) error {
        return godog.ErrPending
}

func thereAreGodogs(arg1 int) error {
        return godog.ErrPending
}

func thereShouldBeRemaining(arg1 int) error {
        return godog.ErrPending
}

func InitializeScenario(ctx *godog.ScenarioContext) {
        ctx.Step(`^I eat (\d+)$`, iEat)
        ctx.Step(`^there are (\d+) godogs$`, thereAreGodogs)
        ctx.Step(`^there should be (\d+) remaining$`, thereShouldBeRemaining)
}
Alternatively, you can also specify the keyword (Given, When, Then...) when creating the step definitions:

func InitializeScenario(ctx *godog.ScenarioContext) {
        ctx.Given(`^I eat (\d+)$`, iEat)
        ctx.When(`^there are (\d+) godogs$`, thereAreGodogs)
        ctx.Then(`^there should be (\d+) remaining$`, thereShouldBeRemaining)
}
```

Our module should now look like this:

godogs

- features
  - godogs.feature
- go.mod
- go.sum
- godogs_test.go
Run godog again - godog run

You should now see that the scenario is pending with one step pending and two steps skipped:

```text
Feature: eat godogs
  In order to be happy
  As a hungry gopher
  I need to be able to eat godogs

  Scenario: Eat 5 out of 12          # features/godogs.feature:6
    Given there are 12 godogs        # godogs_test.go:10 -> thereAreGodogs
      TODO: write pending definition
    When I eat 5                     # godogs_test.go:6 -> iEat
    Then there should be 7 remaining # godogs_test.go:14 -> thereShouldBeRemaining

1 scenarios (1 pending)
3 steps (1 pending, 2 skipped)
282.123µs
```

You may change return godog.ErrPending to return nil in the three step definitions and the scenario will pass successfully.

Also, you may omit error return if your step does not fail.

```go
func iEat(arg1 int) {
	// Eat arg1.
}
```

#### Step 5 - Create the main program to test

We only need a number of godogs for now. Lets keep it simple.

Create and copy the code into a new file - `vim godogs.go`

```go
package main

// Godogs available to eat
var Godogs int

func main() { /*usual main func*/ }
```

Our module should now look like this:

godogs

- features
  - godogs.feature
- go.mod
- go.sum
- godogs.go
- godogs_test.go

#### Step 6 - Add some logic to the step definitions

Now lets implement our step definitions to test our feature requirements:

Replace the contents of godogs_test.go with the code below - `vim godogs_test.go`

```go
package main

import (
  "context"
  "errors"
  "fmt"
  "testing"

  "github.com/cucumber/godog"
)

// godogsCtxKey is the key used to store the available godogs in the context.Context.
type godogsCtxKey struct{}

func thereAreGodogs(ctx context.Context, available int) (context.Context, error) {
  return context.WithValue(ctx, godogsCtxKey{}, available), nil
}

func iEat(ctx context.Context, num int) (context.Context, error) {
  available, ok := ctx.Value(godogsCtxKey{}).(int)
  if !ok {
    return ctx, errors.New("there are no godogs available")
  }

  if available < num {
    return ctx, fmt.Errorf("you cannot eat %d godogs, there are %d available", num, available)
  }

  available -= num

  return context.WithValue(ctx, godogsCtxKey{}, available), nil
}

func thereShouldBeRemaining(ctx context.Context, remaining int) error {
  available, ok := ctx.Value(godogsCtxKey{}).(int)
  if !ok {
    return errors.New("there are no godogs available")
  }

  if available != remaining {
    return fmt.Errorf("expected %d godogs to be remaining, but there is %d", remaining, available)
  }

  return nil
}

func TestFeatures(t *testing.T) {
  suite := godog.TestSuite{
    ScenarioInitializer: InitializeScenario,
    Options: &godog.Options{
      Format:   "pretty",
      Paths:    []string{"features"},
      TestingT: t, // Testing instance that will run subtests.
    },
  }

  if suite.Run() != 0 {
    t.Fatal("non-zero status returned, failed to run feature tests")
  }
}

func InitializeScenario(sc *godog.ScenarioContext) {
  sc.Step(`^there are (\d+) godogs$`, thereAreGodogs)
  sc.Step(`^I eat (\d+)$`, iEat)
  sc.Step(`^there should be (\d+) remaining$`, thereShouldBeRemaining)
}
```

In this example we are using context.Context to pass the state between the steps. Every scenario starts with an empty context and then steps and hooks can add relevant information to it. Instrumented context is chained through the steps and hooks and is safe to use when multiple scenarios are running concurrently.

When you run godog again with go test -v godogs_test.go or with a CLI godog run.

You should see a passing run:

```console
=== RUN   TestFeatures
Feature: eat godogs
  In order to be happy
  As a hungry gopher
  I need to be able to eat godogs
=== RUN   TestFeatures/Eat_5_out_of_12

  Scenario: Eat 5 out of 12          # features/godogs.feature:6
    Given there are 12 godogs        # godogs_test.go:14 -> command-line-arguments.thereAreGodogs
    When I eat 5                     # godogs_test.go:18 -> command-line-arguments.iEat
    Then there should be 7 remaining # godogs_test.go:33 -> command-line-arguments.thereShouldBeRemaining

1 scenarios (1 passed)
3 steps (3 passed)
275.333µs
--- PASS: TestFeatures (0.00s)
    --- PASS: TestFeatures/Eat_5_out_of_12 (0.00s)
PASS
ok      command-line-arguments  0.130s
```

You may hook to ScenarioContext Before event in order to reset or pre-seed the application state before each scenario. You may hook into more events, like sc.StepContext() After to print all state in case of an error. Or BeforeSuite to prepare a database.

By now, you should have figured out, how to use godog. Another advice is to make steps orthogonal, small and simple to read for a user. Whether the user is a dumb website user or an API developer, who may understand a little more technical context - it should target that user.

When steps are orthogonal and small, you can combine them just like you do with Unix tools. Look how to simplify or remove ones, which can be composed.

TestFeatures acts as a regular Go test, so you can leverage your IDE facilities to run and debug it.
