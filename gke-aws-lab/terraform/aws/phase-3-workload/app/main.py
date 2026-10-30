import time
import psutil
from fastapi import FastAPI, Response
from prometheus_client import Counter, Histogram, generate_latest, CONTENT_TYPE_LATEST

app = FastAPI(title="SRE Simulator Workload")

# Prometheus Metrics. To be used later on the lab.
REQUEST_COUNT = Counter('app_requests_total', 'Total HTTP Requests', ['method', 'endpoint'])
REQUEST_LATENCY = Histogram('app_request_latency_seconds', 'Request latency')

@app.middleware("http")
async def add_process_time_header(request, call_next):
    start_time = time.time()
    response = await call_next(request)
    process_time = time.time() - start_time
    REQUEST_LATENCY.observe(process_time)
    REQUEST_COUNT.labels(method=request.method, endpoint=request.url.path).inc()
    return response

@app.get("/")
def read_root():
    return {"status": "healthy", "message": "EKS Portable Workload Online"}

@app.get("/metrics")
def metrics():
    return Response(generate_latest(), media_type=CONTENT_TYPE_LATEST)

@app.post("/load-test")
def trigger_cpu_load(duration_seconds: int = 5):
    """Simulates CPU load to test HPA and autoscaling metrics. This will make further sense in the upcoming phases of this project"""
    end_time = time.time() + duration_seconds
    while time.time() < end_time:
        _ = [i**2 for i in range(10000)]
    return {"status": "load generated", "duration": duration_seconds, "cpu_percent": psutil.cpu_percent()}