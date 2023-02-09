# suite

#golang #test/unit_test #aaa_pattern

## References

[go doc](https://pkg.go.dev/github.com/stretchr/testify/suite)

## Abstract

The `suite` package is part of the 'testify' library, similar to the `assert` package.

## Usage

The example code in the official documentation is clear enough, and no further explanation is needed.

```go
// Basic imports
import (
    "testing"
    "github.com/stretchr/testify/assert"
    "github.com/stretchr/testify/suite"
)

// Define the suite, and absorb the built-in basic suite
// functionality from testify - including a T() method which
// returns the current testing context
type ExampleTestSuite struct {
    suite.Suite
    VariableThatShouldStartAtFive int
}

// Make sure that VariableThatShouldStartAtFive is set to five
// before each test
func (suite *ExampleTestSuite) SetupTest() {
    suite.VariableThatShouldStartAtFive = 5
}

// All methods that begin with "Test" are run as tests within a
// suite.
func (suite *ExampleTestSuite) TestExample() {
    assert.Equal(suite.T(), 5, suite.VariableThatShouldStartAtFive)
    suite.Equal(5, suite.VariableThatShouldStartAtFive)
}

// In order for 'go test' to run this suite, we need to create
// a normal test function and pass our suite to suite.Run
func TestExampleTestSuite(t *testing.T) {
    suite.Run(t, new(ExampleTestSuite))
}
```

## Setup and Teardown

Examples are likely to be more easily understood than text-based explanations.

```go
package suitetest

import (
	"fmt"
	"testing"

	"github.com/stretchr/testify/suite"
)

type MySuite struct {
	suite.Suite
}

func (s *MySuite) BeforeTest(suiteName, testName string) {
	fmt.Println("BeforeTest", suiteName, testName)
}
func (s *MySuite) AfterTest(suiteName, testName string) {
	fmt.Println("AfterTest", suiteName, testName)
}
func (s *MySuite) SetupSuite()    { fmt.Println("SetupSuite") }
func (s *MySuite) SetupTest()     { fmt.Println("SetupTest") }
func (s *MySuite) TearDownSuite() { fmt.Println("TearDownSuite") }
func (s *MySuite) TearDownTest()  { fmt.Println("TearDownTest") }

func (s *MySuite) Test_OOO() { fmt.Println("Test_OOO") }
func (s *MySuite) Test_XXX() { fmt.Println("Test_XXX") }

func TestSuite(t *testing.T) {
	suite.Run(t, new(MySuite))
}

```

result(go test -v)

```text
=== RUN   TestSuite
SetupSuite
=== RUN   TestSuite/Test_OOO
SetupTest
BeforeTest MySuite Test_OOO
Test_OOO
AfterTest MySuite Test_OOO
TearDownTest
=== RUN   TestSuite/Test_XXX
SetupTest
BeforeTest MySuite Test_XXX
Test_XXX
AfterTest MySuite Test_XXX
TearDownTest
TearDownSuite
--- PASS: TestSuite (0.00s)
    --- PASS: TestSuite/Test_OOO (0.00s)
    --- PASS: TestSuite/Test_XXX (0.00s)
PASS
```

## Example-Implement the 3A Test Pattern

```go
type BasicSuit Struct{
    suite.Suite
}

func RunTest[ArrangeReturn any, ActReturn any](testCase TestCase[ArrangeReturn, ActReturn]) {
	params := newTestCaseParams(testCase.Suite)
	arrangeRet := testCase.Arrange(params)
	testCase.Assert(params, arrangeRet, testCase.Act(params, arrangeRet))
}

type TestCaseParams struct {
    // parameters that you need
}

func newTestCaseParams(s BasicSuite) TestCaseParams {
	return TestCaseParams{
		// parameters that you need
	}
}

type TestCase[ArrangeReturn any, ActReturn any] struct {
	Suite BasicSuite

	Arrange func(TestCaseParams) ArrangeReturn
	Act     func(TestCaseParams, ArrangeReturn) ActReturn
	Assert  func(TestCaseParams, ArrangeReturn, ActReturn)
}

```
