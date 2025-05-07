# 🐳 Swarm Dock — Your Local Docker Swarm Playground

Welcome to **Swarm Dock**, the easiest way to spin up a fully simulated Docker Swarm cluster locally — right on your laptop. This repo is here to help you *learn*, *test*, and *have some fun* with multi-node container orchestration.

---

## 🚀 Why This Exists

I built this because I was working on a project where I needed to scale a set of containerized services across multiple devices. Originally, I was using a single `docker-compose.yml` file to run everything — and it quickly became a bottleneck.

Then I discovered **Docker Swarm** — and it clicked. But I didn’t just want to read about it — I wanted to *see it work*. So I built this project to:

* Simulate a real Swarm cluster (manager + workers)
* Understand how containers get distributed across nodes
* Deploy actual services across those simulated nodes

If you’re like me — hands-on, curious, and into building cool stuff — this is for you. 😎

---

## 🧠 What's Inside

```bash
swarm-dock/
├── nodes/             # Dockerfiles for manager + worker nodes
├── compose/           # Your docker-compose.yml goes here (stack services)
├── scripts/           # Automate the whole show
│   ├── build-nodes.sh       # Build DinD images
│   ├── start-swarm.sh       # Start the cluster
│   ├── deploy-stack.sh      # Deploy services
│   ├── teardown.sh          # Clean up all the things
│   ├── verify-cluster.sh    # Check node + service health
│   └── cluster-stats.sh     # View container memory/CPU usage
└── README.md
```

---

## 🛠 How to Use It

### 1. Build the Node Images

```bash
./scripts/build-nodes.sh
```

### 2. Start the Swarm Locally

```bash
./scripts/start-swarm.sh
```

### 3. Deploy Your Stack

Make sure you’ve got a `compose/docker-compose.yml` file ready.

```bash
./scripts/deploy-stack.sh
```

### 4. Verify Everything’s Alive

```bash
./scripts/verify-cluster.sh
```

### 5. Monitor Stats Like a Boss

```bash
./scripts/cluster-stats.sh
```

### 6. Tear It All Down (Clean Reset)

```bash
./scripts/teardown.sh
```

---

## 🤔 Wait... This Is All Local?

Yup! No VMs, no cloud required. This whole thing runs Docker-in-Docker containers as nodes, so you can simulate everything from your own machine. It’s like a mini data center in your backpack.

---

## 🌊 Swarm Concepts You’ll Learn by Doing

* Manager vs Worker nodes
* Deploying with `docker stack`
* Swarm overlay networking
* Service scaling & placement
* Monitoring resource usage per node

---

## 📦 Example Service (Starter)

If you want a quick demo, drop this in `compose/docker-compose.yml`:

```yaml
services:
  web:
    image: nginx:alpine
    ports:
      - "8080:80"
    deploy:
      replicas: 3
      placement:
        constraints: [node.role == worker]
    networks:
      - webnet

networks:
  webnet:
```

Then run the deploy script again and visit `localhost:8080` — you'll hit one of the NGINX replicas!

---

## 🙌 Shoutout

This project was handcrafted with curiosity, caffeine, and a desire to break down big ideas into bite-sized, buildable systems.

If you dig this repo, feel free to fork it, star it, or make it even better!

Keep building — and swarm on 🐝
