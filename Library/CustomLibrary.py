import requests
import random
import string
from datetime import datetime, timedelta

class CustomLibrary:
    def get_first_five_users(self):
        return self._fetch_users_slice(0, 5)

    def get_last_five_users(self):
        return self._fetch_users_slice(5, 10)

    def _fetch_users_slice(self, start, end):
        """Fetches users from API, augments them, and returns a slice."""
        response = requests.get("https://jsonplaceholder.typicode.com/users", verify=False)
        customers = response.json()

        augmented_users = []
        for idx, user in enumerate(customers[start:end], start=start + 1):
            user["birthday"] = self.get_random_birthday()
            user["password"] = self.generate_password()

            # Safe stateAbbr creation
            address_info = user["address"]
            street_char = str(address_info.get("street", "X"))[0].upper()
            suite_char = str(address_info.get("suite", "X"))[0].upper()
            city_char = str(address_info.get("city", "X"))[0].upper()
            user["address"]["stateAbbr"] = street_char + suite_char + city_char

            # Last seen: random date within the last 30 days
            days_ago = random.randint(1, 30)
            last_seen_date = datetime.now() - timedelta(days=days_ago)
            user["last_seen"] = last_seen_date.strftime("%Y-%m-%d")

            # Orders: 1 to 20
            user["orders"] = random.randint(1, 20)

            # Total Spent
            if idx % 2 != 0:  # odd = high spender
                user["total_spent"] = random.choice([3600, 4500, 5200, 6000, 7500])
            else:  # even = low spender
                user["total_spent"] = random.choice([0, 10, 50, 100, 200])

            augmented_users.append(user)

        print(f"Fetched and augmented {len(augmented_users)} users (slice {start}-{end}).")
        return augmented_users

    def get_random_birthday(self):
        return str(random.randint(1,12)).zfill(2)+str(random.randint(1,28)).zfill(2)+str(random.randint(1999,2006)).zfill(4)

    def generate_password(self, length=8):
        if length < 4:
            raise ValueError("Password length must be at least 4.")
        chars = string.ascii_letters + string.digits + "!@#$%"
        password = [
            random.choice(string.ascii_lowercase),
            random.choice(string.ascii_uppercase),
            random.choice(string.digits),
            random.choice("!@#$%")
        ]
        password += [random.choice(chars) for _ in range(length - 4)]
        random.shuffle(password)
        return ''.join(password)
