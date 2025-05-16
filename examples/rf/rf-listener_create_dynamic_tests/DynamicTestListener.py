from robot.api import logger
from robot.running.model import TestSuite, TestCase
from robot.libraries.BuiltIn import BuiltIn

class DynamicTestListener:
    ROBOT_LISTENER_API_VERSION = 3
    ROBOT_LIBRARY_SCOPE = "GLOBAL"
    

    def __init__(self):
        self.ROBOT_LIBRARY_LISTENER = self
        self.builtin = BuiltIn()
        self.number_of_tests = int(self.builtin.get_variable_value("${NUMBER_OF_TESTS}", default=10))

    def _start_suite(self, suite, result):
        self.current_suite = suite
        for i in range(1, self.number_of_tests + 1):
            test_name = f"Dynamic Test {i}"
            self._create_test_case(suite, test_name)
        for test in suite.tests:    
            if test.name == "Dummy":
                suite.tests.remove(test)

    def _create_test_case(self, suite, test_name):
        test = TestCase(test_name)
        test.body.create_keyword(name="Log", args=[f"Running {test_name}"])
        suite.tests.append(test)

def get_instance():
    return DynamicTestListener()
