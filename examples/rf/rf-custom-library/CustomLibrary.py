from robot.api.deco import keyword

class CustomLibrary:
    
    def __init__(self):
        pass

    @keyword("Say Hello")
    def say_hello(self, name):
        """Logs a greeting message for the given name."""
        print(f"Hello, {name}!")

    @keyword("Add Numbers")
    def add_numbers(self, a, b):
        """Adds two numbers and returns the result."""
        # This is wrong because a and b can be strings!
        # return a + b
        return int(a) + int(b)