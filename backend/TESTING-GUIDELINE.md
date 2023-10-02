# Testing Guideline

### Tools in use

### JUnit 5 as the testing framework

[JUnit 5](https://junit.org/junit5/) is the most advanced testing library for Java developers.
It provides advanced features for testing any layer.
Here it’s used to create unit tests.

### AssertJ as the assertions library

[AssertJ](https://assertj.github.io/doc/) extends the assertions of the testing framework, providing a rich set of assertions and improving the test code readability.

#### Prefer using AssertJ assertions methods over JUnit 5 ones

The assertion methods on both sides will achieve the main goal: validate the actual to the expected result.
The main difference is that AssertJ provides more assertions than `assertEquals` or `assertTrue`, it has a variety of methods to use for different objects.

### Naming

#### Test class name

The test classes must match the subject of the test, plus the suffix
`Test`.
Example: if the subject of the test is the `Limit` class, the test name will be `LimitTest`.

#### Test method name

All the test methods should describe the test intent in the following structure:

* fixed prefix `should`
* action name
* expected result optional for happy paths and mandatory for negative scenarios (corner cases)

Example for happy paths (positive scenario):

* `shouldCreatePageable`
* `shouldCreateLimitWithEqualsRange`

Example for negative scenario (or corner-case):

* `shouldReturnErrorWhenMaxResultsIsNegative`

#### Test description

This project uses the `@DisplayName` annotation from JUnit 5

#### Structure

```
class CalculatorTest {

    @Test
    @DisplayName("Should sum up correctly two numbers")
    void shouldSumUpCorrectly() {
        // ...
    }
}
```

### Creation

#### Prefer soft assertions to hard assertions

Hard Assertions are the normal assertion method that will halt the test execution once the actual result is not matching the expected one.
Soft Assertion is a mechanism to run a group of assertions that won’t halt the execution until all the assertions have been executed, showing an error summary when it happens.
It’s more beneficial when we assert multiple attributes from an object.

This project uses the `SoftAssertions.assertSoftly()` method from the AssertJ library, and you can see a lot of already implemented examples in the available tests.
The current usage is done by importing statically the `SoftAssertions` class, using directly the
`assertSoftly()` method.
The assertions are done by using the consumer name, followed by the `assertThat()` method, as the consumer name in the below example is `softly`:

```
SoftAssertions softly = new SoftAssertions();
softly.assertThat(pageable.size()).as("page size is correct").isEqualTo(20);
softly.assertThat(pageable.mode()).as("default page mode is correct")
        .isEqualTo(Pageable.Mode.CURSOR_NEXT);
softly.assertThat(pageable.cursor().getKeysetElement(2)).as("first keySetElement is correct")
        .isEqualTo("First");
});
```

Don't forget to use the `as()` method!
It will be useful to fast identity which assertion is failing.

#### Use the AssertJ method for expected exceptions

Use one of the existing AssertJ methods to test any exception.
Try to write the `assertThat` followed by the exception class name.
Example:
`assertThatIllegalArgumentException()`.

When you can not find a method with a specific exception, use the method
`assertThatThrownBy()`.

### Coverage

#### Verify possible missing scenarios using PIT (pitest)

Sometimes we can forget to test one or two scenarios, and it’s acceptable.
PIT can help us to analyze the code and see the areas not covered by tests applying the mutation testing.

After you finish writing your tests, ensure that the main scenario and corner cases (exception) are covered.
Check it following these steps:

1. Run `mvn clean test-compile -P pitest`
1. Open the `index.html` file located at `target/pit-reports`
1. In the report, click on `jakarta.data.repository` package link
1. Implement new tests focusing on the not covered _Mutation Coverage_
section
   * Click in the class name to see the possible not covered code, marked in red
1. Repeat this process until you have the `Mutation Coverage` covered

NOTE: we don't seek 100% of coverage, but we must make sure the main scenario and all the corner cases have tests.
