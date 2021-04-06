import grpc
from concurrent import futures
import time

from service_spec import stanza_pb2
from service_spec import stanza_pb2_grpc

import stanza_nlp

import json

class stanza_nlpServicer(stanza_pb2_grpc.stanza_nlpServicer):

    def preprocess(self, request, context):
        print(request.value)
        response = stanza_pb2.stanzaMessage()
        response.value = stanza_nlp.preprocess(request.value)

        # print(response)
        return response



server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
stanza_pb2_grpc.add_stanza_nlpServicer_to_server(stanza_nlpServicer(), server)

print('Starting server. Listening on port 2379.')
server.add_insecure_port('localhost:2379')
server.start()

try:
    while True:
        time.sleep(86400)
except KeyboardInterrupt:
    server.stop(0)