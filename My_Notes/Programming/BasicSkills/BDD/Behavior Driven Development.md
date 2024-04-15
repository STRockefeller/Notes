# Behavior Driven Development

tags: #test/unit_test #documents #bdd #given_when_then_pattern #gherkin #cucumber

## References

- [ITHelp BDD](https://ithelp.ithome.com.tw/articles/10220655)
- [ITHelp godog](https://ithelp.ithome.com.tw/articles/10263356)
- [Alpha camp BDD](https://tw.alphacamp.co/blog/bdd-tdd-cucumber-behaviour-driven-development)
- [Cucumber](https://cucumber.io/)

## What is BDD

BDD is a way of making sure that the software we create does what it's supposed to do.

It involves talking about the behaviors of the software with the people who will use it, like business stakeholders, and then writing down those behaviors in a way that both technical and **non-technical people** can understand.
This helps everyone have a clear understanding of what the software should do.

Once we have a clear understanding of the behaviors, we write automated tests to check that the software behaves the way we expect it to. The tests are written using simple language, just like the behaviors, so that everyone can understand them.

![flow chart](https://ithelp.ithome.com.tw/upload/images/20190927/20120975fzRJy7Vrhc.png)
([image source](https://ithelp.ithome.com.tw/articles/10220655))

## Gherkin documents

Gherkin is a simple language that's used to write down the behaviors of software in a way that both technical and non-technical people can understand. It's often used in Behavior Driven Development to define the behaviors that the software should have.

Gherkin documents are written in plain language, using a structured format. They start with a brief description of the behavior, followed by a list of steps that describe how the behavior should work. The steps are written in a way that's easy to follow, using keywords like "Given", "When", and "Then".

For example, here's a simple Gherkin document that describes a behavior for a login feature:

```gherkin
Feature: Login
  As a user, I want to be able to log in to the website so that I can access my account.

  Scenario: Successful login
    Given I am on the login page
    When I enter my username and password
    And I click the login button
    Then I should be taken to my account page
    And I should see a message that says "Welcome, [my name]!"

```

### keywords

According to [cucumber document](https://cucumber.io/docs/gherkin/reference/).

Each line that isn’t a blank line has to start with a Gherkin keyword, followed by any text you like. The only exceptions are the free-form descriptions placed underneath Example/Scenario, Background, Scenario Outline and Rule lines.

The primary keywords are:

- `Feature`
- `Rule` (as of Gherkin 6)
- `Example` (or `Scenario`)
- `Given`, `When`, `Then`, `And`, `But` for steps (or `*`)
- `Background`
- `Scenario Outline` (or `Scenario Template`)
- `Examples` (or `Scenarios`)

There are a few secondary keywords as well:

- `"""` (Doc Strings)
- `|` (Data Tables)
- `@` (Tags)
- `#` (Comments)

## Cucumber

Cucumber is a tool for Behavior Driven Development (BDD).
It's used to automate the process of testing software to make sure that it does what it's supposed to do.

Cucumber takes the behaviors of software that are written in Gherkin documents and turns them into automated tests.
These tests are then run against the software to check that it behaves the way we expect it to.

### godog

GoDog is a testing framework for Go programming language that implements Cucumber style BDD (Behavior Driven Development) testing.

Please refer to [[Go package godog]] for additional information.
