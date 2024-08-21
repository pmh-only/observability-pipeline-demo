const process = require('process');
const opentelemetry = require("@opentelemetry/sdk-node");
const { Resource } = require("@opentelemetry/resources");
const { NodeTracerProvider } = require('@opentelemetry/sdk-trace-node');
const { SEMRESATTRS_SERVICE_NAME } = require("@opentelemetry/semantic-conventions");
const { BatchSpanProcessor} = require('@opentelemetry/sdk-trace-base');
const { OTLPTraceExporter } = require('@opentelemetry/exporter-trace-otlp-grpc');
const { AWSXRayPropagator } = require("@opentelemetry/propagator-aws-xray");
const { AWSXRayIdGenerator } = require("@opentelemetry/id-generator-aws-xray");
const { HttpInstrumentation } = require("@opentelemetry/instrumentation-http");
const { AwsInstrumentation } = require("@opentelemetry/instrumentation-aws-sdk");
const { detectResourcesSync } = require('@opentelemetry/resources')
const { awsEc2Detector } = require('@opentelemetry/resource-detector-aws')
const { ExpressInstrumentation } = require('@opentelemetry/instrumentation-express');

// const { DiagConsoleLogger, DiagLogLevel, diag } = require('@opentelemetry/api');
// diag.setLogger(new DiagConsoleLogger(), DiagLogLevel.DEBUG);

const resource = detectResourcesSync({
   detectors: [awsEc2Detector],
})
const _resource = Resource.default().merge(new Resource({
        [SEMRESATTRS_SERVICE_NAME]: "otel-application",
    })).merge(resource);
const _traceExporter = new OTLPTraceExporter();
const _spanProcessor = new BatchSpanProcessor(_traceExporter);
const _tracerConfig = {
    idGenerator: new AWSXRayIdGenerator(),
}

async function nodeSDKBuilder() {
    const sdk = new opentelemetry.NodeSDK({
        textMapPropagator: new AWSXRayPropagator(),
        instrumentations: [
            new HttpInstrumentation(),
            new ExpressInstrumentation(),
            new AwsInstrumentation({
                suppressInternalInstrumentation: true
            }),
        ],
        resource: _resource,
        spanProcessor: _spanProcessor,
        traceExporter: _traceExporter,
    });
    sdk.configureTracerProvider(_tracerConfig, _spanProcessor);

    // this enables the API to record telemetry
    await sdk.start();
    // gracefully shut down the SDK on process exit
    process.on('SIGINT', () => {
      sdk.shutdown()
        .then(() => console.log('Tracing and Metrics terminated'))
        .catch((error) => console.log('Error terminating tracing and metrics', error))
        .finally(() => process.exit(0));
      });
    process.on('SIGTERM', () => {
    sdk.shutdown()
      .then(() => console.log('Tracing and Metrics terminated'))
      .catch((error) => console.log('Error terminating tracing and metrics', error))
      .finally(() => process.exit(0));
    });
}

module.exports = { nodeSDKBuilder }
