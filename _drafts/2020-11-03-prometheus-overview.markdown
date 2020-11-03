---
layout: post
title:  "An overview of Prometheus Monitoring Solution"
date:   2020-11-03 20:00:00 +0200
tags:
- prometheus 
- monitoring
- processes
- logs
- timeseries
comments: true
---
# Prometheus

## What is it?
    - open-source 
    - toolkit for monitoring 
    - and alerting
    - based on time series 
    - solution for rough measurements, exporters can restart, and send twice the counters
    - language PromQL for querying time series
    - pull model oriented (push can be done via gateways)
    - support for graphs
    - ... (more [here](https://prometheus.io/docs/introduction/overview/))
## What it is not?
    - accounting solution

## Basic concepts
    - Server
    - Exporters
    - Scraping
    - Time series
    - Dimensions
    - PromQL

## Basic architecture

## *Main* exporters

    - node exporter
    - process exporter
    - gateway exporter
    - grok exporter
    - ... (more [here](https://prometheus.io/docs/instrumenting/exporters/))

## Some usecases

    - get cpu use at 5 yesterday
    - get average daily cpu use of my specific Java application (size your hardware objectively!)
    - get the amount of failures I got in my devices (comes from log lines)

## Q&A


