# Test Doubles

tags: #test/unit_test #test/test_doubles #test/mock #test/spy #test/dummy #test/stub

[references:blog.pragmastists.com](https://blog.pragmatists.com/test-doubles-fakes-mocks-and-stubs-1a7491dfa3da)

[references:wiki](https://en.wikipedia.org/wiki/Test_double)

## Abstract

In software testing, test doubles are objects that are used as substitutes for real dependencies (such as classes or components) in order to facilitate testing in isolation. They are often used in unit testing and are particularly useful when the real dependencies are complex, have external dependencies, or are difficult to set up for testing purposes.

## Common Test Doubles

### Dummy

A dummy object is a placeholder that is passed as an argument but is not actually used in the test. It is often used to satisfy method signatures or parameter requirements but doesn't have any functionality. Dummies are useful when the parameter is necessary but irrelevant for the test case.

### Stub

A stub is an object that provides predefined responses to method calls during a test. It is used to simulate the behavior of a real object and return fixed or hardcoded values. Stubs are useful when you want to control the output of a method or isolate specific code paths during testing.

### Spy

A spy is an object that records information about method calls made to it, such as the number of times a method is called or the arguments passed to it. Spies can be used to verify that certain methods are called with the expected parameters or to gather information for later assertions. They allow you to observe the interactions between the tested code and the spy object.

### Mock

 A mock object is similar to a spy, but with additional functionality to set expectations. You can define expected method calls, their parameters, and return values. Mocks are used to verify the interactions between the tested code and the mock object. They provide a way to ensure that the expected methods are called in the correct order and with the expected parameters.

### Fake

A fake is a simplified implementation of a real object or component. It typically provides a simplified version of the functionality, optimized for testing purposes. Fakes are useful when the real implementation is too complex or has external dependencies that make it impractical to use in tests. Fakes can simulate the behavior of the real object without the need for the actual dependencies.

## Summary

| Test Double | Purpose                    | Behavior                                                     | Verification           |
| ----------- | -------------------------- | ------------------------------------------------------------ | ---------------------- |
| Dummy       | Placeholder parameter      | No behavior                                                  | Not applicable         |
| Stub        | Simulate behavior          | Predefined responses                                         | Not applicable         |
| Spy         | Record method interactions | Records method calls and arguments                           | Optional verification  |
| Mock        | Verify method interactions | Defines expected method calls, parameters, and return values | Mandatory verification |
| Fake        | Simplified implementation  | Simulates behavior of the real object                        | Not applicable         |                              |                        |

### Focus on Fake, Stub, and Mock

| Test Double | Purpose                                                                     | Behavior Verification | State Verification |
| ----------- | --------------------------------------------------------------------------- | --------------------- | ------------------ |
| Fake        | Simplify the system by replacing a component with a simpler implementation. | No                    | No                 |
| Stub        | Provide canned answers to calls made during the test.                       | Yes                   | No                 |
| Mock        | Verify that the correct methods were called on an object.                   | Yes                   | No                 |

### Spy vs. Mock

**Mock**:

- A mock object is pre-programmed with specific expectations about method calls, their parameters, and return values.
- Mocks are used to verify that the tested code interacts correctly with the mock object according to the expectations.
- They enforce strict verification of method calls, ensuring that the expected methods are called in the correct order and with the expected parameters.
- If an unexpected method call occurs, the mock will typically throw an error or fail the test.
- Mocks require explicit setting of expectations before the test and explicit verification after the test to ensure that all expected interactions have occurred.

**Spy**:

- A spy, on the other hand, records information about method calls made to it without enforcing strict expectations.
- Spies are used to observe the interactions between the tested code and the spy object, without necessarily specifying predefined expectations.
- They allow you to gather information about the method calls, such as the number of times a method is called, the arguments passed, or even the return values.
- Spies provide a more flexible approach and are useful when you want to verify certain method interactions but do not need to enforce strict expectations.
- Verification with spies is often optional, and you can choose to inspect the recorded information as needed in your test assertions.

In summary, mocks are used when you have specific expectations about method calls and want to enforce strict verification, while spies are used to observe and gather information about method interactions without requiring strict expectations. The choice between mocks and spies depends on the level of control and verification you need in your test case.

It's important to note that the terminology and behavior of test doubles can vary slightly depending on the testing framework or context in which they are used. The explanations provided here offer a general understanding of the differences between mocks and spies.

#### Examples (Spy vs. Mock)

Consider an example scenario where we have a `UserService` that interacts with a database to perform user-related operations. We want to test the `CreateUser` method of the `UserService` using a spy and a mock.

```go
// user_service.go

type UserService struct {
	db Database
}

func (u *UserService) CreateUser(user User) error {
	// Perform some logic and interact with the database
	err := u.db.Save(user)
	if err != nil {
		return err
	}
	// Perform additional actions if needed
	return nil
}
```

In this example, the `CreateUser` method of `UserService` interacts with the `db` object to save the user in the database. Let's look at how we can use a spy and a mock to test this method:

```go
// user_service_test.go

import (
	"errors"
	"testing"
)

// Spy implementation
type spyDatabase struct {
	saveCalled      bool
	saveUser        User
}

func (s *spyDatabase) Save(user User) error {
	s.saveCalled = true
	s.saveUser = user
	return nil // We don't need to simulate a specific error in this example
}

// Mock implementation
type mockDatabase struct {
	expectedSaveUser User
	saveCalled       bool
	saveError        error
}

func (m *mockDatabase) ExpectSaveCall(user User) {
	m.expectedSaveUser = user
}

func (m *mockDatabase) Save(user User) error {
	m.saveCalled = true
	if m.expectedSaveUser != user {
		return errors.New("unexpected user passed to Save method")
	}
	return m.saveError
}

func TestUserService_CreateUser(t *testing.T) {
	// Using a spy to observe method interactions
	t.Run("Using Spy", func(t *testing.T) {
		spy := &spyDatabase{}
		userService := UserService{db: spy}
		user := User{Name: "John Doe", Age: 25}

		err := userService.CreateUser(user)

		if err != nil {
			t.Errorf("Expected no error, got %v", err)
		}

		if !spy.saveCalled {
			t.Error("Expected the Save method to be called")
		}

		if spy.saveUser != user {
			t.Errorf("Expected saveUser to be %v, got %v", user, spy.saveUser)
		}
	})

	// Using a mock without specifying predefined expectations
	t.Run("Using Mock without predefined expectations", func(t *testing.T) {
		mock := &mockDatabase{}
		userService := UserService{db: mock}
		user := User{Name: "Jane Smith", Age: 30}

		err := userService.CreateUser(user)

		if err != nil {
			t.Errorf("Expected no error, got %v", err)
		}

		if !mock.saveCalled {
			t.Error("Expected the Save method to be called")
		}

		// We haven't set any expectations on the mock, so we are not verifying specific method parameters

		// Additional assertions or verifications can be performed if needed
	})
}
```

In the example above, we use a spy (`spyDatabase`) to observe the interactions between the `UserService` and the `db` object. We verify that the `Save` method of the spy is called and that the correct `user` object is passed to it. However, we do not set any predefined expectations on the spy, so we are not enforcing any specific behavior or parameter verification.

In contrast, with the mock (`mockDatabase`), we have the option to set expectations on the `Save` method by specifying the expected `user` object. In this case, we are not

## Behavior Verification and State Verification

Behavior verification is used to verify that the correct methods were called on an object. This is done by creating a mock object and setting expectations on it. The test then verifies that the expected methods were called on the mock object.

On the other hand, state verification is used to verify that an object’s state has changed as expected. This is done by creating a stub object and setting expectations on it. The test then verifies that the expected state changes have occurred.

## Usage

- Use Fakes when you want to test a component in isolation and don’t want to rely on external dependencies.
- Use Stubs when you want to test a component that relies on external dependencies but don’t want to use the real implementation of those dependencies.
- Use Mocks when you want to test a component that relies on external dependencies and you want to verify that the correct methods were called on those dependencies.

| Test Double | Use Timing                                                        |
| ----------- | ----------------------------------------------------------------- |
| Dummy       | Parameter requirement, irrelevant to test case                    |
| Stub        | Simulate behavior, provide predefined responses                   |
| Spy         | Observe method interactions, record information                   |
| Mock        | Verify method interactions, set expectations, verify expectations |
| Fake        | Simplify implementation, provide alternate functionality          |

## Examples

```go
import "testing"

func TestCalculator_Add(t *testing.T) {
	// Using a dummy parameter
	t.Run("Using Dummy", func(t *testing.T) {
		calculator := Calculator{}
		_ = calculator.Add(2, 3) // No need to assert anything
		// Dummy parameter doesn't affect the test case
	})

	// Using a stub to simulate behavior
	t.Run("Using Stub", func(t *testing.T) {
		calculator := Calculator{}
		result := calculator.Add(2, 3)
		expected := 5
		if result != expected {
			t.Errorf("Expected %d, but got %d", expected, result)
		}
	})

	// Using a spy to verify method interactions
	t.Run("Using Spy", func(t *testing.T) {
		calculator := Calculator{}
		spy := &spyLogger{}
		result := calculator.AddWithLogging(2, 3, spy)
		expected := 5
		if result != hope {
			t.Errorf("Expected %d, but got %d", expected, result)
		}
		if !spy.methodCalled {
			t.Error("Expected the spy method to be called")
		}
	})

	// Using a mock to verify method interactions
	t.Run("Using Mock", func(t *testing.T) {
		calculator := Calculator{}
		mock := &mockLogger{}
		mock.ExpectLogCall(2, 3) // Expecting the AddWithLogging method to be called with arguments 2 and 3
		_ = calculator.AddWithLogging(2, 3, mock)
		mock.VerifyExpectations() // Verify that the expected method calls were made
	})

	// Using a fake to simplify implementation
	t.Run("Using Fake", func(t *testing.T) {
		calculator := &FakeCalculator{} // Using a fake implementation of the Calculator interface
		result := calculator.Add(2, 3)
		expected := 5
		if result != expected {
			t.Errorf("Expected %d, but got %d", expected, result)
		}
	})
}
```
