import datetime
import os # Example of using another env var

print("Python script start")

# Example: Accessing another environment variable
custom_message = os.getenv("CUSTOM_MESSAGE", "No custom message set.")
print(f"Message: {custom_message}")