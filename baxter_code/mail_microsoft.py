import csv
from redmail import outlook
with open("D:\Desktop\mail_details.csv") as file:
    outlook.username = "ashish679123@outlook.com"
    outlook.password = "W@lcome@7654"
    reader = csv.reader(file)
    next(reader)  # Skip header row
    for LastName, FirstName, ToEmail, FromEmail in reader:
        print(f"Sending email to {ToEmail}")
        # Send email here
        outlook.send(
            sender=FromEmail,
            receivers=[ToEmail],
            subject="An example",
            text="Hi, this is an example."
        )
