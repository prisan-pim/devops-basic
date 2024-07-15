import http from 'k6/http';
import { check, sleep } from "k6";

const isNumeric = (value) => /^\d+$/.test(value);

const default_vus = 5;

const target_vus_env = `${__ENV.TARGET_VUS}`;
const target_vus = isNumeric(target_vus_env) ? Number(target_vus_env) : default_vus;

export let options = {
  stages: [
      
      { duration: "10m", target: target_vus },

      { duration: "60s", target: target_vus },

      { duration: "5s", target: 0 }
  ]
};

export default function () {
  const response = http.get("https://api-kube.demo.com/api/report", {headers: {Accepts: "application/json"}});
  check(response, { "status is 200": (r) => r.status === 200 });
  sleep(.300);
};
