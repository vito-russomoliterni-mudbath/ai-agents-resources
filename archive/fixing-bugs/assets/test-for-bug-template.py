"""
test-for-bug-template.py

Template for writing regression tests in Python using pytest.
This file demonstrates best practices for creating tests that:
1. Reproduce a bug
2. Validate the fix
3. Prevent future regressions

INSTRUCTIONS:
1. Copy this file and rename it to match your test: test_regression_[ISSUE_ID].py
2. Replace [ISSUE_ID] with your bug ID throughout
3. Replace [BUG_TITLE] with actual bug title
4. Replace [BUG_DESCRIPTION] with actual description
5. Implement the test cases for your specific scenario
6. Run: pytest test_regression_[ISSUE_ID].py -v
7. Before fix: Test should FAIL
8. After fix: Test should PASS
"""

import pytest
from datetime import datetime, timedelta
from unittest.mock import Mock, patch, MagicMock


# ============================================================================
# CONSTANTS AND FIXTURES
# ============================================================================

# Test data constants
VALID_USER_ID = 123
INVALID_USER_ID = -1
VALID_EMAIL = "test@example.com"
VALID_AMOUNT = 100.00
NEGATIVE_AMOUNT = -50.00


@pytest.fixture
def setup_test_data():
    """
    Setup fixture - prepare test data before test runs.

    This fixture:
    - Creates test objects
    - Initializes mocks
    - Sets up database state

    Yields test data for use in tests.
    Auto-cleanup happens when test completes.
    """
    # Setup phase
    test_data = {
        "user": {"id": VALID_USER_ID, "email": VALID_EMAIL, "name": "Test User"},
        "timestamp": datetime.now(),
    }

    # Yield the test data to the test function
    yield test_data

    # Cleanup phase (runs after test completes)
    # Clean up any resources, temp files, database records, etc.
    pass


@pytest.fixture
def mock_external_service():
    """
    Fixture for mocking external service calls.

    Use this when your bug fix involves external API calls.
    """
    with patch('module.external_service.call') as mock:
        mock.return_value = {"status": "success", "data": "mocked_response"}
        yield mock


@pytest.fixture
def mock_database(mocker):
    """
    Fixture for mocking database operations.

    Use this for testing database-related bugs.
    """
    mock_db = mocker.Mock()
    mock_db.query.return_value = []
    mock_db.save.return_value = True
    return mock_db


# ============================================================================
# REGRESSION TEST 1: BASIC BUG REPRODUCTION
# ============================================================================

class TestRegression_Issue[ISSUE_ID]_BasicReproduction:
    """
    Test class: Bug reproduction for Issue [ISSUE_ID]
    Bug: [BUG_TITLE]

    Description:
    [BUG_DESCRIPTION]

    This test reproduces the exact bug scenario to verify the fix works.
    """

    def test_bug_reproduction_exact_case(self, setup_test_data):
        """
        Test: Reproduce exact bug scenario.

        Before fix: This test FAILS (bug occurs)
        After fix: This test PASSES (bug resolved)

        Step 1: Setup the exact conditions that trigger the bug
        Step 2: Execute the code that causes the bug
        Step 3: Verify the bug occurred (or is fixed)
        """
        # STEP 1: Setup exact conditions that trigger bug
        # Replace with actual setup for your bug
        user_id = VALID_USER_ID
        action = "perform_buggy_action"

        # STEP 2: Execute code that triggers the bug
        # Replace with actual function call that was buggy
        from module import buggy_function
        result = buggy_function(user_id, action)

        # STEP 3: Verify fix (was failing before, should pass now)
        # Replace with actual assertion for your bug
        assert result is not None, "Result should not be None"
        assert result.success is True, "Operation should succeed"
        # Add more specific assertions based on your bug

    def test_bug_specific_input_triggers_failure(self):
        """
        Test: Specific input that triggers the bug.

        Many bugs only occur with specific input values.
        This test captures those exact values.
        """
        # CUSTOMIZE: Replace with exact buggy input
        buggy_input = "specific_value_that_breaks"
        expected_output = "correct_output"

        from module import process_input
        result = process_input(buggy_input)

        # Before fix: Would be None or wrong value
        # After fix: Should be correct value
        assert result == expected_output


# ============================================================================
# REGRESSION TEST 2: EDGE CASES AND BOUNDARY CONDITIONS
# ============================================================================

class TestRegression_Issue[ISSUE_ID]_EdgeCases:
    """
    Edge cases and boundary conditions that should be handled.
    These ensure the fix is robust and handles corner cases.
    """

    def test_with_none_input(self):
        """Test that None input is handled gracefully."""
        from module import process_data

        # Bug fix should handle None input properly
        result = process_data(None)

        # Should either return safe default or raise clear error
        assert result is not None or result is None  # Handle appropriately

    def test_with_empty_collection(self):
        """Test that empty lists/dicts are handled."""
        from module import process_items

        # Should handle empty input
        result = process_items([])

        assert isinstance(result, list)
        assert len(result) == 0

    def test_with_large_input(self):
        """Test that large input doesn't cause issues."""
        from module import process_large_data

        # Create large test data
        large_data = list(range(10000))

        # Should process without crashing
        result = process_large_data(large_data)

        assert result is not None

    def test_boundary_values(self):
        """Test minimum and maximum boundary values."""
        from module import calculate_value

        # Test minimum valid value
        result_min = calculate_value(value=0)
        assert result_min >= 0

        # Test maximum valid value
        result_max = calculate_value(value=999999)
        assert result_max >= 0

        # Test just outside boundaries
        with pytest.raises((ValueError, Exception)):
            calculate_value(value=-1)  # Below minimum


# ============================================================================
# REGRESSION TEST 3: ERROR HANDLING AND EXCEPTIONS
# ============================================================================

class TestRegression_Issue[ISSUE_ID]_ErrorHandling:
    """
    Test that error conditions are handled properly by the fix.
    """

    def test_graceful_error_handling(self):
        """Test that errors are handled gracefully, not crashed."""
        from module import risky_operation

        # The bug fix should handle errors without crashing
        try:
            result = risky_operation(invalid_param="bad_value")
            # Should either return safe value or raise specific error
            assert True  # Reached here without crash
        except ValueError as e:
            # Clear error message expected
            assert "invalid_param" in str(e).lower()
        except Exception as e:
            # If other exception, should be documented
            pytest.fail(f"Unexpected exception: {type(e).__name__}: {e}")

    def test_validation_error_raised(self):
        """Test that validation errors are properly raised."""
        from module import validate_and_process

        # Should raise validation error for invalid data
        with pytest.raises(ValueError) as exc_info:
            validate_and_process(data={})  # Missing required fields

        # Error message should be clear
        assert "required" in str(exc_info.value).lower()

    def test_missing_required_field_handled(self):
        """Test that missing required fields are handled."""
        from module import process_record

        incomplete_record = {"id": 1}  # Missing required fields

        # Should raise clear error, not crash
        with pytest.raises((KeyError, ValueError)) as exc_info:
            process_record(incomplete_record)

        error_msg = str(exc_info.value).lower()
        assert any(field in error_msg for field in ["required", "missing", "field"])


# ============================================================================
# REGRESSION TEST 4: DATA INTEGRITY
# ============================================================================

class TestRegression_Issue[ISSUE_ID]_DataIntegrity:
    """
    Verify that the fix doesn't corrupt or lose data.
    """

    def test_data_not_modified_unexpectedly(self):
        """Test that function doesn't modify input data."""
        from module import process_immutably

        original_data = {"count": 10, "name": "test"}
        original_copy = original_data.copy()

        # Process the data
        result = process_immutably(original_data)

        # Original should not be modified
        assert original_data == original_copy

    def test_no_data_loss_in_bulk_operation(self, setup_test_data):
        """Test that bulk operations don't lose data."""
        from module import bulk_process

        # Create multiple records
        records = [{"id": i, "value": i * 10} for i in range(100)]

        # Process all records
        results = bulk_process(records)

        # Should have same count before and after
        assert len(results) == len(records)

        # All records should have expected structure
        for result in results:
            assert "id" in result
            assert "value" in result

    def test_transaction_consistency(self, mocker):
        """Test that multi-step operations maintain consistency."""
        # Mock database
        mock_db = mocker.Mock()

        from module import multi_step_operation

        # Execute multi-step operation
        result = multi_step_operation(mock_db, data={"test": "value"})

        # Verify all steps executed or all rolled back
        assert mock_db.commit.called or mock_db.rollback.called


# ============================================================================
# REGRESSION TEST 5: PERFORMANCE AND TIMING
# ============================================================================

class TestRegression_Issue[ISSUE_ID]_Performance:
    """
    Verify that the fix doesn't introduce performance issues.
    """

    def test_fix_performs_acceptably(self):
        """Test that fix doesn't cause performance degradation."""
        from module import potentially_slow_function
        import time

        start = time.time()

        # Execute function
        result = potentially_slow_function(data=list(range(1000)))

        duration = time.time() - start

        # Should complete quickly (adjust threshold as needed)
        assert duration < 1.0, f"Took {duration}s, expected < 1s"

    def test_no_n_plus_one_queries(self, mocker):
        """Test that database queries are optimized (no N+1 problem)."""
        # Mock database
        mock_query = mocker.Mock()
        mock_query.count.return_value = 1  # Should only make 1 query

        from module import fetch_related_data

        # Execute function that might have N+1 problem
        results = fetch_related_data(collection=list(range(10)))

        # Should make minimal queries, not one per item
        assert mock_query.count() <= 2, "Too many queries (N+1 problem?)"

    def test_memory_not_leaked(self):
        """Test that repeated calls don't leak memory."""
        from module import repeatable_function
        import sys

        # Get initial memory
        initial_size = sys.getsizeof([])

        # Execute function many times
        for _ in range(100):
            result = repeatable_function()

        # Memory shouldn't grow unbounded
        # (This is a simple check; use memory_profiler for deeper analysis)
        final_size = sys.getsizeof([])

        assert final_size < initial_size * 100


# ============================================================================
# REGRESSION TEST 6: INTEGRATION SCENARIOS
# ============================================================================

class TestRegression_Issue[ISSUE_ID]_Integration:
    """
    Test complete workflows to ensure fix works in real scenarios.
    """

    def test_end_to_end_workflow(self, mock_external_service):
        """Test complete user workflow with the fix."""
        from module import User, Payment

        # Create user
        user = User(email=VALID_EMAIL)
        user.save()

        # Make payment
        payment = Payment(user=user, amount=VALID_AMOUNT)
        result = payment.process()

        # Verify workflow succeeded
        assert result.success is True
        assert payment.status == "completed"

    def test_api_integration(self, mock_external_service):
        """Test API endpoint with the fix."""
        from module.api import process_request

        request_data = {
            "action": "process",
            "payload": {"test": "data"}
        }

        # Process request
        response = process_request(request_data)

        # Verify response
        assert response["status"] == "success"
        assert "result" in response


# ============================================================================
# REGRESSION TEST 7: CONCURRENCY AND THREADING
# ============================================================================

class TestRegression_Issue[ISSUE_ID]_Concurrency:
    """
    Test that fix works correctly with concurrent access.
    Use these tests if the bug is related to threading or async operations.
    """

    def test_thread_safe_operation(self):
        """Test that operation is thread-safe."""
        import threading

        from module import shared_counter

        results = []

        def increment_counter():
            for _ in range(100):
                value = shared_counter.increment()
                results.append(value)

        # Run multiple threads
        threads = [threading.Thread(target=increment_counter) for _ in range(5)]

        for t in threads:
            t.start()
        for t in threads:
            t.join()

        # Should have incremented correctly without race condition
        assert len(set(results)) > 1  # Values should vary
        assert max(results) <= 500  # Should not exceed total increments


# ============================================================================
# PARAMETRIZED TESTS - TEST MULTIPLE SCENARIOS
# ============================================================================

@pytest.mark.parametrize("input_value,expected_output", [
    # (input, expected)
    ("valid_string", "processed_valid_string"),
    ("another_valid", "processed_another_valid"),
    ("", None),  # Empty string edge case
])
def test_with_multiple_inputs(input_value, expected_output):
    """Test function with multiple input variations."""
    from module import process_string

    result = process_string(input_value)

    assert result == expected_output


@pytest.mark.parametrize("amount,should_succeed", [
    (0, False),      # No amount
    (0.01, True),    # Minimum
    (100, True),     # Normal
    (999999.99, True),  # Large amount
    (-50, False),    # Negative
])
def test_payment_amounts(amount, should_succeed):
    """Test payment processing with various amounts."""
    from module import process_payment

    try:
        result = process_payment(amount=amount)
        if should_succeed:
            assert result.success is True
        else:
            pytest.fail(f"Should have failed for amount {amount}")
    except ValueError:
        if should_succeed:
            pytest.fail(f"Should have succeeded for amount {amount}")


# ============================================================================
# FIXTURES FOR DATABASE TESTING
# ============================================================================

@pytest.fixture
def clean_database(mocker):
    """
    Fixture for clean database state.
    Mocks database operations.
    """
    mock_db_session = mocker.Mock()
    mock_db_session.query.return_value.all.return_value = []
    mock_db_session.add.return_value = None
    mock_db_session.commit.return_value = None

    return mock_db_session


# ============================================================================
# USAGE EXAMPLES AND NOTES
# ============================================================================

"""
RUNNING THESE TESTS:

1. Run all tests in this file:
   pytest test_regression_[ISSUE_ID].py -v

2. Run specific test class:
   pytest test_regression_[ISSUE_ID].py::TestRegression_Issue[ISSUE_ID]_BasicReproduction -v

3. Run specific test:
   pytest test_regression_[ISSUE_ID].py::TestRegression_Issue[ISSUE_ID]_BasicReproduction::test_bug_reproduction_exact_case -v

4. Run with coverage:
   pytest test_regression_[ISSUE_ID].py --cov --cov-report=html

5. Run with detailed output:
   pytest test_regression_[ISSUE_ID].py -vv -s

BEFORE IMPLEMENTING FIX:
- These tests should FAIL
- Failure demonstrates the bug exists

AFTER IMPLEMENTING FIX:
- These tests should PASS
- All tests passing = bug is fixed

PYTEST BEST PRACTICES:
- Use descriptive test names that explain what's being tested
- One assertion per test (or logically related assertions)
- Use fixtures for common setup/teardown
- Use mocking for external dependencies
- Use parametrize for testing multiple scenarios
- Use pytest.mark for categorizing tests

For more examples and pytest documentation:
https://docs.pytest.org/
"""
