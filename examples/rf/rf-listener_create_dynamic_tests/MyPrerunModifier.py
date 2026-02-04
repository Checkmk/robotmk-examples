from robot.api import SuiteVisitor
# This prerun modifier creates 3 dynamic tests based on a single "tmeplate" test in the suite.
# The template itself is removed from the suite.

class MyPrerunModifier(SuiteVisitor):
    def start_suite(self, suite):
        tests = []
        if suite.tests:
            for i in range(1, 4):
                new_test = suite.tests[0].deepcopy()
                new_test.name = f"test number {i}"
                tests.append(new_test)        
            suite.tests.clear()
            suite.tests.extend(tests)
            pass