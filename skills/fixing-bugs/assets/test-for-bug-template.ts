/**
 * test-for-bug-template.ts
 *
 * Template for writing regression tests in TypeScript using Jest or Vitest.
 * This file demonstrates best practices for creating tests that:
 * 1. Reproduce a bug
 * 2. Validate the fix
 * 3. Prevent future regressions
 *
 * INSTRUCTIONS:
 * 1. Copy this file and rename it: regression.[ISSUE_ID].test.ts
 * 2. Replace [ISSUE_ID] with your bug ID throughout
 * 3. Replace [BUG_TITLE] with actual bug title
 * 4. Replace [BUG_DESCRIPTION] with actual description
 * 5. Implement the test cases for your specific scenario
 * 6. Run: npm test -- regression.[ISSUE_ID].test.ts
 * 7. Before fix: Test should FAIL
 * 8. After fix: Test should PASS
 *
 * FRAMEWORKS SUPPORTED:
 * - Jest
 * - Vitest
 */

import { describe, it, expect, beforeEach, afterEach, vi } from "vitest";
// OR for Jest: import { describe, it, expect, beforeEach, afterEach, jest } from "@jest/globals";


// ============================================================================
// TYPES AND INTERFACES
// ============================================================================

interface TestUser {
  id: number;
  email: string;
  name: string;
  isActive?: boolean;
}

interface TestPayment {
  id?: string;
  userId: number;
  amount: number;
  status?: "pending" | "completed" | "failed";
  timestamp?: Date;
}

interface ApiResponse<T> {
  success: boolean;
  data?: T;
  error?: string;
}


// ============================================================================
// CONSTANTS AND FIXTURES
// ============================================================================

const VALID_USER_ID = 123;
const INVALID_USER_ID = -1;
const VALID_EMAIL = "test@example.com";
const VALID_AMOUNT = 100.00;
const NEGATIVE_AMOUNT = -50.00;

// Test data factory functions
function createTestUser(overrides?: Partial<TestUser>): TestUser {
  return {
    id: VALID_USER_ID,
    email: VALID_EMAIL,
    name: "Test User",
    isActive: true,
    ...overrides,
  };
}

function createTestPayment(overrides?: Partial<TestPayment>): TestPayment {
  return {
    userId: VALID_USER_ID,
    amount: VALID_AMOUNT,
    status: "pending",
    timestamp: new Date(),
    ...overrides,
  };
}


// ============================================================================
// SETUP AND TEARDOWN
// ============================================================================

describe("Regression Tests for Issue [ISSUE_ID]", () => {
  // Shared setup that runs before each test
  beforeEach(() => {
    // Clear any mocks, reset state, etc.
    vi.clearAllMocks();
  });

  // Cleanup that runs after each test
  afterEach(() => {
    // Clean up any resources, timers, etc.
    vi.clearAllTimers();
  });


  // ==========================================================================
  // REGRESSION TEST 1: BASIC BUG REPRODUCTION
  // ==========================================================================

  describe("Basic Bug Reproduction - Issue [ISSUE_ID]", () => {
    /**
     * Bug: [BUG_TITLE]
     *
     * Description:
     * [BUG_DESCRIPTION]
     *
     * This test reproduces the exact bug scenario to verify the fix works.
     * Before fix: This test FAILS (bug occurs)
     * After fix: This test PASSES (bug resolved)
     */

    it("should reproduce exact bug scenario", () => {
      // STEP 1: Setup exact conditions that trigger bug
      const userId = VALID_USER_ID;
      const action = "perform_buggy_action";

      // STEP 2: Execute code that triggers the bug
      // Replace with actual function call that was buggy
      // const result = buggyFunction(userId, action);

      // STEP 3: Verify fix (was failing before, should pass now)
      // Replace with actual assertion for your bug
      // expect(result).toBeDefined();
      // expect(result.success).toBe(true);

      // Placeholder - replace with actual test
      expect(true).toBe(true);
    });

    it("should handle specific input that triggered the failure", () => {
      // CUSTOMIZE: Replace with exact buggy input
      const buggyInput = "specific_value_that_breaks";
      const expectedOutput = "correct_output";

      // Replace with actual function call
      // const result = processInput(buggyInput);

      // Before fix: Would be null or wrong value
      // After fix: Should be correct value
      // expect(result).toBe(expectedOutput);

      expect(true).toBe(true);
    });

    it("should reproduce consistently, not intermittently", () => {
      // Run the buggy operation multiple times
      // If it's a race condition, repeat is important
      for (let i = 0; i < 5; i++) {
        // const result = operationThatHadRaceBug();
        // expect(result).toHaveConsistentBehavior();
      }

      expect(true).toBe(true);
    });
  });


  // ==========================================================================
  // REGRESSION TEST 2: EDGE CASES AND BOUNDARY CONDITIONS
  // ==========================================================================

  describe("Edge Cases and Boundary Conditions", () => {
    it("should handle null input gracefully", () => {
      // Replace with actual function
      // const result = processData(null);

      // Should either return safe default or throw clear error
      // expect(result).toBeDefined();
      // or
      // expect(() => processData(null)).toThrow("Invalid input");

      expect(true).toBe(true);
    });

    it("should handle undefined input gracefully", () => {
      // Replace with actual function
      // const result = processData(undefined);

      // expect(result).toBeDefined();

      expect(true).toBe(true);
    });

    it("should handle empty collections", () => {
      // Replace with actual function
      // const result = processItems([]);

      // expect(Array.isArray(result)).toBe(true);
      // expect(result).toHaveLength(0);

      expect(true).toBe(true);
    });

    it("should handle empty strings", () => {
      // Replace with actual function
      // const result = processString("");

      // expect(result).toBeDefined();

      expect(true).toBe(true);
    });

    it("should handle maximum boundary values", () => {
      // Replace with actual function
      // const result = calculateValue(Number.MAX_SAFE_INTEGER);

      // expect(result).toBeDefined();
      // expect(typeof result).toBe("number");

      expect(true).toBe(true);
    });

    it("should handle minimum boundary values", () => {
      // Replace with actual function
      // const result = calculateValue(0);

      // expect(result).toBeDefined();

      expect(true).toBe(true);
    });

    it("should reject negative values when appropriate", () => {
      // Replace with actual function
      // expect(() => processAmount(-50)).toThrow();

      expect(true).toBe(true);
    });
  });


  // ==========================================================================
  // REGRESSION TEST 3: ERROR HANDLING
  // ==========================================================================

  describe("Error Handling", () => {
    it("should throw clear error on invalid input", () => {
      // Replace with actual function
      // expect(() => validateAndProcess({ })).toThrow(/required.*field/i);

      expect(true).toBe(true);
    });

    it("should provide helpful error message", () => {
      try {
        // Replace with actual function that should fail
        // riskyOperation({ invalid: "param" });
        expect.fail("Should have thrown");
      } catch (error) {
        // Error message should be clear
        // expect((error as Error).message).toContain("invalid");
      }
    });

    it("should handle missing required fields", () => {
      const incompleteData = { id: 1 };

      // Replace with actual function
      // expect(() => processRecord(incompleteData)).toThrow(/required|missing/);

      expect(true).toBe(true);
    });

    it("should handle external service errors gracefully", async () => {
      // Mock service to throw error
      const mockService = vi.fn().mockRejectedValue(new Error("Service unavailable"));

      // Replace with actual async function
      // await expect(callExternalService()).rejects.toThrow();

      expect(mockService).toHaveBeenCalledTimes(0);
    });
  });


  // ==========================================================================
  // REGRESSION TEST 4: DATA INTEGRITY
  // ==========================================================================

  describe("Data Integrity", () => {
    it("should not modify input data unexpectedly", () => {
      const originalData = { count: 10, name: "test" };
      const originalCopy = JSON.parse(JSON.stringify(originalData));

      // Replace with actual function
      // const result = processData(originalData);

      // Original should not be modified
      expect(originalData).toEqual(originalCopy);
    });

    it("should not lose data during bulk operations", () => {
      const records = Array.from({ length: 100 }, (_, i) => ({
        id: i,
        value: i * 10,
      }));

      // Replace with actual function
      // const results = bulkProcess(records);

      // Should have same count before and after
      // expect(results).toHaveLength(records.length);
      // results.forEach((result, index) => {
      //   expect(result.id).toBe(records[index].id);
      //   expect(result.value).toBe(records[index].value);
      // });

      expect(records).toHaveLength(100);
    });

    it("should maintain referential integrity", () => {
      const user = createTestUser();
      const payment = createTestPayment({ userId: user.id });

      // Replace with actual function that checks referential integrity
      // const result = validateReferentialIntegrity(user, payment);

      // expect(result).toBe(true);

      expect(user.id).toBe(payment.userId);
    });

    it("should handle concurrent updates correctly", async () => {
      // Simulate concurrent updates
      const promises = [
        // replace with actual concurrent operations
        Promise.resolve(1),
        Promise.resolve(2),
        Promise.resolve(3),
      ];

      const results = await Promise.all(promises);

      expect(results).toHaveLength(3);
    });
  });


  // ==========================================================================
  // REGRESSION TEST 5: TYPE SAFETY
  // ==========================================================================

  describe("Type Safety", () => {
    it("should enforce type constraints", () => {
      const user: TestUser = createTestUser();

      // Type should be correct
      expect(typeof user.id).toBe("number");
      expect(typeof user.email).toBe("string");
      expect(typeof user.name).toBe("string");
    });

    it("should not accept wrong types", () => {
      // TypeScript compilation would catch this, but test runtime if using any
      // const wrongUser: TestUser = {
      //   id: "not-a-number",  // ❌ TypeScript error
      //   email: "test@example.com",
      //   name: "Test"
      // };

      const correctUser: TestUser = {
        id: 123,
        email: "test@example.com",
        name: "Test",
      };

      expect(correctUser.id).toBeGreaterThan(0);
    });

    it("should validate optional fields", () => {
      const userWithOptional: TestUser = {
        id: 123,
        email: "test@example.com",
        name: "Test",
        isActive: true,
      };

      const userWithoutOptional: TestUser = {
        id: 123,
        email: "test@example.com",
        name: "Test",
      };

      expect(userWithOptional.isActive).toBe(true);
      expect(userWithoutOptional.isActive).toBeUndefined();
    });
  });


  // ==========================================================================
  // REGRESSION TEST 6: ASYNC OPERATIONS
  // ==========================================================================

  describe("Async Operations", () => {
    it("should handle async operations correctly", async () => {
      // Replace with actual async function
      // const result = await fetchData(VALID_USER_ID);

      // expect(result).toBeDefined();

      const result = await Promise.resolve({ data: "test" });
      expect(result.data).toBe("test");
    });

    it("should handle async errors", async () => {
      // Replace with actual async function that throws
      // await expect(fetchDataThatFails()).rejects.toThrow();

      const failingOperation = async () => {
        throw new Error("Operation failed");
      };

      await expect(failingOperation()).rejects.toThrow("Operation failed");
    });

    it("should handle concurrent async operations", async () => {
      // Replace with actual concurrent async operations
      // const results = await Promise.all([
      //   fetchUser(1),
      //   fetchUser(2),
      //   fetchUser(3),
      // ]);

      const mockFetch = vi.fn().mockResolvedValue({ id: 123 });
      const results = await Promise.all([
        mockFetch(1),
        mockFetch(2),
        mockFetch(3),
      ]);

      expect(results).toHaveLength(3);
      expect(mockFetch).toHaveBeenCalledTimes(3);
    });

    it("should not have race conditions", async () => {
      // Simulate operations that might have race condition
      let counter = 0;
      const increment = async () => {
        counter++;
        await new Promise(resolve => setTimeout(resolve, 1));
        counter++;
      };

      await Promise.all([increment(), increment(), increment()]);

      // Should be 6 (3 increments × 2 operations each)
      expect(counter).toBe(6);
    });

    it("should timeout appropriately", async () => {
      const slowOperation = new Promise(resolve =>
        setTimeout(() => resolve("done"), 10000)
      );

      const timeoutPromise = Promise.race([
        slowOperation,
        new Promise((_, reject) =>
          setTimeout(() => reject(new Error("Timeout")), 100)
        ),
      ]);

      await expect(timeoutPromise).rejects.toThrow("Timeout");
    });
  });


  // ==========================================================================
  // REGRESSION TEST 7: PARAMETERIZED TESTS
  // ==========================================================================

  describe.each([
    { input: "valid_string", expected: "processed_valid_string" },
    { input: "another_valid", expected: "processed_another_valid" },
    { input: "", expected: null },
    { input: "   spaces   ", expected: "processed_spaces" },
  ])("Parameterized Tests - Input: $input", ({ input, expected }) => {
    it(`should process "${input}" to "${expected}"`, () => {
      // Replace with actual function
      // const result = processString(input);

      // expect(result).toBe(expected);

      expect(input).toBeDefined();
    });
  });


  // ==========================================================================
  // REGRESSION TEST 8: MOCKING AND SPYING
  // ==========================================================================

  describe("Mocking and Spying", () => {
    it("should call dependency correctly", () => {
      const mockDependency = vi.fn().mockReturnValue("mocked_response");

      // Replace with actual code that uses the dependency
      // const result = functionUsingDependency(mockDependency);

      expect(mockDependency).not.toHaveBeenCalled();
    });

    it("should spy on function calls", () => {
      const obj = {
        method: vi.fn().mockReturnValue("result"),
      };

      obj.method("arg1", "arg2");

      expect(obj.method).toHaveBeenCalledWith("arg1", "arg2");
      expect(obj.method).toHaveBeenCalledTimes(1);
    });

    it("should mock external API calls", async () => {
      const mockApi = vi.fn().mockResolvedValue({
        success: true,
        data: { id: 123 },
      });

      const response = await mockApi();

      expect(response.success).toBe(true);
      expect(response.data.id).toBe(123);
    });

    it("should handle mock rejections", async () => {
      const mockApi = vi.fn().mockRejectedValue(new Error("API Error"));

      await expect(mockApi()).rejects.toThrow("API Error");
    });
  });


  // ==========================================================================
  // REGRESSION TEST 9: SNAPSHOT TESTING
  // ==========================================================================

  describe("Snapshot Testing", () => {
    it("should match expected output snapshot", () => {
      const user = createTestUser();

      // Snapshot captures exact output
      expect(user).toMatchSnapshot();
    });

    it("should match nested object snapshot", () => {
      const payment = createTestPayment();

      // Update snapshot with: npm test -- -u
      expect(payment).toMatchSnapshot();
    });
  });


  // ==========================================================================
  // REGRESSION TEST 10: INTEGRATION TEST
  // ==========================================================================

  describe("Integration Test - Complete Workflow", () => {
    it("should complete end-to-end workflow", async () => {
      // Create user
      const user = createTestUser();

      // Create payment for user
      const payment = createTestPayment({ userId: user.id });

      // Process payment
      // Replace with actual functions
      // const result = await processPaymentWorkflow(user, payment);

      // Verify workflow
      // expect(result.success).toBe(true);
      // expect(result.paymentId).toBeDefined();

      expect(payment.userId).toBe(user.id);
    });
  });

});


// ============================================================================
// USAGE NOTES AND DOCUMENTATION
// ============================================================================

/**
 * RUNNING THESE TESTS:
 *
 * 1. Run all tests in this file:
 *    npm test -- regression.[ISSUE_ID].test.ts
 *
 * 2. Run in watch mode:
 *    npm test -- --watch
 *
 * 3. Run specific test suite:
 *    npm test -- -t "Basic Bug Reproduction"
 *
 * 4. Run with coverage:
 *    npm test -- --coverage
 *
 * 5. Update snapshots:
 *    npm test -- -u
 *
 * BEST PRACTICES:
 *
 * - Use descriptive test names that explain what's being tested
 * - One assertion per test (or logically related assertions)
 * - Use beforeEach/afterEach for common setup/teardown
 * - Use mocking for external dependencies
 * - Use describe.each for parameterized tests
 * - Use snapshot testing for complex objects
 *
 * JEST VS VITEST:
 *
 * Both frameworks have similar APIs:
 * - describe() / it() - Define test suites and tests
 * - expect() - Assertions
 * - beforeEach() / afterEach() - Setup/teardown
 * - vi.fn() / jest.fn() - Mocking
 *
 * Main differences:
 * - Vitest is faster (ESM-first)
 * - Jest has broader ecosystem support
 * - Import paths differ slightly
 *
 * BEFORE IMPLEMENTING FIX:
 * - These tests should FAIL
 * - Failure demonstrates the bug exists
 *
 * AFTER IMPLEMENTING FIX:
 * - These tests should PASS
 * - All tests passing = bug is fixed
 *
 * For more info:
 * - Jest: https://jestjs.io/docs/getting-started
 * - Vitest: https://vitest.dev/
 */
