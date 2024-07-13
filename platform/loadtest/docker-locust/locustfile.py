from locust import HttpUser, task, between

class WebsiteUser(HttpUser):
    wait_time = between(1, 5)

    @task(1)
    def dashboard(self):
        self.client.get("/api/dashboard")

    @task(2)
    def payment(self):
        self.client.get("/api/payment")

    @task(3)
    def report(self):
        self.client.get("/api/report")
