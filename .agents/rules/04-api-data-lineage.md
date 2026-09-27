# API and Data Lineage
APIs are contracts. Business values must trace from DB through backend services/serializers into Flutter models/state/UI. Keep loading, success, empty, authentication failure, authorization failure, validation failure, network failure and server failure distinct. Never turn errors into fake success.
